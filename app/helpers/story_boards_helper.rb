module StoryBoardsHelper
  def image_url(action_item)
    action_item.user_gif.present? ? action_item.user_gif.url : ""
  end
  
  def preview_style(story_board,slide)
    case story_board.background
    when 'iPhone'
      width = 320
      height = 460
    when 'iPad'
      width = 1024
      height = 768  
    when 'Web 1024'
      width = slide.image_width > 1024 ? 1024 : slide.image_width
      height = slide.image_height
    when 'Web 1280'
      width = slide.image_width < 1280 ? slide.image_width : 1280
      height = slide.image_height
    end
    "height: #{height}px; width: #{width}px;"
  end
  
  def right_gutter_style(story_board,slide)
    left = visible_canvas_width(story_board) 
    height = visible_canvas_height(story_board,slide) + bottom_gutter_height(visible_canvas_height(story_board,slide),slide)
    width = right_gutter_width(left,slide)
    "left: #{left}px; height: #{height}px; width: #{width}px"
  end
  
  def bottom_gutter_style(story_board,slide)
    top = visible_canvas_height(story_board,slide)
    height = bottom_gutter_height(top,slide)
    width = visible_canvas_width(story_board)
    "top: #{top}px; height: #{height}px; width: #{width}px"
  end
  
  def right_gutter_data(story_board,slide)
    left = visible_canvas_width(story_board) 
    height = visible_canvas_height(story_board,slide) + bottom_gutter_height(visible_canvas_height(story_board,slide),slide)
    width = right_gutter_width(left,slide)
    {left: left, height: height, width: width}
  end
  
  def bottom_gutter_data(story_board,slide)
    top = visible_canvas_height(story_board,slide)
    height = bottom_gutter_height(top,slide)
    width = visible_canvas_width(story_board)
    {top: top, height: height, width: width}
  end
  
  def visible_canvas_width(story_board)
    case story_board.background
    when 'iPhone' then 320
    when 'iPad' then 1024
    when 'Web 1024' then 1024
    when 'Web 1280'then 1280
    else 0
    end
  end

  def visible_canvas_height(story_board,slide)
    case story_board.background
    when 'iPhone' then 460
    when 'iPad' then 768  
    when 'Web 1024' then slide.image_height
    when 'Web 1280' then slide.image_height
    else 0
    end
  end
  
  private
  
    def right_gutter_width(left,slide)
      width = slide.image_width - left
      width > 30 ? width : 30
    end
  
    def bottom_gutter_height(top,slide)
      height = slide.image_height - top
      height > 30 ? height : 30
    end
  
end
