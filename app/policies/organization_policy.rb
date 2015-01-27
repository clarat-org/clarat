class OrganizationPolicy < ApplicationPolicy
  def show?
    @record.approved?
  end
end
