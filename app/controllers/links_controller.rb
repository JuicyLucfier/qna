class LinksController < ApplicationController
  def destroy
    @link = Link.find(params[:id])
    authorize! :destroy, @link
    @link.destroy if current_user&.author_of?(@link.linkable)

    redirect_to @link.linkable.is_a?(Question) ? question_path(@link.linkable) : question_path(@link.linkable.question)
  end
end
