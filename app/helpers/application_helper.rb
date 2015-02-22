module ApplicationHelper
  def active?(name, condition = nil)
    condition = controller_name == name if condition.nil?
    condition ? 'active' : ''
  end

  def avatar_url(user)
    return user.try(:avatar_url) if user.try(:avatar_url).present?
    default_url = "http://#{root_url}/assets/default_avatar.png"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=20"#&d=#{CGI.escape(default_url)}"
  end
end
