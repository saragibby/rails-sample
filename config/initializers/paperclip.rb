Paperclip.interpolates('story_board_id') do |attachment, style|
  attachment.instance.story_board.id
end

Paperclip.interpolates('slide_id') do |attachment, style|
  attachment.instance.slide.id
end