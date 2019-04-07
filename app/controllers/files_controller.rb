class FilesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attached_file = ActiveStorage::Attachment.find(params[:id])

    authorize! :destroy, @attached_file

    if current_user.author_of?(@attached_file.record)
      @attached_file.purge
      flash[:notice] = 'File was deleted.'
    else
      head :forbidden
    end
  end
end
