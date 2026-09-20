# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnalyticsCsvExporter do
  describe '#generate' do
    context 'when analytics data includes daily visits with complete metrics' do
      let(:analytics_data) do
        OpenStruct.new(
          visits_over_time: [
            { date: 'Jun 01', visits: 50, unique_visitors: 40, page_views: 120 },
            { date: 'Jun 02', visits: 65, unique_visitors: 55, page_views: 150 }
          ]
        )
      end

      it 'generates a CSV with headers and corresponding data rows' do
        exporter = described_class.new(analytics_data)
        csv = CSV.parse(exporter.generate, headers: true)

        expect(csv.headers).to eq(['Date', 'Visits', 'Unique Visitors', 'Page Views'])
        expect(csv.size).to eq(2)

        expect(csv[0]['Date']).to eq("#{Date.current.year}-06-01")
        expect(csv[0]['Visits']).to eq('50')
        expect(csv[0]['Unique Visitors']).to eq('40')
        expect(csv[0]['Page Views']).to eq('120')

        expect(csv[1]['Date']).to eq("#{Date.current.year}-06-02")
        expect(csv[1]['Visits']).to eq('65')
        expect(csv[1]['Unique Visitors']).to eq('55')
        expect(csv[1]['Page Views']).to eq('150')
      end
    end

    context 'when analytics data has only visits counts' do
      let(:analytics_data) do
        OpenStruct.new(
          visits_over_time: [
            { date: 'Jun 01', visits: 25 }
          ]
        )
      end

      it 'gracefully defaults unique visitors and page views to visits count' do
        exporter = described_class.new(analytics_data)
        csv = CSV.parse(exporter.generate, headers: true)

        expect(csv[0]['Date']).to eq("#{Date.current.year}-06-01")
        expect(csv[0]['Visits']).to eq('25')
        expect(csv[0]['Unique Visitors']).to eq('25')
        expect(csv[0]['Page Views']).to eq('25')
      end
    end

    context 'when analytics data has no visits over time' do
      let(:analytics_data) do
        OpenStruct.new(visits_over_time: [])
      end

      it 'generates a CSV containing only headers' do
        exporter = described_class.new(analytics_data)
        csv = CSV.parse(exporter.generate, headers: true)

        expect(csv.headers).to eq(['Date', 'Visits', 'Unique Visitors', 'Page Views'])
        expect(csv.size).to eq(0)
      end
    end
  end

  describe '#filename' do
    it 'returns filename with current date' do
      exporter = described_class.new(OpenStruct.new)
      expect(exporter.filename).to eq("analytics_export_#{Date.current}.csv")
    end
  end
end
