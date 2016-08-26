require "rails_helper"

RSpec.feature "User Votes", type: :feature ,js: true do
  before(:all) do
    @user = create(:user, :sequenced_email, :sequenced_username)
    @admin = create(:user, :admin)
    @topic = create(:topic)
    @post = create(:post,topic_id:@topic.id, user_id: @user.id)
    @comment = create(:comment,  post_id:@post.id, user_id:@user.id)

  end

    scenario "User able to upvote" do

      visit("http://localhost:3000")

      click_button('LOGIN')

      fill_in 'user_email_field', with: "mengchenlee0212@gmail.com"
      fill_in 'user_password_field', with: "20396509"

      click_button('Login')

      click_button("close-button")
      click_link("Topics")
      click_link("TestTopic")
      click_link("TestPost")

      find(".comment-child[data-id='194'] .fa-thumbs-up").click
      expect(find(".votes-score")).to have_content(1)
    end
end
