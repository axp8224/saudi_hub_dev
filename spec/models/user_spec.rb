require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:role) }
    it { is_expected.to belong_to(:major).optional }
    it { is_expected.to belong_to(:class_year).optional }
    it { is_expected.to have_one_attached(:avatar) }
    it { is_expected.to have_many(:resources) }
  end

  describe 'validations' do
    it { is_expected.to validate_numericality_of(:grad_year).only_integer.is_greater_than_or_equal_to(1900).is_less_than_or_equal_to(Time.now.year + 10).allow_nil }
  end

  describe 'attachments' do
    it { is_expected.to have_one_attached(:avatar) }
  end

  describe '#acceptable_avatar' do
    let(:user) { User.new(email: 'test@example.com') }

    before do
      blob = double('ActiveStorage::Blob', content_type: 'image/jpeg', byte_size: 2.megabytes)
      attachment = double('ActiveStorage::Attached::One', attached?: true, blob: blob)
      allow(user).to receive(:avatar).and_return(attachment)
    end      

    it 'validates that the avatar has an acceptable type' do
      expect(user).to be_valid
    end

    it 'adds an error if the avatar type is unacceptable' do
      allow(user.avatar.blob).to receive(:content_type).and_return('text/plain')
      user.valid?
      expect(user.errors[:avatar]).to include(I18n.t('users.edit.error_messages.file_type_error'))
    end    

    it 'adds an error if the avatar size is too large' do
      allow(user.avatar.blob).to receive(:byte_size).and_return(3.megabytes)
      user.valid?
      expect(user.errors[:avatar]).to include(I18n.t('users.edit.error_messages.file_size_too_large'))
    end
  end
end
