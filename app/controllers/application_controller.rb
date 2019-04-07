class ApplicationController < ActionController::Base
  before_action :gon_user

  rescue_from CanCan::AccessDenied do |exception|

    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.js { render status: :forbidden }
      format.json { render json: exception.message, status: :forbidden }
    end
  end

  check_authorization unless :devise_controller?

  private

  def gon_user
    gon.push user_id: current_user&.id
  end
end
