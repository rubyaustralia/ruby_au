class Admin::AnalyticsController < ApplicationController
  def index
    @analytics_data = AnalyticsService.new.call

    respond_to do |format|
      format.html
      format.csv { send_csv_export }
    end
  end

  private

  def send_csv_export
    csv_exporter = AnalyticsCsvExporter.new(@analytics_data)
    send_data csv_exporter.generate,
              filename: csv_exporter.filename,
              type: 'text/csv'
  end
end
