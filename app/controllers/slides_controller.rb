class SlidesController < ApplicationController
  def show
    @slide = Slide.find(params[:id])
    render :json => { :action_items => @slide.action_items }.merge(@slide.attributes)
  end
  
  def new
    @story_board = StoryBoard.find(params[:story_board_id])
    @slide = @story_board.slides.build
  end
  
  def create
    @story_board = StoryBoard.find(params[:story_board_id])
    @current_slide = params[:current_slide_id].present? ? Slide.find(params[:current_slide_id]) : @story_board.slides.first
    @story_board.update_attributes(params[:story_board]) if params[:story_board].present?
    @story_board.starting_order_number = @current_slide.order_number
    
    respond_to do |format|
      if @story_board.save
        slide_created = @story_board.slides.where(:order_number => @current_slide.order_number + 100).first
        
        format.html {  
          render :json => @story_board.attachments.map(&:to_fileupload_json).to_json, 
          # :content_type => 'text/html',
          :layout => false
        }
        format.json { render :json => @story_board.json_response.to_json }
        format.js
      else
        format.html { render :action => "edit" }
        format.json { render :json => @story_board.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end
  
  def update
    @slide = Slide.find(params[:slide_id] || params[:id])
    @story_board = @slide.story_board
    @selected_slide = params[:current_slide_id].present? ? Slide.find(params[:current_slide_id]) : @slide
    
    @slide.update_attributes params[:slide]    
    
    if params[:upload].present?
      attachment = StoryBoardAttachment.create(:story_board => @story_board, :upload => params[:upload])
      @slide.update_slide(@slide,attachment)
    else
      @story_board.refresh_slide_order_numbers
    end
    
    respond_to do |format|
      if @slide.save
        format.html { redirect_to @story_board }
        format.js   { render 'update' }
        format.json { render :json => @story_board, :status => :created, :location => @story_board }
      else
        format.html { redirect_to @story_board }
        format.json { render :json => @story_board.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @slide = Slide.find(params[:id])
    @story_board = @slide.story_board
    @story_board.empty_links_to(@slide)
    @selected_slide = Slide.find(params[:current_slide_id])
    @slide.destroy

    respond_to do |format|
      format.html { redirect_to @story_board }
      format.json { render :json => @story_board }
      format.js   { render 'update' }
    end
  end

  def crop
    @slide = Slide.find(params[:slide_id])
    render :json => { :url => "#{@slide.image.url}?#{rand}" }
  end

  def resize
    @slide = Slide.find(params[:slide_id])
    render :json => { :url => "#{@slide.image.url}?#{rand}" }
  end

end
