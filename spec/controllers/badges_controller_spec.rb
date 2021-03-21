require 'rails_helper'

RSpec.describe BadgesController, type: :controller do
  let(:user) { create(:user) }
  let(:image) { "#{Rails.root}/app/assets/images/lion.jpg"}
  let(:question) { create(:question, author: user) }

  describe 'GET #index' do
    before {
      login(user)

      question.build_badge
      question.badge.title = "test"
      question.badge.image.attach(io: File.open(Rails.root.join("spec", "support", "test.png")), filename: 'test.png',
                          content_type: ['image/png, image/jpg'])

      user.badges.push(question.badge)
      get :index
    }

    it 'populates an array of all badges' do
      expect(assigns(:user_badges)).to match_array(user.badges)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end
end