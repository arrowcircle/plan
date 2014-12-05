class InvitesController < ApplicationController
  before_action :authenticate_owner!, except: [:show, :update]
  skip_before_action :authenticate_user!, only: [:show, :update]

  def index
    @invites = Invite.for_account(account.id).inactive.order(:created_at)
    @account_users = AccountUser.where(account_id: account.id).where.not(user_id: current_user.id)
  end

  def new
    @invite = Inviter.new
  end

  def create
    @invite = Inviter.new(invite_params)
    if @invite.invite
      redirect_to [:invites], notice: 'Мы отправили приглашения на указанные емейлы'
    else
      render 'new'
    end
  end

  def show
    @invite = Invite.inactive.where(token: params[:id]).first
    raise ActiveRecord::RecordNotFoundError unless @invite
    @invitation = Invitation.new(invite: @invite)
  end

  def update
    @invite = Invite.inactive.where(token: params[:id]).first
    raise ActiveRecord::RecordNotFoundError unless @invite
    @invitation = Invitation.new(invitation_params)
    if @invitation.register
      sign_in(@invitation.user)
      redirect_to root_path, notice: 'Регистрация прошла успешно'
    else
      render 'show'
    end
  end

  def destroy
    @invite = if params[:invite] == 'true'
      Invite.inactive.where(token: params[:id]).first
    elsif params[:invite] == 'false'
      AccountUser.where(account_id: account.id).where.not(user_id: current_user.id).find(params[:id])
    end
    @invite.destroy if @invite
    redirect_to [:invites]
  end

  private

  def invite_params
    params[:invite].merge!(account_id: account.id)
    params[:invite].permit!
  end

  def invitation_params
    params[:invite].merge!(invite: @invite)
    params[:invite].permit!
  end
end
