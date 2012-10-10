class ActionItem < ActiveRecord::Base
  include Shared::AttachmentHelper
  
  belongs_to :slide
  serialize :data
  validates_presence_of :width, :height, :top, :left, :slide_id
  validates_presence_of :slide_id, :action_type, :if => proc{ |action_item| !action_item.data.nil? }
  delegate :story_board, :to => :slide
  
  has_attachment :user_gif, { :path => "/story_boards/:story_board_id/slides/:slide_id/action_items/:id/:style.:extension" }
  
  scope :links, where(:action_type => 'link')
  scope :order_by_top, order('action_items.top, action_items.left')

  FONTS = [
    ['Arial/Helvetica', 'Arial, Helvetica, sans-serif'],
    ['Times New Roman/Times', '"Times New Roman", Times, serif'],
    ['Courier New/Courier', '"Courier New", Courier, monospace'],
    ['Verdana', 'Verdana, Geneva, sans-serif']
  ]
  
  FONT_COLORS = [
    "FFFFFF","FFDFDF","FFBFBF","FF9F9F","FF7F7F","FF5F5F","FF3F3F","FF1F1F","FF0000","DF1F00",
    "C33B00","A75700","8B7300","6F8F00","53AB00","37C700","1BE300","00FF00","00DF1F","00C33B",
    "00A757","008B73","006F8F","0053AB","0037C7","001BE3","0000FF","0000df","0000c3","0000a7",
    "00008b","00006f","000053","000037","00001b","000000" 
  ]
  
  BACKGROUND_COLORS = FONT_COLORS << 'transparent'

  def data_attrs
    data = attributes.dup
    %w{data id slide_id created_at updated_at}.each{|key| data.delete(key)}
    (self.data || {}).each do |key, val|
      data["data_#{key}"] = val
    end
    data
  end
  
  def duplicate(slide)
    if self.action_type
      action_item = ActionItem.create(:slide => slide, :action_type => self.action_type, :top => self.top, 
                                      :left => self.left, :width => self.width, :height => self.height, :data => self.data)
      action_item.update_attributes :user_gif => self.user_gif if self.user_gif.present?
    end
  end
  
  def remove_internal_link
    self.data["internal_link"] = ""
    self.save
  end
  
  
  def incomplete?
    case
    when action_type == 'link' then data.nil? ? true : data['internal_link'].blank?
    else false
    end
  end
  
  def as_json(options = { })
      h = super(options)
      h[:incomplete] = incomplete?
      h
  end
  
end
