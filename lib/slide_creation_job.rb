class SlideCreationJob < Struct.new(:story_board_id)
  def perform
    story_board = StoryBoard.find(story_board_id)
    story_board.create_slides
  end
end