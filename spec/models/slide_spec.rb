require 'spec_helper'

describe Slide do
  it { should belong_to(:story_board) }
  
  context 'internal_link_action_items' do
    let(:slide) { FactoryGirl.create(:slide_with_many_action_items) }
    
    it 'should return link action items that have an internal link' do
      slide.action_items[1].update_attributes :action_type => 'link', :data => {"internal_link"=>"100"}
      slide.internal_link_action_items.count.should eql(1)
    end
    
    it 'should disregard link action items with nil data' do
      slide.action_items[1].update_attributes :action_type => 'link', :data => nil
      slide.internal_link_action_items.count.should eql(0)
    end
  end
end
