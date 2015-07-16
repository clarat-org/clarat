module Approvable
  extend ActiveSupport::Concern

  included do
    scope :approved, -> { where(approved: true, completed: true) }
  end

  # handled in observers
  def add_approved_info
    if approved_changed? && approved == true
      self.approved_at = DateTime.now
      self.approved_by = ::PaperTrail.whodunnit.id
      self.unapproved_reason = 'N/A' if self.class == Offer
    end
    true
  end
end
