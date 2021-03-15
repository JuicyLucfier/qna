require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, author: author, question: question) }

    before {
      answer.files.attach(io: File.open(Rails.root.join("spec", "rails_helper.rb")), filename: 'rails_helper.rb',
                        content_type: 'file/rb')
    }
    context 'author' do
      before { login(author) }

      it 'deletes the attachment' do
        expect { delete :destroy, params: { id: answer.files.first.id }, format: :js }.to change(answer.files, :count).by(-1)
      end

      it 'redirects to question' do
        delete :destroy, params: { id: answer.files.first.id }, format: :js
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'not author' do
      before { login(user) }

      it 'tries to delete the attachment' do
        expect { delete :destroy, params: { id: answer.files.first.id }, format: :js }.to_not change(answer.files, :count)
      end
    end
  end
end