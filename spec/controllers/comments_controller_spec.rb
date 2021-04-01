require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:question) { create(:question, author: author) }
  let(:comment) { create(:comment, question: question) }

  describe 'POST #create' do
    context 'Authenticated user' do
      before { login(author) }

      context 'with valid attributes' do
        it 'saves a new comment in the database' do
          expect { post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js }.to change(question.comments, :count).by(1)
        end

        it 'assigns commentable' do
          post :create, params: { comment: attributes_for(:comment), question_id: question }, format: :js
          expect(assigns(:commentable)).to eq question
        end

        it 'renders create template' do
          post :create, params: { comment: attributes_for(:comment), question_id: question, format: :js }
          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the comment' do
          expect { post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js }.to_not change(Comment, :count)
        end
        it 'renders create template' do
          post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question, format: :js }
          expect(response).to render_template :create
        end
      end
    end

    context 'Authenticated user' do
      before { login(user) }

      it 'tries to create comment' do
        expect { post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question }, format: :js }.to_not change(Comment, :count)
      end
    end
  end
end
