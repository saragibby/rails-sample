class AddSecurityLevelToStoryBoards < ActiveRecord::Migration
  def change
    add_column :story_boards, :security_level, :string, :default => 'public'
    add_column :story_boards, :password, :string
  end
end
