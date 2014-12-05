module ApplicationHelper
  def active?(name, condition = nil)
    condition = controller_name == name if condition.nil?
    condition ? 'active' : ''
  end
end
