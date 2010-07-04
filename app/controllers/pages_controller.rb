class PagesController < ApplicationController
  def home
    @title = "Home"
    @top = 5
    @topten = Entity.all.collect do |e|
      n, d = e.get_distance_from_ideal
      e.distance = d
      e.num_dims_used = n
      e
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
