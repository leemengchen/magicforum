require 'rails_helper'

 RSpec.describe SessionsController, type: :controller do

   before(:all) do

    @user = User.create(username: "normal user", email: "normaluser@gmail.com", password: "12345", role: 2)

  end

  describe "User log out"do
    it"user will log out sucessfully" do
      params = {id:@user.id}
      delete :destroy, params: params

      expect(flash[:success] = "You've been logged out")
      expect(subject).to redirect_to(root_path)
    end
  end

end
