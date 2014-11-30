class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  private

  def account
    @account ||= begin
      acc = current_user.accounts.find_by_id(session[:account_id])
      acc ||= current_user.accounts.first
      session[:account_id] = acc.id if session[:account_id] != acc.id
      acc
    end
  end
  helper_method :account
end
