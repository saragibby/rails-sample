class AddBackgroundToStoryBoards < ActiveRecord::Migration
  def change
    add_column :story_boards, :background, :string
  end
end
