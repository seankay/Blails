class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :read, Post do |post|
      post.user_id == user.id || !post.private?
    end
    can :create, Post
    can :update, Post, user_id: user.id
    can :destroy, Post, user_id: user.id
  end
end
