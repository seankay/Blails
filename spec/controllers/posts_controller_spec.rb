require 'spec_helper'

describe PostsController do

  describe "GET /posts" do
    let(:posts) { stub }
    it "gets all posts" do
      Post.stub(:all){ posts }
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
    let(:blog_post) { stub(id: 1) }
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
    let(:blog_post){ {title: "Title", body: "Body of Post"} }
    let(:invalid_blog_post){ {title: "", body: "Body of Post"} }

    before do
      Post.create(title: "Title", body: "Body of Post")
    end

    it "redirects on success" do
      put :update, id: Post.first.id, :post => blog_post
      response.should redirect_to post_path assigns(:post)
    end

    it "renders on failure" do
      put :update, id: Post.first.id, :post => invalid_blog_post
      response.should render_template(:new)
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
    let(:blog_post) { stub(id: 1) }
    it "gets post" do
      Post.stub(:find){ blog_post }
      get :show, id: blog_post.id
      assigns(:post).should eq blog_post
    end
  end

end
