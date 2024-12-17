require 'rails_helper'

RSpec.describe "Admin::ImportedMembers", type: :request do
  describe "POST /admin/imported_members" do
    let(:admin) { create(:user, :committee) }
    let(:file) { fixture_file_upload('imported_members.csv', 'text/csv') }
    let(:source) { 'test_source' }

    before do
      sign_in admin
    end

    context "with valid parameters" do
      it "creates new imported members" do
        expect {
          post admin_imported_members_path, params: { source: source, file: file }
        }.to change(ImportedMember, :count).by(2)

        expect(response).to redirect_to(admin_imported_members_path)
        follow_redirect!
        expect(response.body).to include("Imported Members")

        # Check for the existence of the records immediately after the post request
        expect(ImportedMember.find_by(email: 'member1@example.com')).not_to be_nil
        expect(ImportedMember.find_by(email: 'member2@example.com')).not_to be_nil
      end

      it "sets the correct attributes" do
        post admin_imported_members_path, params: { source: source, file: file }

        member1 = ImportedMember.find_by(email: 'member1@example.com')
        member2 = ImportedMember.find_by(email: 'member2@example.com')

        expect(member1.full_name).to eq('Member One')
        expect(member1.contacted_at).to be_nil
        expect(member1.data['sources']).to eq([source])

        expect(member2.full_name).to eq('Member Two')
        expect(member2.contacted_at).to be_nil
        expect(member2.data['sources']).to eq([source])
      end
    end

    context "with duplicate email in imported members" do
      it "updates the existing imported member" do
        existing_member = create(:imported_member, email: 'member1@example.com', full_name: 'Old Name', data: { sources: ['old_source'] })

        expect {
          post admin_imported_members_path, params: { source: source, file: file }
        }.to change(ImportedMember, :count).by(1)

        existing_member.reload
        expect(existing_member.full_name).to eq('Old Name')
        expect(existing_member.data['sources']).to eq(['old_source', source])
      end
    end

    context "with email that exists in emails table" do
      it "skips the row" do
        create(:email, email: 'member1@example.com')

        expect {
          post admin_imported_members_path, params: { source: source, file: file }
        }.to change(ImportedMember, :count).by(1)

        expect(ImportedMember.find_by(email: 'member1@example.com')).to be_nil
      end
    end

    context "with blank email" do
      let(:file) { fixture_file_upload('imported_members_blank_email.csv', 'text/csv') }

      it "skips the row" do
        expect {
          post admin_imported_members_path, params: { source: source, file: file }
        }.to change(ImportedMember, :count).by(1)

        expect(ImportedMember.find_by(email: '')).to be_nil
      end
    end

    context "without authentication" do
      it "redirects to the sign-in page" do
        sign_out admin

        post admin_imported_members_path, params: { source: source, file: file }

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
