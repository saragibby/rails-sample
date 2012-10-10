class User < ActiveRecord::Base
  attr_accessible :username, :email, :password, :password_confirmation, :admin
  has_secure_password
  
  validates_presence_of :password, :on => :create

  validates :username, :presence => true, :uniqueness => true, :format => { :with => /^[a-z0-9\-_]+$/i,
      :message => "Invalid character in username" }
  validates :email, :presence => true, :uniqueness => true, :email => true
  
  has_many :story_boards
  
  def next_story_board_title
    untitled_story_boards = story_boards.where(:title => StoryBoard::DEFAULT_TITLE)
    untitled_story_boards.size == 0 ? StoryBoard::DEFAULT_TITLE : untitled_story_boards.first.get_next_duplicate_title
  end
end
