# Authentication (via cancan) for rails_admin
class Ability
  include CanCan::Ability

  # See the wiki for details:
  # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  def initialize(user)
    return unless user

    case user.role
    when 'researcher'
      can_acces_rails_admin
      can_do_collection_scoped_actions
      can_do_member_scoped_actions
    when 'super'
      can_acces_rails_admin
      can_do_collection_scoped_actions
      can_do_member_scoped_actions
      can :statistics, :all
    end
  end

  private

  def can_acces_rails_admin
    can :access, :rails_admin   # grant access to rails_admin
    can :dashboard              # grant access to the dashboard
  end

  # rails_admin collection scoped actions
  def can_do_collection_scoped_actions
    can :index, :all
    can :new, :all
    can :export, :all
    can :history, :all
    can :destroy, :all
  end

  # rails_admin member scoped actions
  def can_do_member_scoped_actions
    can :show, :all
    can :edit, :all
    can :destroy, :all
    can :history, :all
    can :show_in_app, :all
    can :clone, :all
    # can :nested_set, :all
    can :nestable, :all
    can :change_state, :all
  end
end
