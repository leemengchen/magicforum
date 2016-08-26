require "rails_helper"

RSpec.feature "User Action", type: :feature ,js: true do
  before(:all) do
    @user = create(:user, :sequenced_email, :sequenced_username)
    @admin = create(:user, :admin)
    @topic = create(:topic)
    @post = create(:post,topic_id:@topic.id, user_id: @user.id)

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

  scenario "user create a Post" do


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

  scenario "user create a Comment" do


    visit root_path

    click_button('LOGIN')

    fill_in 'user_email_field', with: @user.email
    fill_in 'user_password_field', with: @user.password

    click_button('Login')

    visit topic_post_comments_path(@topic, @post)

    fill_in 'comment_body_field', with: "Comment body 123"

    click_button("Create Comment")

    expect(find('.flash-messages .message').text).to eql("You've created a new comment.")

    visit topic_post_comments_path(@topic,@post)

    click_link("Edit Comment")

    within(".comment-update-form") do
      fill_in  "comment_body_field", with:"Comment body 123456"
    end

    click_button("Update Comment")

    sleep(1)

    comment = Comment.find_by(body:"Comment body 123456")
    # expect(find('.flash-messages .message').text).to eql("You're successfullly update your comment!")
    expect(comment.body).to eql("Comment body 123456")
    expect(page).to have_content("Comment body 123456")
  end


end
