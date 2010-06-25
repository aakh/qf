class BeliefsController < ApplicationController
  before_filter :check_logged_in
  
  def update
    params[:ideals].each do |key, entry|
      weight = params[:weights]
      weight = params[:weights][key] if weight
      entry = nil if entry.blank?
      
      dim = Dimension.find key
      belief = Belief.find_by_user_id_and_opinion_id current_user, dim.valuable
      
      if belief and !entry and !weight
        belief.destroy
      else
        belief = Belief.new unless belief
        belief.ideal = entry
        belief.weight = weight
        belief.user = current_user
        belief.opinion = dim.valuable
        belief.save
      end
    end
    
    flash[:notice] = "Beliefs updated."
    redirect_to beliefs_path
  end

end
