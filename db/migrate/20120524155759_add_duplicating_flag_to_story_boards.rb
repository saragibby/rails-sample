class AddDuplicatingFlagToStoryBoards < ActiveRecord::Migration
  def change
    add_column :story_boards, :duplicating, :boolean, :null => false, :default => false
  end
end
