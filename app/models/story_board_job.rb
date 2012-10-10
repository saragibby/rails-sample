class StoryBoardJob < Struct.new(:story_board_id, :starting_order_number)
  def perform
    story_board = StoryBoard.find(story_board_id)
    story_board.create_slides(starting_order_number || 0)
    story_board.update_attributes :dirty => false
  end
end