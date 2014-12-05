class MainController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    return redirect_to items_path if user_signed_in?
  end
end
