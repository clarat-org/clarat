class ApprovedValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    if record.approved_changed? && record.approved?
      record.before_approve
      first_version = record.versions.first
      if !record.completed?
        record.fail_validation attribute, 'incomplete'
      elsif first_version.nil? ||
            first_version.whodunnit.to_i == PaperTrail.whodunnit
        record.fail_validation attribute, 'approved_by_creator'
      end
    end
  end
end
