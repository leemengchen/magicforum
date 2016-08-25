FactoryGirl.define do
   factory :post do

     title "Post Title"
     body "Post Body"
     user_id { create(:user).id }


    trait :with_image do
      image { fixture_file_upload("#{::Rails.root}/spec/fixtures/cat.jpg") }
    end

     trait :title do
       sequence(:title) { |n| "Post Title#{n}" }
     end

     trait :body do
       sequence(:body) { |n| "Post body#{n}" }
     end

  end
end
