require 'spec_helper'

describe "Post Features" do
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  subject { page }

  before do
    FactoryGirl.create(:post, user: user)
    FactoryGirl.create(:post, private: false, user: user)
    FactoryGirl.create(:post, user: other_user)
    FactoryGirl.create(:post, private: false, user: other_user)
    login user
  end

  let(:blog_post){ FactoryGirl.create(:post, user: user) }

  describe "Viewing Posts" do
    before do
      visit posts_path
    end

    context "unsigned in user" do
      before do
        logout
      end
      it { should_not have_link("New Post") }
    end

    it{ should have_link "New Post"}

    it "lists public posts" do
      should have_selector("h1", text: "Posts")
      Post.where(private: false).each do |blog_post|
        should have_selector("h2", text: blog_post.title)
        should have_selector("p", text: blog_post.body)
        should have_selector("small", text: blog_post.view_count)
        should have_selector("small", text: blog_post.edit_count)
        should have_selector("small", text: blog_post.updated_at)
      end
    end

    it "indicates private post" do
      Post.where(private: true, user_id: user.id).each do
        should have_selector("small", text: "private")
      end
    end

    it "lists own private posts" do
      Post.where(private: true, user_id: user.id).each do |blog_post|
        should have_selector("h2", text: blog_post.title)
        should have_selector("p", text: blog_post.body)
        should have_selector("small", text: blog_post.view_count)
      end
    end

    it "does not list other user's private posts" do
      Post.where(private: true, user_id: other_user.id).each do |blog_post|
        should_not have_selector("h2", text: blog_post.title)
        should_not have_selector("p", text: blog_post.body)
      end
    end

    it "does not list other user's post actions" do
      Post.where(private: false, user_id: other_user.id).each do |blog_post|
        within("##{blog_post.id}") do
          should_not have_link("Edit")
          should_not have_link("Delete")
        end
      end
    end

    it "lists show post action on own post" do
      Post.where(user_id: user.id).each do |blog_post|
        within("##{blog_post.id}") do
          should have_link("Edit")
          should have_link("Delete")
        end
      end
    end
  end

  describe "Creating a Post" do
    before do 
      visit new_post_path
    end

    context "with errors" do
      before do
        fill_in "post_title", with: ""
        fill_in "post_body", with: ""
        check("post_private")
        click_button "Create Post"
      end
      it "should display form errors" do
        should have_selector("#error_explanation")
      end
    end

    context "without errors" do
      before do
        fill_in "post_title", with: "Title"
        fill_in "post_body", with: "Body of Post"
        check("post_private")
        click_button "Create Post"
      end

      it "should show success flash" do
        should have_selector("#flash", text: "Success")
      end
    end

    context "in markdown" do
      before do
        fill_in "post_title", with: "Title"
        fill_in "post_body", with: "Body of Post\r\n============="
        check("post_private")
        click_button "Create Post"
      end

      it "should show success flash" do
        should have_selector("h1", text: "Body of Post")
      end
    end
  end

  describe "Updating a Post" do
    context "of current user" do
      before do
        visit edit_post_path blog_post
      end
      it "displays edit form" do
        current_path.should eq edit_post_path(blog_post)
        should have_selector("form")
      end
    end

    context "of another user" do
      let(:another_users_blog_post){ FactoryGirl.create(:post, user_id: other_user.id) }

      before do
        visit edit_post_path another_users_blog_post
      end
      it "displays edit form" do
        current_path.should eq root_path
        should have_selector("h4","not authorized")
      end
    end

    context "with errors" do
      before do
        visit edit_post_path blog_post
        fill_in "post_title", with: ""
        fill_in "post_body", with: ""
        check("post_private")
        click_button "Update Post"
      end
      it "should display form errors" do
        should have_selector("#error_explanation")
      end
    end

    context "without errors" do
      let(:initial_edit_count) { blog_post.edit_count }
      let(:initial_edit_timestamp) { blog_post.updated_at }
      before do
        visit edit_post_path blog_post
        fill_in "post_title", with: "Title"
        fill_in "post_body", with: "Body of Post"
        check("post_private")
        click_button "Update Post"
      end

      it "should show success flash" do
        should have_selector("#flash", text: "Success")
      end

      it "should show edit time stamp" do
        should have_selector("##{blog_post.id}", text: "#{blog_post.updated_at}")
      end

      it "should show number of edits" do
        should have_selector("##{blog_post.id}", text: "#{blog_post.edit_count}")
      end
    end
  end

  describe "Deleting a Post" do
    before do 
      visit post_path blog_post
    end

    context "with errors" do
      before do
        Post.any_instance.stub(:destroy){ false }
        click_link "Delete"
      end
      it "should display form errors" do
        should have_selector("#flash", text: "Error")
      end
    end

    context "without errors" do
      before do
        click_link "Delete"
      end
      it "should show success flash" do
        should have_selector("#flash", text: "Success")
      end
    end
  end
end
