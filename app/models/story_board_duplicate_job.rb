class StoryBoardDuplicateJob < Struct.new(:story_board_id, :new_story_board_id)
  def perform
    @story_board = StoryBoard.find(story_board_id)
    @dup_story_board = StoryBoard.find(new_story_board_id)
    
    slide_match_up = {}
    @story_board.slides.each do |slide| 
      dup_slide = slide.duplicate(@dup_story_board) 
      slide_match_up = slide_match_up.merge({slide.id => dup_slide})
    end
    
    transfer_transitions(slide_match_up)
    transfer_internal_links(slide_match_up)
    
    @dup_story_board.update_attributes :duplicating => false
  end
  
  private 

    def transfer_transitions(slide_match_up)
    end

    def transfer_internal_links(slide_match_up)      
    end
  
end