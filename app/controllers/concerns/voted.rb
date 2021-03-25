module Voted
  extend ActiveSupport::Concern

  included do
     before_action :authenticate_user!, only: %i[vote_for vote_against vote_cancel]
     before_action :set_votable, only: %i[vote_for vote_against vote_cancel]
  end

  def vote_for
    unless current_user.author_of?(@votable)
      current_user.votes.create(votable: @votable, value: "for")
      @votable.do_vote(1)
      render_json_rating(@votable)
    end
  end

  def vote_against
    unless current_user.author_of?(@votable)
      current_user.votes.create(votable: @votable, value: "against")
      @votable.do_vote(-1)
      render_json_rating(@votable)
    end
  end

  def vote_cancel
    unless current_user.author_of?(@votable)
      @votable.do_vote(vote_value(@votable) == "for" ? -1 : 1)
      current_user.vote(@votable).destroy
      render_json_rating(@votable)
    end
  end

  private

  def render_json_rating(resource)
    render json: { id: resource.id, rating: resource.rating, vote_value: vote_value(resource), class_name: resource.class.name }
  end

  def vote_value(resource)
    current_user.voted?(@votable) ? current_user&.vote(resource).value : "cancel"
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end