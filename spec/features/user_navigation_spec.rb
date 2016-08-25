require "rails_helper"

RSpec.feature "User Navigation", type: :feature ,js: true do
  before(:all) do
    @user = create(:user)
  end

  scenario "User log in and edit the account" do

    visit root_path

    click_button('LOGIN')

    fill_in 'user_email_field', with: 'user@email.com'
    fill_in 'user_password_field', with: 'password'

    click_button('Login')

    expect(find('.flash-messages .message').text).to eql("Welcome back bob")
    expect(page).to have_current_path(root_path)

    visit root_path

    click_link("bob")

    fill_in "user_username_field", with: "updatedbob"

    click_button("Update Profile")

    expect(page).to have_current_path(root_path)
    @user.reload
    expect(@user.username).to eql("updatedbob")
  end

  scenario " User log out" do

    visit root_path

    click_button('LOGIN')

    fill_in 'user_email_field', with: 'user@email.com'
    fill_in 'user_password_field', with: 'password'

    click_button('Login')

    expect(find('.flash-messages .message').text).to eql("Welcome back #{@user.username}")
    expect(page).to have_current_path(root_path)

    visit root_path

    click_link('Logout')

    expect(find('.flash-messages .message').text).to eql("You've been logged out")
  end
end
