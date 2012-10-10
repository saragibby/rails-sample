class AddPerformanceIndexes < ActiveRecord::Migration
  def change
    add_index :slides, :story_board_id, :name => "index_slides_on_story_board_id"
    add_index :slides, [:story_board_id, :order_number], :name => "index slides_on_order_number_for_story_board "
    add_index :slides, :story_board_attachment_id, :name => "index_slides_on_story_board_attachment_id"
    add_index :story_board_attachments, :story_board_id, :name => "index_story_board_attachments_on_story_board_id"
    add_index :story_boards, :user_id, :name => "index_story_boards_on_user_id"
    add_index :users, :email, :name => "index_users_on_email"
  end
end
