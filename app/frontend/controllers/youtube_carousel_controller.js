import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["loading", "carousel", "error", "wrapper", "prevBtn", "nextBtn", "dotsContainer", "retryBtn"]
  static values = {
    playlistId: String,
    maxResults: { type: Number, default: 10 },
    autoplay: { type: Boolean, default: true },
    autoplayInterval: { type: Number, default: 5000 }
  }

  connect() {
    this.currentIndex = 0
    this.videos = []
    this.videosPerView = 1
    this.autoplayTimer = null

    this.init()
  }

  disconnect() {
    this.stopAutoplay()
    window.removeEventListener('resize', this.handleResize)
  }

  async init() {
    try {
      await this.loadVideos()
      this.setupResponsive()
      this.renderVideos()
      this.setupNavigation()
      this.setupAutoplay()
      this.showCarousel()
    } catch (error) {
      console.error('Error initializing YouTube carousel:', error)
      this.showError()
    }
  }

  async loadVideos() {
    const response = await fetch(`/api/youtube/playlist/${this.playlistIdValue}`)

    if (!response.ok) {
      throw new Error(`Failed to load videos: ${response.status}`)
    }

    const data = await response.json()
    this.videos = data.videos

    if (!this.videos || this.videos.length === 0) {
      throw new Error('No videos found in playlist')
    }
  }

  setupResponsive() {
    this.handleResize = this.updateVideosPerView.bind(this)
    this.updateVideosPerView()
    window.addEventListener('resize', this.handleResize)
  }

  updateVideosPerView() {
    const width = window.innerWidth
    if (width >= 1024) {
      this.videosPerView = 3
    } else if (width >= 768) {
      this.videosPerView = 2
    } else {
      this.videosPerView = 1
    }
    this.updateCarousel()
  }

  renderVideos() {
    this.wrapperTarget.innerHTML = ''

    this.videos.forEach((video) => {
      const videoEl = document.createElement('div')
      videoEl.className = 'flex-shrink-0 w-full md:w-1/2 lg:w-1/3 px-2'

      const thumbnailUrl = video.thumbnail || `https://img.youtube.com/vi/${video.id}/mqdefault.jpg`

      videoEl.innerHTML = `
        <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition-shadow duration-200 h-full">
          <div class="relative group cursor-pointer" data-action="click->youtube-carousel#openVideo" data-video-id="${video.id}">
            <div class="w-full aspect-video bg-gray-200 overflow-hidden">
              <img src="${thumbnailUrl}"
                   alt="${this.escapeHtml(video.title)}"
                   class="w-full h-full object-cover"
                   loading="lazy">
            </div>
            <div class="absolute inset-0 bg-opacity-0 group-hover:bg-opacity-30 transition-all duration-200 flex items-center justify-center">
              <div class="opacity-0 group-hover:opacity-100 transition-opacity duration-200">
                <svg class="w-16 h-16 text-white" fill="currentColor" viewBox="0 0 24 24">
                  <path d="M8 5v14l11-7z"/>
                </svg>
              </div>
            </div>
          </div>
          <div class="p-4">
            <h3 class="font-semibold text-sm md:text-base mb-2 line-clamp-2 leading-tight">${this.escapeHtml(video.title)}</h3>
            <p class="text-xs md:text-sm text-gray-600 mb-2">${new Date(video.publishedAt).toLocaleDateString()}</p>
            <p class="text-xs md:text-sm text-gray-700 line-clamp-2">${this.escapeHtml((video.description || '').substring(0, 100))}${video.description && video.description.length > 100 ? '...' : ''}</p>
          </div>
        </div>
      `

      this.wrapperTarget.appendChild(videoEl)
    })

    this.createDots()
  }

  openVideo(event) {
    const videoId = event.currentTarget.dataset.videoId
    window.open(`https://www.youtube.com/watch?v=${videoId}`, '_blank')
  }

  escapeHtml(text) {
    const div = document.createElement('div')
    div.textContent = text || ''
    return div.innerHTML
  }

  createDots() {
    this.dotsContainerTarget.innerHTML = ''
    const totalPages = Math.ceil(this.videos.length / this.videosPerView)

    for (let i = 0; i < totalPages; i++) {
      const dot = document.createElement('button')
      dot.className = `w-3 h-3 rounded-full transition-colors duration-200 ${i === 0 ? 'bg-ruby-red' : 'bg-gray-300'}`
      dot.addEventListener('click', () => this.goToSlide(i))
      this.dotsContainerTarget.appendChild(dot)
    }
  }

  setupNavigation() {
    this.updateNavigationButtons()
  }

  prevSlide() {
    if (this.currentIndex > 0) {
      this.currentIndex = Math.max(0, this.currentIndex - this.videosPerView)
      this.updateCarousel()
      this.resetAutoplay()
    }
  }

  nextSlide() {
    const maxIndex = this.videos.length - this.videosPerView
    if (this.currentIndex < maxIndex) {
      this.currentIndex = Math.min(maxIndex, this.currentIndex + this.videosPerView)
      this.updateCarousel()
      this.resetAutoplay()
    }
  }

  goToSlide(pageIndex) {
    this.currentIndex = pageIndex * this.videosPerView
    this.updateCarousel()
    this.resetAutoplay()
  }

  updateNavigationButtons() {
    const totalPages = Math.ceil(this.videos.length / this.videosPerView)
    const currentPage = Math.floor(this.currentIndex / this.videosPerView)

    this.prevBtnTarget.disabled = currentPage === 0
    this.nextBtnTarget.disabled = currentPage >= totalPages - 1
  }

  updateCarousel() {
    if (this.videos.length === 0) return

    const totalPages = Math.ceil(this.videos.length / this.videosPerView)
    const currentPage = Math.floor(this.currentIndex / this.videosPerView)

    if (currentPage >= totalPages) {
      this.currentIndex = 0
    }

    const translateX = -(Math.floor(this.currentIndex / this.videosPerView) * 100)
    this.wrapperTarget.style.transform = `translateX(${translateX}%)`

    this.updateDots()
    this.updateNavigationButtons()
  }

  updateDots() {
    const dots = this.dotsContainerTarget.children
    const currentPage = Math.floor(this.currentIndex / this.videosPerView)

    Array.from(dots).forEach((dot, index) => {
      dot.className = `w-3 h-3 rounded-full transition-colors duration-200 ${
        index === currentPage ? 'bg-ruby-red' : 'bg-gray-300'
      }`
    })
  }

  setupAutoplay() {
    if (this.autoplayValue) {
      this.startAutoplay()
      this.element.addEventListener('mouseenter', () => this.stopAutoplay())
      this.element.addEventListener('mouseleave', () => this.startAutoplay())
    }
  }

  startAutoplay() {
    this.stopAutoplay()
    this.autoplayTimer = setInterval(() => {
      const maxIndex = this.videos.length - this.videosPerView
      if (this.currentIndex >= maxIndex) {
        this.currentIndex = 0
      } else {
        this.currentIndex += this.videosPerView
      }
      this.updateCarousel()
    }, this.autoplayIntervalValue)
  }

  stopAutoplay() {
    if (this.autoplayTimer) {
      clearInterval(this.autoplayTimer)
      this.autoplayTimer = null
    }
  }

  resetAutoplay() {
    if (this.autoplayValue) {
      this.startAutoplay()
    }
  }

  retry() {
    this.hideError()
    this.showLoading()
    this.init()
  }

  showLoading() {
    this.loadingTarget.classList.remove('hidden')
    this.carouselTarget.classList.add('hidden')
    this.errorTarget.classList.add('hidden')
  }

  showCarousel() {
    this.loadingTarget.classList.add('hidden')
    this.carouselTarget.classList.remove('hidden')
    this.errorTarget.classList.add('hidden')
  }

  showError() {
    this.loadingTarget.classList.add('hidden')
    this.carouselTarget.classList.add('hidden')
    this.errorTarget.classList.remove('hidden')
  }

  hideError() {
    this.errorTarget.classList.add('hidden')
  }
}
