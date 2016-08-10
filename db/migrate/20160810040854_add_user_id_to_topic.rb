class AddUserIdToTopic < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :user_id, :string
    add_column :topics, :integer, :string
  end
end
