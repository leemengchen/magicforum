class AddUserIdToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :user_id, :string
    add_column :posts, :integer, :string
  end
end
