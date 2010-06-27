class BeliefsController < ApplicationController
  before_filter :check_logged_in
  
  def update
  
    params[:ideals].each do |key, entry|
      weight = params[:weights]
      weight = params[:weights][key] if weight
      entry = nil if entry.blank?
      
      dim = Dimension.find key
      opinion = dim.valuable
      belief = Belief.find_by_user_id_and_opinion_id current_user, opinion
      
      if belief
        if belief.ideal
          opinion.num_ideals -= 1
          opinion.total_ideal -= belief.ideal
        end
        if belief.weight
          opinion.num_weights -= 1
          opinion.total_weight -= belief.weight
        end
      end
      
      if belief and !entry and !weight
        belief.destroy
        belief = nil
      else
        belief = Belief.new unless belief
        belief.ideal = entry
        belief.weight = weight
        belief.user = current_user
        belief.opinion = opinion
        belief.save
        opinion.num_ideals += 1 if entry.to_i
        opinion.total_ideal += entry.to_i if entry
        opinion.num_weights += 1 if weight
        opinion.total_weight += weight.to_i if weight
        opinion.save
      end
      
      
    end
    
    flash[:notice] = "Beliefs updated."
    redirect_to beliefs_path
  end

end
