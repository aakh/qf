# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  DISTANCE_ALGO = :cristian
  
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
    case DISTANCE_ALGO
    when :cristian then show_entity_distance_cristian(entity)
    end
  end
  
  def show_entity_distance_cristian(entity)
    dist = 0
    total = 0
    i = 0
    entity.concept.opinion_dimensions.each do |dim|
      #For each dimension that this entity can be rated over
      # Get ideal and weight value
      # Get rating for this entity over the dimension
      # Get percentage of rating within ideal
      opinion = dim.valuable
      
      ideal = opinion.total_ideal / opinion.num_ideals
      weight = opinion.total_weight / opinion.num_weights

      # If no ideal then there's nothing to calculate the distance from, carry on
      next unless opinion.num_ideals > 0
      
      # if weight is I don't care then this dimension should be ignored
      next if weight == 1
      
      weight = 4 unless opinion.num_weights > 0
      weight = (weight - 1) / 4
      
      # Boolean ideals are between 0 and 1, but the actual fact values
      # Are either 0 or 1.
      if opinion.dimension.bool?
        fv = FactValue.get_value(Fact.find_by_name(dim.name), entity)
        next unless fv
        rating = if fv then fv.value else 1 end
        rating = rating * 4 + 1
        ideal = ideal * 4 + 1
      else
        cr = CurrentRating.find_by_entity_id_and_opinion_id(entity, opinion)
        # If this dimension doesn't have a rating then carry on with the next.
        next unless cr
        rating = if cr.num_ratings > 0 then cr.total_rating / cr.num_ratings else 1 end
      end

      # Simple distance calculation
      # dist += ((ideal - rating).abs + 1) * weight
      
      x = (1 - rating) / (1 - 5)
      y = (1 - ideal) / (1 - 5)
      i += 1
      
      next if x == y
      
      x *= weight
      y *= weight
      dist += 0.5 * (1 + (x - y).abs - (1 - x - y).abs)

    end
    
    if i > 0
      #return dist.to_s
      display_bar(i - dist, i)
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
  
  def show_booler(dim, key, value, high = "Like", low = "Don't like")
    ret = "<span class='indicator'>#{high}</span> "  
    ret << radio_button_tag( key, 1, value ? value == 1 : false) << " "
    ret << radio_button_tag( key, 0, value ? value == 0 : false) << " "
    ret << " <span class='indicator'>#{low}</span>"  
  end
end
