class AddAttachmentFieldsToStoryBoards < ActiveRecord::Migration
  def change
    add_column :story_boards, :attachment_file_name, :string
    add_column :story_boards, :attachment_content_type, :string
    add_column :story_boards, :attachment_file_size, :integer
  end
end
