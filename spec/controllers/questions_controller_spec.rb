require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:author) { create(:user) }
  let(:question) { create(:question, author: author) }

  describe 'GET #index' do
    before { get :index }

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question }}

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(author) }
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(author) }

    context 'with valid attributes' do
      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end
      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'author tries to update question' do
      let!(:question) { create(:question, author: author) }

      context 'with valid attributes' do
        before { login(author) }

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
          question.reload
          expect(question.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { login(author) }

        it 'does not change question attributes' do
          expect do
            patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
            to_not change(question, :body)
          end
        end

        it 'renders update view' do
          patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end
    end

    context 'not author' do
      before { login(author) }

      it "tries to edit other user's question" do
        expect do
          patch :update, params: { id: question, question: { body: 'new body' } }, format: :js
          to_not change(question, :body)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question, author: author) }

    context 'author' do
      before { login(author) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question }, format: :js }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }, format: :js
        expect(response).to redirect_to questions_path
      end
    end

    context 'not author' do
      before { login(user) }

      it 'tries to delete the question' do
        expect { delete :destroy, params: { id: question }, format: :js }.to_not change(Question, :count)
      end
    end
  end
end
