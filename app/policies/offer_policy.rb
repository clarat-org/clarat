class OfferPolicy < ApplicationPolicy
  def show?
    @record.approved?
  end
end
