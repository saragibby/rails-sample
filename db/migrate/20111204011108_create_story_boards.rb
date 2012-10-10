class CreateStoryBoards < ActiveRecord::Migration
  def change
    create_table :story_boards do |t|
      t.integer :user_id
      t.string :title

      t.timestamps
    end
  end
end
