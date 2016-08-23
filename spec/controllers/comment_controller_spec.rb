require 'rails_helper'

 RSpec.describe CommentsController, type: :controller do

   before(:all) do
    @admin = User.create(username: "admin01", email: "admin@gmail.com", password: "admin", role: 2)
    @unauthorized_user = User.create(username:"user01", email:"user@hotmail.com", password:"12345", role: 0 )
    @user = User.create(username: "normal user", email: "normaluser@gmail.com", password: "12345", role: 0)
    @moderator = User.create(username: "moderator01", email: "moderator01@gmail.com", password: "12345", role: 2)
    @topic = Topic.create(title: "testing2", description: "test description", user_id: @admin.id)
    @post = @topic.posts.create(title: "testing3", body: "test body",user_id: @user.id)
    @comment = @post.comments.create(body:"testing4", user_id: @user.id)
  end

  describe "index comments" do
    it "should render index" do

      params = {topic_id: @topic.slug, post_id: @post.slug}
      get :index, params: params

      expect(Comment.count).to eql(1)
      expect(subject).to render_template(:index)
    end
  end

  describe "create comments" do

    it "should redirect if not logged in" do

      params = { topic_id: @topic.slug, post_id: @post.slug, comment:{body: "test body" } }
      post :create, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end


    it "should render create only you are logged in with admin user" do

      params = { topic_id: @topic.slug, post_id: @post.slug, comment:{body: "test body" } }
      post :create, xhr: true, params: params, session: {id: @admin.id}



      new_comment = Comment.find_by(body:"testing4")
      expect(new_comment.body).to eql("testing4")
      expect(Comment.count).to eql(2)
      expect(flash[:success]).to eql("You've created a new comment.")
    end

    it "should render create only you are logged in with normal user" do
      params = { topic_id: @topic.slug, post_id: @post.id, comment:{body: "test body" } }
      post :create, xhr: true, params: params, session: {id: @user.id}



      new_comment = Comment.find_by(body:"testing4")
      expect(new_comment.body).to eql("testing4")
      expect(Comment.count).to eql(2)
      expect(flash[:success]).to eql("You've created a new comment.")
    end
  end

  describe "edit comment" do

    it "should redirect if not logged in" do
      params = { topic_id: @topic.slug, post_id: @post.slug, id: @comment.id }
      get :edit, xhr: true, params: params

      expect(response).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end


    it "should render edit only if you are the user who created this comment" do
      params = { topic_id: @topic.slug, post_id: @post.slug, id: @comment.id}
      get :edit, params: params, session: {id: @user.id}

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@user)
      expect(subject).to render_template(:edit)
    end

    it "should render edit only if you are admin" do
      params = { topic_id: @topic.slug, post_id: @post.slug, id: @comment.id}
      get :edit, params: params, session: {id: @admin.id}

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@admin)
      expect(subject).to render_template(:edit)
    end
  end

  describe "update comment" do


    it "should render update only if you are the user who created this comment" do

      params = {topic_id: @topic.slug, post_id: @post.slug, id: @comment.id, comment:{ body: "Updated Comment here!"}}
      patch :update, params: params, session: {id: @user.id}

      @comment.reload

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@user)
      expect(subject).to redirect_to (topic_post_comments_path(@topic,@post))
      expect(@comment.body).to eql("Updated Comment here!")
    end

    it "should render update only if you are admin" do

      params = {topic_id: @topic.slug, post_id: @post.slug, id: @comment.id, comment:{ body: "Updated Comment here!"}}
      patch :update, params: params, session: {id: @admin.id}

      @comment.reload

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@admin)
      expect(subject).to redirect_to (topic_post_comments_path(@topic,@post))
      expect(@comment.body).to eql("Updated Comment here!")
    end
  end

  describe "destroy topic" do

    it "should render destroy only if you are the user who created this comment" do

      params = { topic_id: @topic.slug, post_id: @post.slug, id: @comment.id}
      delete :destroy,xhr: true, params: params, session: {id: @user.id}


      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@user)
    end

    it "should render destroy only if you are admin" do

      params = { topic_id: @topic.slug, post_id: @post.slug, id: @comment.id}
      delete :destroy,xhr: true, params: params, session: {id: @admin.id}


      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@admin)
    end

  end

end
