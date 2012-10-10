require 'spec_helper'

describe StoryBoard do
  it { should belong_to(:user) }
  it { should validate_presence_of(:title) }
  it { should have_many(:slides) }
  
  context 'duplicate' do
    context 'no slide transitions' do
      before(:each) do
        @story_board = FactoryGirl.create(:story_board_with_slides_with_items)
        @story_board_dup = @story_board.duplicate
        Delayed::Worker.new.work_off
      end
    
      it 'should have same name followed by number' do
        @story_board_dup.title.should eql("#{@story_board.title} 1")
      end
    
      it 'should be owned by the same user' do
        @story_board_dup.user.should eql(@story_board.user)
      end
    
      it 'should have duplicate slides' do
        @story_board_dup.slides.size.should eql(@story_board.slides.size)
      end
    
      it 'should have duplicate action items for slides' do
        @story_board_dup.slides.map(&:action_items).flatten.size.should eql(@story_board.slides.map(&:action_items).flatten.size)
      end
    
      it 'should number title correctly' do
        second_dup = @story_board.duplicate
        second_dup.title.should eql("#{@story_board.title} 2")
      end
    end
    
    context 'has slide transitions' do
      before(:each) do
        @story_board = FactoryGirl.create(:story_board_with_slides_with_items)
        @story_board.slides[2].update_attributes :transfer_to_slide_id => @story_board.slides[1].id, :transfer_wait => 2
        @story_board.slides[3].update_attributes :transfer_to_slide_id => @story_board.slides[4].id, :transfer_wait => 2
        @story_board_dup = @story_board.duplicate
        Delayed::Worker.new.work_off
      end
      
      it 'should include slide transitions to duplicated slides' do
        @story_board_dup.slides[2].transfer_to_slide_id.should eql(@story_board_dup.slides[1].id)
        @story_board_dup.slides[2].transfer_wait.should eql(2)
        
        @story_board_dup.slides[3].transfer_to_slide_id.should eql(@story_board_dup.slides[4].id)
        @story_board_dup.slides[3].transfer_wait.should eql(2)
      end
    end
    
    context 'has internal links' do
      before(:each) do
        @story_board = FactoryGirl.create(:story_board_with_slides_with_items)
        @story_board.slides[2].action_items[1].update_attributes :action_type => 'link', :data => {"internal_link"=>"#{@story_board.slides[3].id}"}
        @story_board_dup = @story_board.duplicate
        Delayed::Worker.new.work_off
      end
      
      it 'should convert to correct internal slides of new story board' do
        @story_board_dup.slides[2].action_items[1].data.should eql({"internal_link"=>"#{@story_board_dup.slides[3].id}"})
      end
    end
    
    context 'has broken internal link' do
      before(:each) do
        @story_board = FactoryGirl.create(:story_board_with_slides_with_items)
        @story_board.slides[2].action_items[1].update_attributes :action_type => 'link', :data => {"internal_link"=>""}
        @story_board_dup = @story_board.duplicate
        Delayed::Worker.new.work_off
      end
      
      it 'should convert to correct internal slides of new story board' do
        @story_board_dup.slides[2].action_items[1].data.should eql({"internal_link"=>""})
      end
    end
    
  end
end
