require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:user_question) { create(:question, author: user) }
    let(:other_question) { create(:question, author: other) }
    let(:user_answer) { create(:answer, question: user_question, author: user) }
    let(:other_answer) { create(:answer, question: other_question, author: other) }
    let(:user_answer_and_other_user) { create(:answer, question: user_question, author: other) }
    let(:other_answer_and_other_user) { create(:answer, question: other_question, author: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    describe 'create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
    end

    describe 'update' do
      it { should be_able_to :update, user_question }
      it { should_not be_able_to :update, other_question }

      it { should be_able_to :update, user_answer }
      it { should_not be_able_to :update, user_answer_and_other_user }
    end

    describe 'destroy' do
      it { should be_able_to :destroy, user_question }
      it { should_not be_able_to :destroy, other_question }

      it { should be_able_to :destroy, user_answer }
      it { should_not be_able_to :destroy, user_answer_and_other_user }
    end

    describe 'best' do
      it { should be_able_to :best, user_answer }
      it { should_not be_able_to :best, user_answer_and_other_user }
    end

    describe 'votes' do
      context 'vote_for' do
        it { should be_able_to :vote_for, other_question }
        it { should_not be_able_to :vote_for, user_question }

        it { should be_able_to :vote_for, other_answer_and_other_user }
        it { should_not be_able_to :vote_for, user_answer }
      end

      context 'vote_against' do
        it { should be_able_to :vote_against, other_question }
        it { should_not be_able_to :vote_against, user_question }

        it { should be_able_to :vote_against, other_answer_and_other_user }
        it { should_not be_able_to :vote_against, user_answer }
      end

      context 'vote_cancel' do
        it { should be_able_to :vote_cancel, other_question }
        it { should_not be_able_to :vote_cancel, user_question }

        it { should be_able_to :vote_cancel, other_answer_and_other_user }
        it { should_not be_able_to :vote_cancel, user_answer }
      end
    end

    describe 'links' do
      it { should be_able_to :destroy, create(:link, linkable: user_question, name: "test name", url: "http://testurl.com") }
      it { should_not be_able_to :destroy, create(:link, linkable: other_question, name: "test name", url: "http://testurl.com") }
    end

    describe 'attachments' do
      it {
        should be_able_to :destroy, create(:answer, question: user_question, author: user,
                                           files: [io: File.open(Rails.root.join("spec", "rails_helper.rb")), filename: 'rails_helper.rb',
                                                         content_type: 'file/rb']).files.first
      }

      it {
        should_not be_able_to :destroy, create(:answer, question: user_question, author: other,
                                           files: [io: File.open(Rails.root.join("spec", "rails_helper.rb")), filename: 'rails_helper.rb',
                                                   content_type: 'file/rb']).files.first
      }
    end
  end
end
