require 'spec_helper'

describe PostsController do
  let(:user) { FactoryGirl.create(:user) }
  
  before do
    Ability.any_instance.stub(:can?){ true }
    sign_in user
    stub(:authorize){ true }
  end

  describe "GET /posts" do
    before do
      FactoryGirl.create_list(:post, 2)
      controller.stub(:current_user){ user }
    end

    let(:posts) { Post.by_creation_date }
    it "gets all posts" do
      get :index
      assigns(:posts).should eq posts
    end
  end

  describe "GET /posts/new" do
    let(:blog_post) { stub }
    it "gets all posts" do
      Post.stub(:new){ blog_post }
      get :new
      assigns(:post).should eq blog_post
    end
  end

  describe "GET /posts/:id/edit" do
    let(:blog_post) { FactoryGirl.create(:post, user: user) }
    it "gets post" do
      Post.stub(:find){ blog_post }
      get :edit, id: blog_post.id
      assigns(:post).should eq blog_post
    end
  end

  describe "POST /posts" do
    let(:blog_post){ {title: "Title", body: "Body of Post"} }
    let(:invalid_blog_post){ {title: "", body: "Body of Post"} }

    it "redirects on success" do
      post :create, :post => blog_post
      response.should redirect_to post_path assigns(:post)
    end

    it "renders on failure" do
      post :create, :post => invalid_blog_post
      response.should render_template(:new)
    end
  end

  describe "PUT /posts" do
    let(:updated_blog_post){ {title: "Title", body: "Body of Post"} }
    let!(:blog_post) { FactoryGirl.create(:post) }
    let(:invalid_blog_post){ {title: "", body: "Body of Post"} }

    before do
      Post.create(title: "Title", body: "Body of Post")
    end

    it "redirects on success" do
      put :update, id: blog_post, :post => updated_blog_post
      response.should redirect_to post_path assigns(:post)
    end

    it "renders on failure" do
      put :update, id: blog_post, :post => invalid_blog_post
      response.should render_template(:new)
    end

    it "increments edit_count" do
      put :update, id: blog_post, :post => updated_blog_post
      assigns(:post).edit_count.should eq 1
    end
  end

  describe "DELETE /posts/:id" do
    before do
      Post.create(title: "Title", body: "Body of Post")
    end

    it "redirects on success" do
      Post.any_instance.stub(:destroy){ true }
      delete :destroy, id: Post.first.id
      response.should redirect_to posts_path
    end

    it "redirects to :show  on failure" do
      Post.any_instance.stub(:destroy){ false }
      delete :destroy, id: Post.first.id
      response.should redirect_to post_path(assigns(:post))
    end
  end

  describe "GET /post/:id" do
    let(:blog_post) { FactoryGirl.create(:post) }
    it "gets post" do
      Post.stub(:find){ blog_post }
      expect{get :show, id: blog_post.id}.to change{blog_post.view_count}.from(0).to(1)
      assigns(:post).should eq blog_post
    end
  end

end
