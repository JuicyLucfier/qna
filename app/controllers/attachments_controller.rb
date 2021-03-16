class AttachmentsController < ApplicationController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @file&.purge_later if current_user&.author_of?(@file.record)

    redirect_to @file.record.is_a?(Question) ? question_path(@file.record) : question_path(@file.record.question)
  end
end