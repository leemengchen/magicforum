require 'rails_helper'

 RSpec.describe PostsController, type: :controller do

   before(:all) do
    @admin = User.create(username: "admin01", email: "admin@gmail.com", password: "admin", role: 2)
    @unauthorized_user = User.create(username:"user01", email:"user@hotmail.com", password:"user", role: 0 )
    @user = User.create(username: "normal user", email: "normaluser@gmail.com", password: "12345", role: 0)
    @moderator = User.create(username: "moderator01", email: "moderator01@gmail.com", password: "12345", role: 2)
    @topic = Topic.create(title: "testing2", description: "test description", user_id: @admin.id)
    @post = @topic.posts.create(title: "testing3", body: "test body")
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


    it "should redirect if user unauthorized" do

      params = { topic_id: @topic.slug, post:{ title: "testing3", body: "test body" } }
      post :create,xhr: true, params: params, session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should render create only you are logged in" do

      params = { topic_id: @topic.slug, post:{ title: "testing3", body: "test body" } }
      post :create, xhr: true, params: params, session: {id: @admin.id}



      new_post = Post.friendly.find("testing3")
      expect(new_post.title).to eql("testing3")
      expect(new_post.body).to eql("test body")
      expect(Post.count).to eql(2)
      expect(flash[:success]).to eql("You've created a new post!!!")
    end
  end
end
