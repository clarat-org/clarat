module Approvable
  extend ActiveSupport::Concern

  # handled in observers
  def add_approved_info
    if approved_changed? && approved == true
      self.approved_at = DateTime.now
      self.approved_by = ::PaperTrail.whodunnit.try(:to_i)
    end
    true
  end
end
