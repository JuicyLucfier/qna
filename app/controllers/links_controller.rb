class LinksController < ApplicationController
  authorize_resource

  def destroy
    @link = Link.find(params[:id])
    @link.destroy if current_user&.author_of?(@link.linkable)

    redirect_to @link.linkable.is_a?(Question) ? question_path(@link.linkable) : question_path(@link.linkable.question)
  end
end
