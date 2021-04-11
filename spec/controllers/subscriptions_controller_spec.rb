require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:author) { create(:user) }

  let(:user) { create(:user) }
  let(:question) { create(:question, author: author) }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(author) }

      it 'creates subscription' do
        expect { post :create, params: { question_id: question }, format: :js }.to change(author.subscriptions, :count).by(1)
      end
    end

    context 'Unauthenticated user' do
      it 'does not create subscription' do
        expect { post :create, params: { question_id: question }, format: :js }.to_not change(user.subscriptions, :count)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:subscription) { create(:subscription, question: question, user: user) }

    context 'Authenticated user' do
      before { login(user) }

      context 'is author of subscription' do
        it 'deletes subscription' do
          expect { delete :destroy, params: { id: subscription }, format: :js }.to change(user.subscriptions, :count).by(-1)
        end
      end

      context 'is not author of subscription' do
        before { login(author) }

        it 'does not deletes subscription' do
          expect { delete :destroy, params: { id: subscription }, format: :js }.to_not change(author.subscriptions, :count)
        end
      end
    end

    context 'Unauthenticated user' do
      it 'does not deletes subscription' do
        expect { delete :destroy, params: { id: subscription }, format: :js }.to_not change(author.subscriptions, :count)
      end
    end
  end
end