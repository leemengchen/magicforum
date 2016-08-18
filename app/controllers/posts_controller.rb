class PostsController < ApplicationController

  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    @topic = Topic.includes(:posts).friendly.find(params[:topic_id])
    @posts = @topic.posts.order("created_at DESC").page params[:page]
    @post = Post.new
  end

  def show
    @post = Post.friendly.find(params[:id])
  end

  def new
    @topic = Topic.friendly.find(params[:topic_id])
    @post = Post.new
    authorize @post
  end

  def create
    @topic = Topic.friendly.find(params[:topic_id])
    @post = current_user.posts.build(post_params.merge(topic_id: @topic.id))
    @new_post = Post.new
    if @post.save
      flash.now[:success] = "You've created a new post!!!"
    else
      flash.now[:danger] = @post.errors.full_messages
    end
  end

  def edit
    @post = Post.friendly.find(params[:id])
    @topic = @post.topic
    $prevURL = request.referer

  end

  def update
    @topic = Topic.friendly.find(params[:topic_id])
    @post = Post.friendly.find(params[:id])
    authorize @post

    if @post.update(post_params)
      # redirect_to topic_posts_path(@topic, @post)
      redirect_to $prevURL
    else
      redirect_to edit_topic_post_path(@topic, @post)
    end
  end

  def destroy
    @post = Post.friendly.find(params[:id])
    @topic = @post.topic
    authorize @post

    if @post.destroy
      redirect_to topic_posts_path(@topic)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end
end
