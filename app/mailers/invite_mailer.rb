class InviteMailer < ApplicationMailer
  def welcome_invite(invite_id)
    @invite = Invite.find(invite_id)
    mail to: @invite.email, subject: "Вас пригласили в проект #{@invite.account.name}"
  end
end
