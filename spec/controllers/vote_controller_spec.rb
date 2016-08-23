require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  before(:all) do
    @admin = User.create(username: "admin01", email: "admin@gmail.com", password: "admin", role: 2)
    @unauthorized_user = User.create(username:"user01", email:"user@hotmail.com", password:"12345", role: 0 )
    @user = User.create(username: "normal user", email: "normaluser@gmail.com", password: "12345", role: 0)
    @topic = Topic.create(title: "testing2", description: "test description", user_id: @admin.id)
    @post = @topic.posts.create(title: "testing3", body: "test body",user_id: @user.id)
    @comment = @post.comments.create(body:"testing4", user_id: @user.id)
  end

  describe "you can't vote if you are not logged in" do
    it "should redirect if not logged in" do
      params = {comment_id: @comment.id}
      post :upvote, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end
  end

  describe "upvote a comment" do
    it "should successfully upvote a comment if you are an admin" do

      params = {comment_id: @comment.id}
      post :upvote, xhr: true, params: params, session: {id: @admin.id}

      expect(Vote.count).to eql(1)
      expect(flash[:success]).to eql("You upvoted.")
    end

    it "should successfully upvote a comment if you are a user" do

      params = {comment_id: @comment.id}
      post :upvote, xhr: true, params: params, session: {id: @user.id}

      expect(Vote.count).to eql(1)
      expect(flash[:success]).to eql("You upvoted.")
    end
  end


  describe "downvote a comment" do
    it "should successfully downvote a comment if you are an admin" do

      params = {comment_id: @comment.id}
      post :downvote, xhr: true, params: params, session: {id: @admin.id}

      expect(Vote.count).to eql(1)
      expect(flash[:danger]).to eql("You downvoted.")
    end

    it "should successfully downvote a comment if you are a user" do

      params = {comment_id: @comment.id}
      post :downvote, xhr: true, params: params, session: {id: @user.id}

      expect(Vote.count).to eql(1)
      expect(flash[:danger]).to eql("You downvoted.")
    end
  end

end
