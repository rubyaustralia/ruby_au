import { Application } from "@hotwired/stimulus"
import { describe, it, expect, beforeEach, vi } from "vitest"
import AnalyticsChartController from "../../controllers/analytics_chart_controller"

vi.mock("chart.js/auto", () => {
  return {
    default: class MockChart {
      constructor(ctx, config) {
        this.ctx = ctx
        this.config = config
      }
      destroy() {}
    }
  }
})

describe("AnalyticsChartController", () => {
  let application

  beforeEach(() => {
    window.HTMLCanvasElement.prototype.getContext = () => ({})
    document.body.innerHTML = ""
    application = Application.start()
    application.register("analytics-chart", AnalyticsChartController)
  })

  it("successfully initializes line chart with array data", async () => {
    const visitsData = [
      { date: "Jun 01", visits: 10 },
      { date: "Jun 02", visits: 25 }
    ]

    document.body.innerHTML = `
      <canvas id="visitsChart"
              data-controller="analytics-chart"
              data-analytics-chart-type-value="line"
              data-analytics-chart-data-value='${JSON.stringify(visitsData)}'>
      </canvas>
    `

    // Give Stimulus time to connect
    await new Promise((resolve) => setTimeout(resolve, 0))

    const element = document.getElementById("visitsChart")
    const controller = application.getControllerForElementAndIdentifier(element, "analytics-chart")

    expect(controller).toBeDefined()
    expect(controller.chart).toBeDefined()
    expect(controller.chart.config.type).toBe("line")
    expect(controller.chart.config.data.labels).toEqual(["Jun 01", "Jun 02"])
    expect(controller.chart.config.data.datasets[0].data).toEqual([10, 25])
  })

  it("successfully initializes doughnut chart with object data", async () => {
    const deviceData = {
      labels: ["Desktop", "Mobile"],
      data: [30, 12],
      backgroundColor: ["#3B82F6", "#10B981"]
    }

    document.body.innerHTML = `
      <canvas id="deviceChart"
              data-controller="analytics-chart"
              data-analytics-chart-type-value="doughnut"
              data-analytics-chart-data-value='${JSON.stringify(deviceData)}'>
      </canvas>
    `

    await new Promise((resolve) => setTimeout(resolve, 0))

    const element = document.getElementById("deviceChart")
    const controller = application.getControllerForElementAndIdentifier(element, "analytics-chart")

    expect(controller).toBeDefined()
    expect(controller.chart).toBeDefined()
    expect(controller.chart.config.type).toBe("doughnut")
    expect(controller.chart.config.data.labels).toEqual(["Desktop", "Mobile"])
    expect(controller.chart.config.data.datasets[0].data).toEqual([30, 12])
  })
})
