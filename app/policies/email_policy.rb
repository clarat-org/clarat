# frozen_string_literal: true

class EmailPolicy < ApplicationPolicy
  def subscribe?
    @record.security_code_confirmed?
  end

  def unsubscribe?
    @record.security_code_confirmed?
  end
end
