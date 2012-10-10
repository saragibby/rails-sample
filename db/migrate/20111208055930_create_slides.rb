class CreateSlides < ActiveRecord::Migration
  def change
    create_table :slides do |t|
      t.integer :story_board_id
      t.string  :title
      t.integer :order_number
      t.string  :image_file_name
      t.string  :image_content_type
      t.string  :image_file_size
      t.timestamps
    end
  end
end
