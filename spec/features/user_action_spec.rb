require "rails_helper"

RSpec.feature "User Navigation", type: :feature ,js: true do
  before(:all) do
    @user = create(:user)
    @admin = create(:user, :admin)
    @topic = create(:topic)
    # @topic = create(:topic)
  end

  scenario "admin log in and create and  topic" do

        visit root_path

        click_button('LOGIN')

        fill_in 'user_email_field', with: 'admin1@email.com'
        fill_in 'user_password_field', with: 'password'

        click_button('Login')

        expect(find('.flash-messages .message').text).to eql("Welcome back admin1")
        expect(page).to have_current_path(root_path)

        visit topics_path

        fill_in 'topic_title_field', with: 'Topic 1111111'
        fill_in 'topic_description_field', with: 'Topic Description'

        click_button("Create Topic")

        expect(find('.flash-messages .message').text).to eql("You've created a new topic.")

      end

    scenario "admin edit a topic" do

        visit root_path

        click_button('LOGIN')

        fill_in 'user_email_field', with: 'admin1@email.com'
        fill_in 'user_password_field', with: 'password'

        click_button('Login')

        expect(find('.flash-messages .message').text).to eql("Welcome back admin1")
        expect(page).to have_current_path(root_path)

        visit topics_path

        click_link('Topic 1111111')
        click_button("Edit This Topic")

        fill_in  "topic_title_field", with:"Topic123"

        click_button("Update Topic")

        topic = Topic.find_by(title:"Topic123")

        expect(topic.title).to eql("Topic123")
  end

  scenario "user create a topic" do


        visit root_path

        click_button('LOGIN')

        fill_in 'user_email_field', with: @user.email
        fill_in 'user_password_field', with: @user.password

        click_button('Login')

        visit topic_posts_path(@topic)

        fill_in 'post_title_field', with: "Post title 123"
        fill_in 'post_body_field', with: "Post description 123"

        click_button("Create Post")

        expect(find('.flash-messages .message').text).to eql("You've created a new post!!!")

        visit topic_posts_path(@topic)

        click_link('Post title 123')
        click_button("Edit This Post")

        fill_in  "topic_title_field", with:"Post title 123456"

        click_button("Update Post")

        post = Post.find_by(title:"Post title 123456")

        expect(post.title).to eql("Post title 123456")
  end


end
