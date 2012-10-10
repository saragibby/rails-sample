require 'spec_helper'

describe ActionItem do  
  context 'incomplete' do
    it 'should be true if no internal link set in data' do
      action_item = FactoryGirl.create(:action_item_with_broken_internal_link)
      action_item.should be_incomplete
    end
    
    it 'should be false if internal link set' do
      action_item = FactoryGirl.create(:action_item_with_internal_link)
      action_item.should_not be_incomplete
    end
  end
end
