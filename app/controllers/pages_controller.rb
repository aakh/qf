class PagesController < ApplicationController
  def home
    @title = "Home"
    @top = 10
    @topten = Entity.all(:include => [{:concept => :dimensions}]).select do |e|
      e.num_dims_used = 0;
      if e.rated_yet?
        n, d = e.get_distance_from_ideal
        e.distance = d
        e.num_dims_used = n
      end
      e.num_dims_used > 0
    end.sort[0..(@top - 1)]
  end

  def contact
    @title = "Contact"
  end
  
  def about
    @title = "About"
  end
  
  def help
    @title = "Help"
  end
end
