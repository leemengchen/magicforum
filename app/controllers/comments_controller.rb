class CommentsController < ApplicationController

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
    @post = Post.find_by(id: params[:topic_id])
    @comment = Comment.new
  end

  def create
    @topic = Topic.find_by(id: params[:topic_id])
    @post = Post.find_by(id: params[:topic_id])
    @comment = Comment.new(comment_params.merge(post_id:params[:post_id]))
    if @topic.save
      redirect_to_comments_path(@topic, @post)
    else
      render new_comment_path(@topic, @post,@comment)
    end
  end

  def edit
    @topic = @post.topic
    @post = @comment.topic
    @comment = Comment.find_by(id: params[:id])
  end

  def update
    @topic = Topic.find_by(id: params[:topic_id])
    @post = Post.find_by(id: params[:topic_id])
    @comment = Comment.find_by(id: params[:id])

    if @comment.update(comment_params)
      redirect_to_comments_path(@topic, @post)
    else
      redirect_to_edit_comment_path(@topic, @post,@comment)
    end
  end

  def destroy
    @topic = Topic.find_by(id: params[:topic_id])
    @post = Post.find_by(id: params[:topic_id])
    @comment = Comment.find_by(id: params[:id])
    if @comment.destroy
      redirect_to_comments_path(@topic, @post)
    end

  end

end
