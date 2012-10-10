class AddDirtyFlagToStoryBoards < ActiveRecord::Migration
  def change
    add_column :story_boards, :dirty, :boolean, :default => false
  end
end
