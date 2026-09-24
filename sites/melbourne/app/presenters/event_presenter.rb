# frozen_string_literal: true

module Melbourne
  class EventPresenter < SimpleDelegator
    delegate :year, to: :date

    def formatted_start_time
      start_time.strftime("%l:%M %P")
    end

    def formatted_end_time
      end_time&.strftime("%l:%M %P")
    end

    def formatted_day_number
      date.strftime("%d")
    end

    def formatted_month_abbreviation
      date.strftime("%b")
    end

    def year_is_different_from_current_year?
      date.year != Date.current.year
    end

    def formatted_full_date_with_weekday
      date.strftime("%A, %d %B")
    end

    def in_the_past?
      date.before?(Date.current)
    end

    def registration_status_title
      in_the_past? ? 'Registration Closed' : 'Registration'
    end

    def past_event_message
      "This event took place on #{formatted_date_with_conditional_year}."
    end

    def formatted_date_with_conditional_year
      "#{formatted_full_date_with_weekday}#{year_is_different_from_current_year? ? " #{year}" : ''}"
    end

    def formatted_date_for_card
      formatted_date = date.strftime("%d %B")
      year_is_different_from_current_year? ? "#{formatted_date} #{year}" : formatted_date
    end

    def container_base_classes
      "rounded cursor-pointer flex flex-col gap-1 border-b border-b-gray-200 px-4 pb-4 pt-3 transition-colors bg-white text-gray-500 **:data-title:text-black **:data-ascii-image:text-gray-300 hover:bg-blue-700 inset-ring-4 inset-ring-white"
    end

    def container_hover_classes
      "hover:bg-[#0D37F2] hover:border-b-transparent hover:text-white hover:**:data-title:text-white hover:**:data-ascii-image:text-[#6A86FF] hover:inset-ring-transparent"
    end

    def open_graph_metadata_new
      OpenGraphMetadataNew.new(self).to_meta_tags
    end
  end

  class OpenGraphMetadataNew
    include ViteRails::TagHelpers
    include ActionView::Helpers::AssetUrlHelper

    def initialize(event)
      @event = event
    end

    def to_meta_tags # rubocop:disable Metrics/MethodLength
      {
        title: "#{event.date} - #{event.name}",
        description: event.description,
        keywords: event.keywords,
        og: {
          title: :title,
          description: :description,
          image: vite_asset_url("images/melbourne/ruby_melbourne_og.png"),
          url: event_url
        },
        twitter: {
          card: "summary",
          site: "@rubyau",
          title: :title,
          description: :description,
        }
      }
    end

    private

    attr_reader :event

    def event_url
      Routes.url_helpers.melbourne_event_url(event, **Routes::DEFAULT_URL_OPTIONS)
    end
  end
end
