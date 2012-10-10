class RenameActionItemImageFields < ActiveRecord::Migration
  def change
    rename_column :action_items, :image_file_name, :user_gif_file_name
    rename_column :action_items, :image_content_type, :user_gif_content_type
    rename_column :action_items, :image_file_size, :user_gif_file_size
  end
end
