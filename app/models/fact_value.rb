class FactValue < ActiveRecord::Base
  belongs_to :entity
  belongs_to :fact
end
