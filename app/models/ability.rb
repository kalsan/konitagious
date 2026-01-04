class Ability
  include CanCan::Ability

  def initialize(_user)
    # TODO: temporary
    can :manage, :all
  end
end
