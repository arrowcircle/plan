class AccountsController < ApplicationController
  def set
    @account = current_user.accounts.find(params[:id])
    session[:account_id] = @account.id
    redirect_to :back
  end
end
