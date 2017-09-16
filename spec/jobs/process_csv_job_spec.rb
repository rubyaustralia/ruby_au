require 'rails_helper'

describe ProcessCsvJob do
  let(:import) { build_stubbed(:import) }
  let(:user) { build_stubbed(:user) }

  before do
    allow(Import).to receive(:find).and_return(import)
    allow(import).to receive(:save!)
  end

  def perform(*args)
    described_class.new.perform(*args)
  end

  it 'changes import status' do
    expect(Import).to receive(:find).with(123).and_return(import)
    expect(User).to receive(:find_by).with(email: 'ex@mail.com')
    expect_any_instance_of(User).to receive(:save).and_return(true)

    perform(123)

    expect(import.status).to eq :imported
  end

  context 'when user is missing' do
    before do
      expect(User).to receive(:find_by).with(email: 'ex@mail.com').and_return(nil)
    end

    it 'creates new user if not found' do
      expect_any_instance_of(User).to receive(:save).and_return(true)

      perform(1)

      expect(import.imported_users).to include(hash_including(
        'email' => 'ex@mail.com',
        'full_name' => 'Thomas White'
      ))
    end

    it 'reports invalid records' do
      user = User.new
      expect(User).to receive(:new) { user }
      expect(user).to_not be_valid

      perform(1)

      expect(import.import_issues).to include(hash_including(
        'line_no' => 1,
        'email' => 'ex@mail.com',
        'messages' => array_including(kind_of(String))
      ))
    end
  end

  context 'when user exists' do
    it 'does not update existing user' do
      expect(User).to receive(:find_by).with(email: 'ex@mail.com').and_return(user)
      expect_any_instance_of(User).to_not receive(:save)

      perform(1)

      expect(import.existing_users).to include(
        'user_id' => user.id,
        'full_name' => user.full_name,
        'email' => user.email
      )
    end
  end
end
