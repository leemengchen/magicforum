class AddUserIdToComment < ActiveRecord::Migration[5.0]
  def change
    add_column :comments, :user_id, :string
    add_column :comments, :integer, :string
  end
end
