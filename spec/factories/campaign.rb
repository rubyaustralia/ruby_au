# frozen_string_literal: true

FactoryBot.define do
  factory :campaign do
    subject { "News" }
    preheader { "Please Read Me" }
    content { "Not much to say..." }
  end
end
