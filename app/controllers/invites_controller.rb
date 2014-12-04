class InvitesController < ApplicationController
  def index
    @invites = Invite.for_account(account.id).inactive.order(:created_at)
    @account_users = AccountUser.where(account_id: account.id)
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
    @invitation = Invitation.new(@invite)
  end

  def update
  end

  def destroy
  end

  private

  def invite_params
    params[:invite].merge!(account_id: account.id)
    params[:invite].permit!
  end
end
