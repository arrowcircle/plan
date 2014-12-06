module ItemsHelper
  def quantity_for(num)
    zero = num.to_s.index('.')
    return num.to_i if num.to_s[zero..-1] == '.0'
    num
  end
end
