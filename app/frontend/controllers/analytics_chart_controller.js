import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static values = {
    type: String,
    data: Object
  }

  connect() {
    this.createChart()
  }

  disconnect() {
    if (this.chart) {
      this.chart.destroy()
    }
  }

  createChart() {
    const ctx = this.element.getContext('2d')

    if (this.typeValue === 'line') {
      this.createLineChart(ctx)
    } else if (this.typeValue === 'doughnut') {
      this.createDoughnutChart(ctx)
    }
  }

  createLineChart(ctx) {
    const data = this.dataValue

    this.chart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: data.map(item => item.date),
        datasets: [{
          label: 'Visits',
          data: data.map(item => item.visits),
          borderColor: '#3B82F6',
          backgroundColor: 'rgba(59, 130, 246, 0.1)',
          borderWidth: 2,
          fill: true,
          tension: 0.4,
          pointBackgroundColor: '#3B82F6',
          pointBorderColor: '#ffffff',
          pointBorderWidth: 2,
          pointRadius: 4,
          pointHoverRadius: 6
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false
          }
        },
        scales: {
          x: {
            grid: {
              display: false
            },
            ticks: {
              color: '#6B7280'
            }
          },
          y: {
            beginAtZero: true,
            grid: {
              color: '#F3F4F6'
            },
            ticks: {
              color: '#6B7280',
              callback: function(value) {
                return value.toLocaleString()
              }
            }
          }
        },
        interaction: {
          intersect: false,
          mode: 'index'
        }
      }
    })
  }

  createDoughnutChart(ctx) {
    const data = this.dataValue

    this.chart = new Chart(ctx, {
      type: 'doughnut',
      data: {
        labels: data.labels,
        datasets: [{
          data: data.data,
          backgroundColor: data.backgroundColor,
          borderWidth: 0,
          hoverOffset: 4
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom',
            labels: {
              padding: 20,
              usePointStyle: true,
              color: '#374151'
            }
          }
        },
        cutout: '60%'
      }
    })
  }
}
