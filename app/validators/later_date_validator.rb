# Validates that datetime field contains a date after the given one
class LaterDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value && value <= Time.zone.now.end_of_day
      record.errors[attribute] = I18n.t('shared.validations.later_date')
    end
  end
end
