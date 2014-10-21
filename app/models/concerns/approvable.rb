module Approvable
  extend ActiveSupport::Concern

  def add_approved_at
    if approved_changed? && approved == true
      self.approved_at = DateTime.now
    end
    true
  end
end