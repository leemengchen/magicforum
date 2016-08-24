require 'rails_helper'

describe PasswordResetsMailer do
  before(:all) do
    @user = User.create(username: "normal user", email: "normaluser@gmail.com", password: "12345", role: 0)
  end

  describe "should send email" do
    it "should send email with link to reset password" do

      @user.update(password_reset_token: "resettoken", password_reset_at: DateTime.now)
      mail = PasswordResetsMailer.password_reset_mail(@user)

      expect(mail.to[0]).to eql(@user.email)
      expect(mail.body.include?("http://localhost:3000/password_resets/resettoken/edit")).to eql(true)
    end
  end
end
