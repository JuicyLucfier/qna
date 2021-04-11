require 'rails_helper'

RSpec.describe UserSubscription, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:question) }
end