class ComplexPasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << 'Пароль не может быть короче 8 символов' if value.length < 8
    record.errors[attribute] << 'Пароль должен содержать хотя бы одну цифру' unless value.index(/\d/)
    record.errors[attribute] << 'Пароль должен содержать хотя бы одну заглавную букву' unless value.index(/[A-Z]/)
    record.errors[attribute] << 'Пароль должен содержать хотя бы одну строчную букву' unless value.index(/[a-z]/)
  end
end
