require 'rails_helper'

 RSpec.describe PostsController, type: :controller do

   before(:all) do
    @admin = create(:user, :admin)
    @unauthorized_user = create(:user, :sequenced_email,:sequenced_username)
    @user = create(:user, :sequenced_email,:sequenced_username)
    @moderator = create(:user, :moderator)
    @topic = create(:topic, user_id:@admin.id)
    @post = create(:post, topic_id:@topic.id, user_id:@user.id)
  end

  describe "index posts" do
    it "should render index" do

      params = {topic_id: @topic.slug}
      get :index, params: params

      expect(Post.count).to eql(1)
      expect(subject).to render_template(:index)
    end
  end

  describe "create posts" do

    it "should redirect if not logged in" do

      params = { topic_id: @topic.slug, post:{ title: "testing3", body: "test body" } }
      post :create, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end


    it "should render create only you are logged in with admin user" do

      params = { topic_id: @topic.slug, post:{ title: "testing3", body: "test body" } }
      post :create, xhr: true, params: params, session: {id: @admin.id}



      new_post = Post.friendly.find("testing3")
      expect(new_post.title).to eql("testing3")
      expect(new_post.body).to eql("test body")
      expect(Post.count).to eql(2)
      expect(flash[:success]).to eql("You've created a new post!!!")
    end

    it "should render create only you are logged in with normal user" do
      params = { topic_id: @topic.slug, post:{ title: "testing3", body: "test body" } }
      post :create, xhr: true, params: params, session: {id: @user.id}



      new_post = Post.friendly.find("testing3")
      expect(new_post.title).to eql("testing3")
      expect(new_post.body).to eql("test body")
      expect(Post.count).to eql(2)
      expect(flash[:success]).to eql("You've created a new post!!!")
    end
  end

  describe "edit post" do

    it "should redirect if not logged in" do
      params = { topic_id: @topic.slug, id: @post.slug }
      get :edit, params: params

      expect(response).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @topic.slug, id: @post.slug}
      get :edit, params: params, session: {id: @unauthorized_user.id}

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render edit only if you are the user who created this post" do
      params = { topic_id: @topic.slug, id: @post.slug}
      get :edit, params: params, session: {id: @post.user.id}

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@post.user)
      expect(subject).to render_template(:edit)
    end

    it "should render edit only if you are admin" do
      params = { topic_id: @topic.slug, id: @post.slug}
      get :edit, params: params, session: {id: @admin.id}

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@admin)
      expect(subject).to render_template(:edit)
    end
  end

  describe "update post" do

    it "should redirect if not logged in" do
      params = { topic_id: @topic.slug, id: @post.slug }
      patch :update, params: params

      expect(response).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @topic.slug, id: @post.slug}
      patch :update, params: params, session: {id: @unauthorized_user.id}

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should update only if you are the user who created this post" do

      params = {topic_id: @topic.slug, id: @post.slug, post:{ title: "Updated Post Title", body: "Updated Post here!"}}
      patch :update, params: params, session: {id: @post.user.id}

      @post.reload

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@post.user)
      expect(subject).to redirect_to (topic_posts_path(@topic,@post))
      expect(@post.title).to eql("Updated Post Title")
      expect(@post.body).to eql("Updated Post here!")
    end

    it "should render update only if you are admin" do

      params = {topic_id: @topic.slug, id: @post.slug, post:{ title: "Updated Post Title", body: "Updated Post here!"}}
      patch :update, params: params, session: {id: @admin.id}

      @post.reload

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@admin)
      expect(subject).to redirect_to (topic_posts_path(@topic,@post))
      expect(@post.title).to eql("Updated Post Title")
      expect(@post.body).to eql("Updated Post here!")
    end
  end

  describe "destroy topic" do
    it "should redirect if not logged in" do
      params = { topic_id: @topic.slug, id: @post.slug }
      delete :destroy, params: params

      expect(response).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do
      params = { topic_id: @topic.slug, id: @post.slug}
      delete :destroy, params: params, session: {id: @unauthorized_user.id}

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render destroy only if you are the user who created this post" do

      params = {topic_id:@topic.slug ,id: @post.slug}
      delete :destroy, params: params, session: {id: @post.user.id}


      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@post.user)
      expect(subject).to redirect_to (topic_posts_path)
    end

    it "should render destroy only if you are admin" do

      params = {topic_id:@topic.slug ,id: @post.slug}
      delete :destroy, params: params, session: {id: @admin.id}


      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@admin)
      expect(subject).to redirect_to (topic_posts_path(@topic))
    end

  end
end
