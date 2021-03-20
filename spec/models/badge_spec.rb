require 'rails_helper'

RSpec.describe Badge, type: :model do
  it { should belong_to(:question) }

  it { should have_many(:user_badges).dependent(:destroy) }
  it { should have_many(:users).through(:user_badges) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:image) }

  it { is_expected.to validate_attached_of(:image) }

  it { is_expected.to validate_content_type_of(:image).allowing('image/png', 'image/jpg') }
end
