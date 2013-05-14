require 'spec_helper'

describe "Post Features" do
  let!(:user) { FactoryGirl.create(:user) }
  subject { page }

  before do
    FactoryGirl.create_list(:post, 4)
    login user
  end
  let(:blog_post){ Post.first }

  describe "Viewing Posts" do
    before do
      visit posts_path
    end

    it{ should have_link "New Post"}

    it "lists posts" do
      should have_selector("h1", text: "Posts")
      Post.all.each do |blog_post|
        should have_selector("h2 a", text: blog_post.title)
        should have_selector("p", text: blog_post.body)
        should have_selector("small", text: blog_post.view_count)
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
    before do 
      visit edit_post_path blog_post
    end

    context "with errors" do
      before do
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
