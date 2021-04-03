class LinksController < ApplicationController
  def destroy
    @link = Link.find(params[:id])
    authorize! :destroy, @link
    @link.destroy

    redirect_to @link.linkable.is_a?(Question) ? question_path(@link.linkable) : question_path(@link.linkable.question)
  end
end
