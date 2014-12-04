class Invitation
  attr_accessor :invite, :name, :password
  include ActiveModel::Model

  def self.model_name
    Invite.model_name
  end
end
