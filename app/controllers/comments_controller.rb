class CommentsController < ApplicationController
  respond_to :js
  before_action :authenticate!, only: [:create, :edit, :update, :new, :destroy]

  def index
    @topic = Topic.includes(:posts).friendly.find(params[:topic_id])
    @post = Post.includes(:comments).friendly.find(params[:post_id])
    @comments = @post.comments.order("created_at DESC").page params[:page]
    @comment = Comment.new
  end

  def show
    @comment = Comment.find_by(id: params[:id])
  end

  def create
    @topic = Topic.friendly.find(params[:topic_id])
    @post = @topic.posts.friendly.find(params[:post_id])
    @comment = current_user.comments.build(comment_params.merge(post_id: @post.id))
    @new_comment=Comment.new
    authorize @comment
    if @comment.save
      CommentBroadcastJob.perform_now("create", @comment)
      flash.now[:success] = "You've created a new comment."
    else
      flash.now[:danger] = @comment.errors.full_messages
    end
  end

  def edit
    @comment = Comment.find_by(id: params[:id])
    @post = @comment.post
    @topic = @post.topic
  end

  def update
    @topic = Topic.friendly.find(params[:topic_id])
    @post = Post.friendly.find( params[:post_id])
    @comment = Comment.find_by(id: params[:id])
    authorize @comment

    if @comment.update(comment_params)
      CommentBroadcastJob.perform_now("update", @comment)
      flash.now[:success]="You're successfullly update your comment!"
      redirect_to topic_post_comments_path(@topic, @post)
    else
      flash.now[:danger]="You're unsuccessfullly update your comment!"
      redirect_to edit_topic_post_comment_path( @post,@comment)
    end
  end

  def destroy
    @topic = Topic.friendly.find(params[:topic_id])
    @post = Post.friendly.find(params[:post_id])
    @comment = Comment.find_by(id: params[:id])
    authorize @comment
    if @comment.destroy
      CommentBroadcastJob.perform_now("destroy", @comment)
      flash.now[:success] = "You've deleted a new comment."
    else
      flash.now[:danger] = @comment.errors.full_messages
    end

  end

  def comment_params
    params.require(:comment).permit(:body, :image)
  end

end
