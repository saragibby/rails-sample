require 'spec_helper'
 
feature 'delete slide' do
  before(:each) do
    @user = FactoryGirl.create(:user)
    @story_board = FactoryGirl.create(:story_board_with_slides_with_items, :user => @user)
    login(@user)
    visit story_board_path(@story_board)
  end
  
  scenario 'with no internal links to it' do
    delete "/story_boards/#{@story_board.id}/slides/#{@story_board.slides[3].id}", {:current_slide_id => @story_board.slides[1].id}
    
    @story_board.reload
    @story_board.slides.size.should eql(4)
  end
  
  scenario 'with internal links' do
    @story_board.slides[2].action_items[1].update_attributes :action_type => 'link', :data => {"internal_link"=>"#{@story_board.slides[3].id}"}
    delete "/story_boards/#{@story_board.id}/slides/#{@story_board.slides[3].id}", {:current_slide_id => @story_board.slides[1].id}
    
    @story_board.reload
    @story_board.slides[2].action_items[1].reload
    @story_board.slides.size.should eql(4)
    @story_board.slides[2].action_items[1].data.should eql({"internal_link"=>""})
  end
end