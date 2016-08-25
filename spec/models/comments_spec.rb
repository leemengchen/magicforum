require 'rails_helper'

RSpec.describe Comment, type: :model do

  context "assocation" do
    it { should have_many(:votes) }
  end

  context "belongs to" do
    it { should belong_to(:user) }
  end

  context "belongs to" do
    it { should belong_to(:post) }
  end

  context "body validation" do
    it { should validate_presence_of(:body) }
    it { should validate_length_of(:body).is_at_least(5) }
  end

end
