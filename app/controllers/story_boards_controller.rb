class StoryBoardsController < ApplicationController
  before_filter :load_object, :except => [:index, :new, :create]
  before_filter :check_permissions, :only => [:show]

  def index
    @story_boards = current_user.story_boards

    respond_to do |format|
      format.html
      format.json { render :json => @story_boards }
    end
  end

  def show
    session[:create_story_board_id] = nil
    if @story_board.clean?
      @selected_slide = params[:slide_id].present? ? @story_board.slides.find(params[:slide_id].to_i) : @story_board.slides.first
    end
      
    respond_to do |format|
      format.html { render :layout => 'story_board' }
      format.json { render :json => @story_board }
      format.js
    end
  end

  def preview
    @selected_slide = params[:current_slide_id].present? ? @story_board.slides.find(params[:current_slide_id]) : @story_board.slides.first
    if @story_board.private?
      preview_private
    else
      render :layout => 'story_board_preview'
    end
  end
  
  def duplicate
    @new_story_board = @story_board.duplicate
    redirect_to story_boards_path
  end

  def new
    create_story_board

    respond_to do |format|
      format.html
      format.json { render :json => @story_board }
    end
  end

  def create
    @story_board.update_attributes(params[:story_board])
    
    respond_to do |format|
      if @story_board.save
        format.html {  
          render :json => @story_board.attachments.map(&:to_fileupload_json).to_json, 
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render :json => @story_board.json_response.to_json }
        
      else
        format.html { render :action => "new" }
        format.json { render :json => @story_board.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /story_boards/1
  # PUT /story_boards/1.json
  def update
    @selected_slide = params[:current_slide_id].present? ? @story_board.slides.find(params[:current_slide_id]) : @story_board.slides.first
    @story_board.update_attributes(params[:story_board])
    
    respond_to do |format|
      if @story_board.attachments_present?
        format.html {  
          render :json => @story_board.attachments.map(&:to_fileupload_json).to_json, 
          :content_type => 'text/html',
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

  # DELETE /story_boards/1
  # DELETE /story_boards/1.json
  def destroy
    @story_board.destroy

    respond_to do |format|
      format.html { redirect_to story_boards_url }
      format.json { head :ok }
    end
  end
  
  private 
  
    def load_object
      @story_board = StoryBoard.find(params[:id])
    end
  
    def check_permissions
      if @story_board.user != current_user
        flash[:notice] = 'Not authorized to view story board'
        redirect_to root_url
      end
    end
    
    def preview_private
      case
      when user_entered_password.present? 
        if @story_board.valid_password?(user_entered_password)
          set_password_to_session
          render :layout => 'story_board_preview'
        else
          preview_needs_password
        end
      when password_in_session?
        @story_board.valid_password?(session_password) ? render(:layout => 'story_board_preview') : preview_needs_password
      else
        render 'preview_private', :layout => 'story_board_preview'
      end
    end
    
    def preview_needs_password
      flash[:error] = "Password was incorrect"
      render 'preview_private', :layout => 'story_board_preview'
    end
    
    def user_entered_password
      if params[:story_board].present? 
        pass = params[:story_board][:password] if params[:story_board][:password].present?
      end
      pass || ''
    end
    
    def password_in_session?
      session[:story_board_passwords].nil? ? false : session_password.present?
    end
    
    def session_password
      session[:story_board_passwords][@story_board.id]
    end
    
    def set_password_to_session
      session[:story_board_passwords] = {} if session[:story_board_passwords].nil?
      session[:story_board_passwords] = session[:story_board_passwords].merge({@story_board.id => @story_board.password})
    end
    
    def new_story_board_in_session?
      !session[:create_story_board_id].nil?
    end
    
    def create_story_board
      @story_board = StoryBoard.create(:title => current_user.next_story_board_title, :user => current_user, :background => StoryBoard::DEFAULT_BACKGROUND)
    end
    
    def find_story_board
      @story_board = StoryBoard.find(params[:id])
    end
end
