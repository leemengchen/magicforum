require 'rails_helper'

 RSpec.describe PasswordResetsController, type: :controller do

   before(:all) do

    @user = User.create(username: "normal user", email: "normaluser@gmail.com", password: "12345", role: 0)

  end


  describe " A user get into a reset password page" do
    it " anyone can access into a reset password page" do

      get :new

      expect(subject).to render_template :new
    end
  end


  describe "A user get reset the password" do
    it "Only valid user able to set new password"  do

      email = @user.email
      params= {reset: { email: email }}
      post :create, params: params

      expect(email).to eq(@user.email)
      expect(subject).to redirect_to (new_password_reset_path)
      expect(flash[:success] = "We've sent you instructions on how to reset your password")

    end

    it "invalid user not allowed" do
      email = "no@such.com"
      params = { reset: { email: email}}
      post :create, params: params

      expect(email).not_to eq(@user.email)
      expect(subject).to redirect_to (new_password_reset_path)
      expect(flash[:success] = "User does not exist")

    end
  end


  describe " edit password page" do
    it " A valid user get into a edit password page" do

      params = { id: @user.id }
      get :edit, params: params

      expect(subject).to render_template :edit
    end

  it "A valid user able to update password" do
      @user.update(password_reset_token: "token", password_reset_at: DateTime.now )
      params = { id: @user.password_reset_token , user: {password:"newpassword"}}
      patch :update, params: params

      @user.reload

      @oldpassword = @user.authenticate("12345")
      @user = @user.authenticate("newpassword")

      expect(@oldpassword).to eql(false)
      expect(@user).to be_present
      expect(flash[:success] = "Password updated, you may log in now")
      expect(subject).to redirect_to(root_path)

    end

    it "should error token invalid" do
      user = User.find_by( id:@user.id)
      @user.update(password_reset_token: "correcttoken", password_reset_at: DateTime.now )
      wrongtoken = "wrongtoken"

      params = { id: wrongtoken , user: {password:"newpassword"},password_reset_at: DateTime.now }
      patch :update, params: params

      @user.reload

      expect(@user.password).to eql("12345")
      expect(flash[:danger]).to eql("Error, token is invalid or has expired")
      expect(subject).to redirect_to(edit_password_reset_path)

    end
  end

end
