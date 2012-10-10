class CreateActionItems < ActiveRecord::Migration
  def change
    create_table :action_items do |t|
      t.references :slide
      t.string :action_type
      t.integer :top
      t.integer :left
      t.integer :width
      t.integer :height
      t.text :data

      t.timestamps
    end
    add_index :action_items, :slide_id
  end
end
