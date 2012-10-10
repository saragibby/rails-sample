class AddStoryBoardAttachmentToSlides < ActiveRecord::Migration
  def change
    add_column :slides, :story_board_attachment_id, :integer
  end
end
