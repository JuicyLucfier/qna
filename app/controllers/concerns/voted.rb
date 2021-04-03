module Voted
  extend ActiveSupport::Concern

  included do
     before_action :authenticate_user!, only: %i[vote_for vote_against vote_cancel]
     before_action :set_votable, only: %i[vote_for vote_against vote_cancel]
  end

  def vote_for
    authorize! :vote_for, @votable
    vote(@votable, "for")
  end

  def vote_against
    authorize! :vote_against, @votable
    vote(@votable, "against")
  end

  def vote_cancel
    authorize! :vote_cancel, @votable
    vote(@votable, vote_value(@votable), true )
  end

  private

  def vote(votable, value, cancel = false)
    votable.do_vote(value, current_user, cancel)
    render_json_rating(votable)
  end

  def render_json_rating(resource)
    render json: { id: resource.id, rating: resource.rating, vote_value: vote_value(resource), class_name: resource.class.name }
  end

  def vote_value(resource)
    current_user.voted?(resource) ? current_user&.vote(resource).value : "cancel"
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end