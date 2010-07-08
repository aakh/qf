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
          ret << "|#{link_to 'Delete', dim.valuable, :confirm => 'Are you sure?', :method => :delete}"
        end
        ret << "]"
      elsif fact.name != 'Price' and role? 'staff'
        ret << "[#{link_to 'Edit', edit_dimension_path(fact)}"
        ret << "|#{link_to 'Delete', fact.valuable, :confirm => 'Are you sure?', :method => :delete}"
        more = ""
        more = "<br>You cannot edit a fact." unless role? 'staff'
        ret << "]<span title='This is a Factual dimension#{more}'>" << image_tag("/images/star.png") << "</span>"
      end
    end
  end
  
  def set_belief_for(dim)
    if dim and current_user
      #if dim.bool? then return "HAHA" end
      unless Belief.find_by_user_id_and_opinion_id current_user, dim.valuable
        image = image_tag("belief_not_set.gif")
        title = "Set your belief for this dimension"
      else
        image = image_tag("belief_set.gif")
        title = ""
      end
      link_to(image, one_belief_path(dim), :title => title, :class => "popup" )
    else
      ""
    end
  end
  
  def display_bar(rating, max, link = nil)
    percent = Integer(rating * (100 / max))
    ret = "#{link ? '<a href=' + link + '>' : ''}<ul class='star-rating'>"
    ret += "<li class='current-rating one' style='width:#{percent}px;'>#{rating}/5.</li>"
    ret += "</ul>#{link ? '</a>' : ''}"
  end
  
  def get_rating_from_10_for(entity, local = false)
    num_dims_used, distance = entity.get_distance_from_ideal(local ? current_user : nil)
    return nil unless num_dims_used > 0
    (num_dims_used - distance) / num_dims_used * 10
  end
    
  def show_distance_bar(out_of_10, link = nil)
    if out_of_10
      #return dist.to_s
      "<span title='<b>#{'%.1f' % out_of_10}/10</b>'>" + display_bar(out_of_10, 10, link) + "</span>"
      
    else
      "Not available"
    end
  end
  
  def show_rater(dim, key, value)
    ret = "<span class='indicator'>#{h dim.valuable.low_text}</span> "
    for i in 1..5
      ret << radio_button_tag( key, i, value ? value == i : false) << " "
    end
    ret << " <span class='indicator'>#{h dim.valuable.high_text}</span>"
  end
  
  def show_booler(dim, key, value, high = "Like", low = "Dislike")
    ret = "<span class='indicator'>#{h high}</span> "  
    ret << radio_button_tag( key, 1, value ? value == 1 : false) << " "
    ret << radio_button_tag( key, 0, value ? value == 0 : false) << " "
    ret << " <span class='indicator'>#{h low}</span>"  
  end
  
  def show_tooltip_for(dim)
    these_concepts = "<u>Affects:</u><br>"
    dim.concepts.each {|x| these_concepts << "<li>" << h(x.name)}
    unless dim.desc.blank?
      these_concepts << "<br><hr><u>Description:</u><br>" << h(dim.desc)
    end
  
    return insert_tooltip these_concepts
  end
  
  def insert_tooltip(text)
    "<span title='#{text}'>" + image_tag("tooltip.gif") + "</span>"
  end
end
