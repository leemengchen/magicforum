class AddImageToTopics < ActiveRecord::Migration[5.0]
  def change
    add_column :topics, :image, :string
  end
end
