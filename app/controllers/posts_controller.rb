class PostsController < ApplicationController

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(params[:post])
    if @post.save
      redirect_to @post, notice: "Successfully created #{@post.title}."
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @post.increment_view_count!
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes params[:post]
      @post.increment_edit_count!
      redirect_to @post, notice: "Successfully updated #{@post.title}."
    else
      render :new
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if @post.destroy
      redirect_to posts_path, notice: "Successfully deleted #{@post.title}."
    else
      redirect_to post_path(@post), alert: "Error. Unable to delete #{@post.title}."
    end
  end
end
