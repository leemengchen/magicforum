require "rails_helper"

RSpec.feature "User Management", type: :feature, js: true do

  scenario "User registers" do

    visit root_path
    click_button('REGISTER')
    fill_in 'user_username_field', with: 'badman'
    fill_in 'user_password_field', with: 'password'
    fill_in 'user_email_field', with: 'badman@email.com'


    click_button('Create New User')

    user = User.find_by(email: "badman@email.com")

    expect(User.count).to eql(1)
    expect(user).to be_present
    expect(user.email).to eql("badman@email.com")
    expect(user.username).to eql("badman")
    expect(find('.flash-messages .message').text).to eql("You've created a new user.")
    expect(page).to have_current_path(root_path)
  end
end
