# Validates that datetime field contains a date after the given one
class LaterDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value && value <= Time.now.end_of_day
      record.errors[attribute] = I18n.t('validations.shared.later_date')
    end
  end
end
