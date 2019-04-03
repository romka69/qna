class ApplicationController < ActionController::Base
  before_action :gon_user

  private

  def gon_user
    gon.push user_id: current_user&.id
  end
end
