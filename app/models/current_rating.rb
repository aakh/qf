class CurrentRating < ActiveRecord::Base
  belongs_to :entity
  belongs_to :opinion
  
  
end
