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
        more = ""
        more = "<br>You cannot edit a fact." unless role? 'staff'
        ret << "] <span title='This is a Factual dimension#{more}'>" << image_tag("/images/star.png") << "</span>"
      end
    end
  end
  
  def display_bar(rating, max, link = nil)
    percent = Integer(rating * (100 / max))
    ret = "#{link ? '<a href=' + link + '>' : ''}<ul class='star-rating'>"
    ret += "<li class='current-rating one' style='width:#{percent}px;'>#{rating}/5.</li>"
    ret += "</ul>#{link ? '</a>' : ''}"
  end
    
  def show_distance_bar(num_dims_used, distance, link = nil)
    if num_dims_used > 0
      #return dist.to_s
      display_bar(num_dims_used - distance, num_dims_used, link)
    else
      "Not available"
    end
  end
  
  def show_rater(dim, key, value)
    ret = "<span class='indicator'>#{dim.valuable.low_text}</span> "
    for i in 1..5
      ret << radio_button_tag( key, i, value ? value == i : false) << " "
    end
    ret << " <span class='indicator'>#{dim.valuable.high_text}</span>"
  end
  
  def show_booler(dim, key, value, high = "Like", low = "Dislike")
    ret = "<span class='indicator'>#{high}</span> "  
    ret << radio_button_tag( key, 1, value ? value == 1 : false) << " "
    ret << radio_button_tag( key, 0, value ? value == 0 : false) << " "
    ret << " <span class='indicator'>#{low}</span>"  
  end
  
  def show_tooltip_for(dim)
    these_concepts = ""
    dim.concepts.each {|x| these_concepts << "<li>" << x.name}
    unless dim.desc.blank?
      these_concepts << "<br><hr><u>Description:</u><br>" << dim.desc
    end
  
    title = "<span title='<u>Affects:</u><br>#{these_concepts}'>"
    title << image_tag("tooltip.gif") << "</span>"
    return title
  end
end
