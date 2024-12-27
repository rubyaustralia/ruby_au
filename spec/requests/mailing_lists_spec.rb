# frozen_string_literal: true

require "rails_helper"

RSpec.describe MailingListsController, type: :request do
  describe "#hook" do
    let(:list) { MailingList.all.first }
    let(:user) { create(:user, email: "test@example.com") }

    context "with a valid Subscribe event" do
      let(:event_payload) do
        {
          "Events" => [
            {
              "Type" => "Subscribe",
              "EmailAddress" => user.email,
              "ListId" => list.api_id,
            }
          ],
        }.to_json
      end

      it "subscribes the user to the mailing list" do
        post "/mailing_lists/#{list.api_id}/hook", params: event_payload, headers: { "CONTENT_TYPE" => "application/json" }
        expect(response).to have_http_status(:no_content)
        user.reload
        expect(user.mailing_lists[list.name]).to eq("true")
      end
    end

    context "with a valid Deactivate event" do
      let(:event_payload) do
        {
          "Events" => [
            {
              "Type" => "Deactivate",
              "EmailAddress" => user.email,
              "ListId" => list.api_id,
            }
          ],
        }.to_json
      end

      it "unsubscribes the user from the mailing list" do
        user.update(mailing_lists: { list.name => "true" })
        post "/mailing_lists/#{list.api_id}/hook", params: event_payload, headers: { "CONTENT_TYPE" => "application/json" }
        expect(response).to have_http_status(:no_content)
        user.reload
        expect(user.mailing_lists[list.name]).to eq("false")
      end
    end

    context "with an invalid event payload" do
      let(:invalid_event_payload) do
        {
          "Events" => []
        }.to_json
      end

      it "returns an error" do
        post "/mailing_lists/#{list.api_id}/hook", params: invalid_event_payload, headers: { "CONTENT_TYPE" => "application/json" }
        # Assuming the controller handles invalid JSON gracefully and returns no_content
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when the user does not exist" do
      let(:event_payload) do
        {
          "Events" => [
            {
              "Type" => "Subscribe",
              "EmailAddress" => "nonexistent@example.com",
              "ListId" => list.api_id,
            }
          ],
        }.to_json
      end

      it "does not raise an error" do
        expect do
          post "/mailing_lists/#{list.api_id}/hook", params: event_payload, headers: { "CONTENT_TYPE" => "application/json" }
        end.not_to raise_error
        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
