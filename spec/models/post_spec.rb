require 'spec_helper'

describe Post do
  it{ should respond_to(:body) }
  it{ should respond_to(:title) }
  it{ should respond_to(:private) }

  describe ".increment_view_count" do
    let(:blog_post) { FactoryGirl.create(:post) }
    it "increments view count" do
      blog_post.view_count.should eq 0
      blog_post.increment_view_count!
      blog_post.view_count.should eq 1
    end
  end

  describe ".increment_edit_count" do
    let(:blog_post) { FactoryGirl.create(:post) }
    it "increments edit count" do
      blog_post.edit_count.should eq 0
      blog_post.increment_edit_count!
      blog_post.edit_count.should eq 1
    end
  end
end
