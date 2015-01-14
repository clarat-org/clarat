module Approvable
  extend ActiveSupport::Concern

  # handled in observers
  def add_approved_info
    if approved_changed? && approved == true
      self.approved_at = DateTime.now
      self.approved_by = current_user.id
    end
    true
  end
end
