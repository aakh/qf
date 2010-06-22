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
  
  def edit_delete_opinion_dimension(dim)
    ret = ""
    if current_user
      # Can't edit a dimension associated with a fact
      unless Dimension.find_by_name_and_valuable_type dim.name, 'Fact'
        ret += "[#{link_to 'Edit', edit_dimension_path(dim)}"
        #Only staff can delete
        if role? 'staff'
          ret += " | #{link_to 'Delete', dim.valuable, :confirm => 'Are you sure?', :method => :delete}"
        end
        ret += "]"
      end
    end
  end
  
  def edit_delete_fact_dimension(dim)
    ret = ""
    if role? 'staff'
      unless dim.name == 'Price'
        ret << "[#{link_to 'Edit', edit_dimension_path(dim)}"
        ret << " | #{link_to 'Delete', dim.valuable, :confirm => 'Are you sure?', :method => :delete}"
        ret << "]"
      end
    end
  end
end
