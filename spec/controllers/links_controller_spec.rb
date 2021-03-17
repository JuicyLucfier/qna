require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, author: author, question: question) }

    before {
      answer.links.create(url: 'http://github.com', name: 'github')
    }

    context 'author' do
      before { login(author) }

      it 'deletes the link' do
        expect { delete :destroy, params: { id: answer.links.first.id }, format: :js }.to change(answer.links, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer.links.first.id }, format: :js
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'not author' do
      before { login(user) }

      it 'tries to delete the link' do
        expect { delete :destroy, params: { id: answer.links.first.id }, format: :js }.to_not change(answer.links, :count)
      end
    end
  end
end