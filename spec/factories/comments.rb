FactoryGirl.define do
   factory :comment do

     body "Comment Body"
     user_id { create(:user ,:sequenced_email).id }

     trait :body do
       sequence(:body) { |n| "Comment body#{n}" }
     end

  end
end
