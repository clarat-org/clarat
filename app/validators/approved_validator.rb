class ApprovedValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    if record.approved_changed? && record.approved == true
      record.before_approve
      if record.completed == false
        record.errors[attribute] = I18n.t('validations.shared.incomplete')
      elsif record.versions.first.nil? ||
            record.versions.first.whodunnit.to_i == PaperTrail.whodunnit.id
        record.errors[attribute] = I18n.t(
          'validations.shared.approved_by_creator'
        )
      end
    end
  end
end
