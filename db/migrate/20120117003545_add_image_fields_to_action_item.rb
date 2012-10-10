class AddImageFieldsToActionItem < ActiveRecord::Migration
  def change
    add_column :action_items, :image_file_name, :string
    add_column :action_items, :image_content_type, :string
    add_column :action_items, :image_file_size, :string
  end
end
