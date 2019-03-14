class BadgesController < ApplicationController
  before_action :authenticate_user!

  def index
    @badge = current_user.badges
  end
end
