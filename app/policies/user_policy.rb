class UserPolicy < ApplicationPolicy
  # careful: #user is the current_user, #record the requested user
  def show?
    record.id == user.id
  end
end
