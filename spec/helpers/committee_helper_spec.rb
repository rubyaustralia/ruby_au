require 'rails_helper'

RSpec.describe CommitteeHelper, type: :helper do
  before do
    allow(YAML).to receive(:load_file).with(Rails.root.join('config/data/committee.yml')).and_return([{ 'name' => 'Melbourne Blue', 'position' => 'President', 'start' => %w[2026-01-01 2020-03-03], 'end' => %w[2026-12-31 2020-03-02] }])
    allow(YAML).to receive(:load_file).with(Rails.root.join('config/data/previous.yml')).and_return([{ 'name' => 'Ruby Red', 'position' => 'president', 'start' => %w[2001-01-01 2002-03-03], 'end' => %w[2001-12-31 2003-03-02] },
                                                                                                     { 'name' => 'Wild Boar', 'position' => 'president', 'start' => %w[2000-01-01 2005-03-03], 'end' => %w[2000-12-31 2006-03-02] }, { 'name' => 'Pig Pink', 'position' => 'president', 'start' => %w[2010-01-01 2011-03-03], 'end' => %w[2010-12-31 2012-03-02] }])
  end

  describe '#presidents' do
    it 'returns a list of presidents and terms sorted by the latest start date to the oldest start date' do
      presidents = helper.presidents

      expect(presidents).not_to be_empty

      names = presidents.map { |p| p[:name] }
      expect(names).to eq(['Melbourne Blue', 'Pig Pink', 'Wild Boar', 'Ruby Red'])

      start_dates = presidents.map { |p| p[:start] }
      expect(start_dates).to eq([
                                  %w[2026-01-01 2020-03-03],
                                  %w[2010-01-01 2011-03-03],
                                  %w[2000-01-01 2005-03-03],
                                  %w[2001-01-01 2002-03-03]
                                ])

      end_dates = presidents.map { |p| p[:end] }
      expect(end_dates).to eq([
                                %w[2026-12-31 2020-03-02],
                                %w[2010-12-31 2012-03-02],
                                %w[2000-12-31 2006-03-02],
                                %w[2001-12-31 2003-03-02]
                              ])
    end
  end
end
