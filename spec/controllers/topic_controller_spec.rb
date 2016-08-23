require 'rails_helper'

 RSpec.describe TopicsController, type: :controller do

   before(:all) do
    @admin = User.create(username: "admin01", email: "admin@gmail.com", password: "admin", role: 2)
    @unauthorized_user = User.create(username:"user01", email:"user@hotmail.com", password:"12345", role: 0 )
    @topic = Topic.create(title: "testing2", description: "test description", user_id: @admin.id)
  end

  describe "index topics" do
    it "should render index" do

      get :index
      expect(subject).to render_template(:index)
    end
  end

  describe "create topics" do

    it "should redirect if not logged in" do

      params = { topic:{ title: "testing2", description: "test description" } }
      post :create, xhr: true, params: params

      expect(flash[:danger]).to eql("You need to login first")
    end


    it "should redirect if user unauthorized" do

      params = { topic:{ title: "testing2", description: "test description" } }
      post :create,xhr: true, params: params, session: { id: @unauthorized_user.id }

      expect(flash[:danger]).to eql("You're not authorized")

    end

    it "should render create only if you are admin" do

      params = {topic: {title: "testing2", description: "test description"}}
      post :create, xhr: true, params: params, session: {id: @admin.id}



      expect(Topic.count).to eql(2)
      new_topic = Topic.friendly.find("testing2")
      expect(new_topic.title).to eql("testing2")
      expect(new_topic.description).to eql("test description")
      expect(flash[:success]).to eql("You've created a new topic.")
    end
  end



  describe "edit topic" do

    it "should redirect if not logged in" do


      params = { id: @topic.slug }
      get :edit, params: params

      expect(response).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

    params = { id: @topic.slug}
    get :edit, params: params, session: {id: @unauthorized_user.id}

    expect(subject).to redirect_to(root_path)
    expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render edit only if you are admin" do

      params = {id: @topic.slug}
      get :edit, params: params, session: {id: @admin.id}

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@admin)
      expect(subject).to render_template(:edit)

    end
  end

  describe "update topic" do

    it "should redirect if not logged in" do


      params = { id: @topic.slug }
      patch :update, params: params

      expect(response).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

      params = { id: @topic.slug}
      patch :update, params: params, session: {id: @unauthorized_user.id}

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render update only if you are admin" do

      params = {id: @topic.slug, topic:{ title: "Updated Topic Title", description: "Updated Topic here!" }}
      patch :update, params: params, session: {id: @admin.id}

      @topic.reload

      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@admin)
      expect(subject).to redirect_to (topics_path(@topic))
    end
  end

  describe "destroy topic" do

    it "should redirect if not logged in" do


      params = { id: @topic.slug }
      delete :destroy, params: params

      expect(response).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You need to login first")
    end

    it "should redirect if user unauthorized" do

      params = { id: @topic.slug}
      delete :destroy, params: params, session: {id: @unauthorized_user.id}

      expect(subject).to redirect_to(root_path)
      expect(flash[:danger]).to eql("You're not authorized")
    end

    it "should render destroy only if you are admin" do

      params = {id: @topic.slug}
      delete :destroy, params: params, session: {id: @admin.id}


      current_user = subject.send(:current_user)
      expect(current_user).to be_present
      expect(current_user).to eql(@admin)
      expect(subject).to redirect_to (topics_path)
    end

  end
end
