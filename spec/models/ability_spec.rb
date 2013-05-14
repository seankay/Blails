require 'spec_helper'
require 'cancan/matchers'

describe "Abilities" do
  let(:user) { FactoryGirl.create(:user) }
  let(:post) { FactoryGirl.create(:post, user: user) }
  let(:public_post) { FactoryGirl.create(:post, user: user) }

  subject { ability }

  before do
    public_post.private = false
  end

  describe "User" do
    let(:ability) { Ability.new(user) }

    it{ should be_able_to(:read, public_post) }
    it{ should be_able_to(:read, post) }
    it{ should be_able_to(:destroy, post) }
    it{ should be_able_to(:create, post) }
    it{ should be_able_to(:update, post) }

  end

  describe "Another user" do
    let(:another_user) { FactoryGirl.create(:user) }
    let(:ability) { Ability.new(another_user) }
    it{ should be_able_to(:read, public_post) }
    it{ should_not be_able_to(:read, post) }
    it{ should_not be_able_to(:destroy, post) }
    it{ should_not be_able_to(:update, post) }
  end
end
