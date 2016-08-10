class CommentsController < ApplicationController

  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    @topic = Topic.includes(:posts).find_by(id: params[:topic_id])
    @post = Post.includes(:comments).find_by(id: params[:post_id])
    @comments = @post.comments.order("created_at DESC")
    @comment = Comment.new
  end

  def show
    @comment = Comment.find_by(id: params[:id])
  end

  def new
    @topic = Topic.find_by(id: params[:topic_id])
    @post = @topic.posts.find_by(id: params[:post_id])
    @comment = Comment.new
    authorize @comment
  end

  def create

    @topic = Topic.find_by(id: params[:topic_id])
    @post = @topic.posts.find_by(id: params[:post_id])
    # @comment = @post.comments.new(comment_params)
    @comment = current_user.comments.build(comment_params.merge(post_id: params[:post_id]))
    authorize @comment
    if @comment.save
      flash[:success] = "You've created a new comment."
      redirect_to topic_post_comments_path(@topic, @post)
    else
      flash[:danger] = @comment.errors.full_messages
      redirect_to topic_post_comments_path(@topic, @post)
    end
  end

  def edit
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    @topic = @post.topic
  end

  def update
    @topic = Topic.find_by(id: params[:topic_id])
    @post = Post.find_by(id: params[:post_id])
    @comment = Comment.find_by(id: params[:id])
    authorize @comment

    if @comment.update(comment_params)
      redirect_to topic_post_comments_path(@topic, @post)
    else
      redirect_to edit_topic_post_comment_path( @post,@comment)
    end
  end

  def destroy
    @topic = Topic.find_by(id: params[:topic_id])
    @post = Post.find_by(id: params[:topic_id])
    @comment = Comment.find_by(id: params[:id])
    if @comment.destroy
      redirect_to topic_post_comments_path(@topic, @post)
    end

  end

  def comment_params
    params.require(:comment).permit(:body, :image)
  end

end
