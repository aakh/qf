# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title
    base_title = "QF"
    if @title.nil?
      base_title
    else
      "#{base_title} - #{@title}"
    end
  end
  
  def logo
    image_tag( "logo.png", :alt => "QF Hub", :class => "logo" )
  end
end
