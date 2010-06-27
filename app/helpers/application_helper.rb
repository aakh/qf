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
  
  def edit_delete_dimension(dim)
    ret = ""
    if current_user
      # Can't edit a dimension associated with a fact
      fact = Dimension.find_by_name_and_valuable_type dim.name, 'Fact'
      if !fact
        ret << "[#{link_to 'Edit', edit_dimension_path(dim)}"
        #Only staff can delete
        if role? 'staff'
          ret << " | #{link_to 'Delete', dim.valuable, :confirm => 'Are you sure?', :method => :delete}"
        end
        ret << "]"
      elsif fact.name != 'Price' and role? 'staff'
        ret << "[#{link_to 'Edit', edit_dimension_path(fact)}"
        ret << " | #{link_to 'Delete', fact.valuable, :confirm => 'Are you sure?', :method => :delete}"
        ret << "] " << image_tag("/images/star.png")
      end
    end
  end
  
  def display_bar(rating, max)
    percent = Integer(rating * (100 / max))
    ret = "<ul class='star-rating'>"
    ret += "<li class='current-rating one' style='width:#{percent}px;'>Currently #{rating}/5 Stars.</li>"
    ret += "</ul>"
  end
  
  def show_entity_distance(entity)
    display_bar 5, 10
  end
  
  def show_rater(dim, key, value)
    ret = "<span class='indicator'>#{dim.valuable.low_text}</span> "
    for i in 1..5
      ret << radio_button_tag( key, i, value ? value == i : false) << " "
    end
    ret << " <span class='indicator'>#{dim.valuable.high_text}</span>"
  end
  
  def show_booler(dim, key, value)
    ret = "<span class='indicator'>Like</span> "  
    ret << radio_button_tag( key, 1, value ? value == 1 : false) << " "
    ret << radio_button_tag( key, 0, value ? value == 0 : false) << " "
    ret << " <span class='indicator'>Don't like</span>"  
  end
end
