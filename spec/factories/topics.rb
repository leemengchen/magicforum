FactoryGirl.define do
   factory :topic do

     title "Topic"
     description "Topic Description"
     user_id { create(:user, :admin).id }

   trait :with_image do
     image { fixture_file_upload("#{::Rails.root}/spec/fixtures/cat.jpg") }
   end

    trait :sequence_title do
      sequence(:title) { |n| "Topic#{n}" }
    end

    trait :sequence_description do
      sequence(:description) { |n| "Topic Descrition#{n}" }
    end

  end
end
