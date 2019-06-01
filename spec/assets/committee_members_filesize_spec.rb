require 'rails_helper'

RSpec.describe 'Committee Members Max Filesize' do
  let(:max_filesize) { 200_000 } # bytes

  it 'will not have an image over max filesize' do
    images = Dir.glob("app/assets/images/committee-members/*")

    images.each do |image|
      expect(File.new(image).size.to_i).to be < max_filesize, "#{File.split(image).last} is over #{max_filesize} bytes"
    end
  end
end
