class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!
  def new
    @registration = Registration.new
  end

  def create
    @registration = Registration.new(registration_params)
    if @registration.register
      sign_in(@registration.user)
      redirect_to guide_url, notice: t('.welcome')
    else
      render 'new'
    end
  end

  private

  def registration_params
    params[:registration].permit(:name, :email, :password, :company)
  end
end
