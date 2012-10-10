class CreateStoryBoardAttachments < ActiveRecord::Migration
  def up
    create_table :story_board_attachments do |t|
      t.integer :story_board_id
      t.string  :upload_file_name
      t.string  :upload_content_type
      t.integer :upload_file_size
      t.boolean :processed, :default => false, :null => false
      t.timestamps
    end
    
    remove_column :story_boards, :attachment_file_name
    remove_column :story_boards, :attachment_content_type
    remove_column :story_boards, :attachment_file_size
  end
  
  def down
    drop_table :story_board_attachments
    
    add_column :story_boards, :attachment_file_name, :string
    add_column :story_boards, :attachment_content_type, :string
    add_column :story_boards, :attachment_file_size, :integer
  end
end
