module SlidesHelper
  def slide_sidebar_class(slide,selected_slide)
    slide == @selected_slide ? "current slide" : "slide"
  end
end
