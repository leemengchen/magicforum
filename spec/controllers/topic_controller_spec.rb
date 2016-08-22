require 'rails_helper'

 RSpec.describe TopicsController, type: :controller do

   before(:all) do
    @user = User.create(username: "admin01", email: "admin@gmail.com", password: "admin", role: 2)
    @unauthorized_user = User.create(username:"user01", email:"user@hotmail.com", password:"user", role: 0)
  end

  describe "index topics" do
    it "should render index" do

      get :index
      expect(subject).to render_template(:index)
    end
  end

  describe "create topics" do

    it "should redirect if not logged in" do

      params = { topic:{ title: "testing", description: "test description" } }
      post :create, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end


    it "should redirect if user unauthorized" do

      params = { topic:{ title: "testing", description: "test description" } }
      post :create,xhr: true, params: params, session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You need to login first")

    end

    it "should render create only if you are admin" do

      params = {topic: {title: "testing2", description: "test description"}}
      post :create, xhr: true, params: params, session: {id: @user.id}



      expect(Topic.count).to eql(1)
      new_topic = Topic.friendly.find("testing2")
      expect(new_topic.title).to eql("testing2")
      expect(new_topic.description).to eql("test description")
      expect(flash[:success]).to eql("You've created a new topic.")
    end
  end
end
