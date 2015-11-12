class OfferPolicy < ApplicationPolicy
  def show?
    @record.approved? || (@user && @user.role != 'standard')
  end
end
