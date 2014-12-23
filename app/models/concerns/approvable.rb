module Approvable
  extend ActiveSupport::Concern

  def add_approved_at
    self.approved_at = DateTime.now if approved_changed? && approved == true
    true
  end
end
