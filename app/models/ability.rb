class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can %i[update destroy], [Question, Answer], author_id: user.id
    can :best, Answer, author_id: user.id
    can :destroy, Link, linkable: { author_id: user.id }
    can :destroy, ActiveStorage::Attachment, record: { author_id: user.id }

    can %i[vote_for vote_against vote_cancel], [Question, Answer] do |votable|
      !user.author_of?(votable)
    end
  end
end
