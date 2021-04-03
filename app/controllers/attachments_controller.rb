class AttachmentsController < ApplicationController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    authorize! :destroy, @file
    @file&.purge_later

    redirect_to @file.record.is_a?(Question) ? question_path(@file.record) : question_path(@file.record.question)
  end
end
