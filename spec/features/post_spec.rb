require 'spec_helper'

describe "Post Features" do
  let(:blog_post) { Post.create(title: "test", body: "test body") }
  subject { page }

  describe "Viewing Posts" do
    before do
      @a_post = Post.create(title: "test", body: "test body")
      visit posts_path
    end

    it{ should have_link "New Post"}

    it "lists posts" do
      should have_selector("h1", text: "Posts")
      should have_selector("h4", text: @a_post.title)
      should have_selector("p", text: @a_post.body)
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
      before do
        fill_in "post_title", with: "Title"
        fill_in "post_body", with: "Body of Post"
        check("post_private")
        click_button "Update Post"
      end
      it "should show success flash" do
        should have_selector("#flash", text: "Success")
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
