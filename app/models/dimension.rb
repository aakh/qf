class Dimension < ActiveRecord::Base
  belongs_to :valuable, :polymorphic => true
end
