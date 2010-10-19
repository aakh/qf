# == Schema Information
# Schema version: 20100705154452
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  email              :string(255)
#  crypted_password   :string(255)
#  password_salt      :string(255)
#  persistence_token  :string(255)
#  login_count        :integer         default(0), not null
#  failed_login_count :integer         default(0), not null
#  last_request_at    :datetime
#  current_login_at   :datetime
#  last_login_at      :datetime
#  current_login_ip   :string(255)
#  last_login_ip      :string(255)
#  first_name         :string(255)
#  last_name          :string(255)
#  country            :string(255)
#  birthday           :date
#  created_at         :datetime
#  updated_at         :datetime
#

class User < ActiveRecord::Base
  acts_as_authentic
  has_and_belongs_to_many :roles
  validates_presence_of :password, :password_confirmation, :on => :create
  validates_presence_of :email
  #attr_accessor :first_name, :last_name
  
  def has_role?(rolename)
    self.roles.find_by_name(rolename) ? true : false
  end
  
  def full_name
    #return "Full name here"
    [first_name, last_name].join(" ")
  end
  
  # Alternatively we may want to set dependent to nullify if we are
  # going to allow anonymous voting in the future
  has_many :ratings, :dependent => :destroy
  has_many :entities, :through => :ratings
  has_many :opinions, :through => :ratings
  
  has_many :beliefs, :dependent => :destroy
  has_many :opinions, :through => :beliefs
  
  before_destroy :fix_global_ideals
  
  def fix_global_ideals
    beliefs = Belief.find_by_user_id id
    beliefs.each do |b|
      #TODO delete global ideal information if the user is deleted
    end
  end
  
  def get_ideal_and_weight_for(opinion)
    belief = Belief.find_by_opinion_id_and_user_id opinion, self
    unless belief and belief.ideal
      return nil, nil
    end
    ideal = belief.ideal
    
    # If weight not given, set to full... why am I doing this?
    weight = (belief.weight and belief.weight > 0) ? belief.weight : 5
    
    if opinion.dimension.bool?
      # Transform boolean 0|1 values into either 1|5
      ideal = ideal * 4 + 1
    end
    
    return ideal, weight
  end
  
  def cos_similarity(other)
    similarity(other, true)
  end
  
  def calude_similarity(other)
    similarity(other, false, true)
  end
  
  def similarity(other, use_cos = false, use_calude = false)
    return 1 if self.id == other.id
    
    beliefs = Belief.find :all, :conditions => "user_id = #{self.id}"
    num = 0
    
    unless use_cos
      sims = 0
    else
      sum_mine_his = 0
      sum_his_sq = 0
      sum_mine_sq = 0
    end
    
    beliefs.each do |mine|
      next unless mine.opinion.dimension.enabled?
      
      his = Belief.find_by_user_id_and_opinion_id other, mine.opinion_id

      #If this user doesn't have a belief set then go to next one
      next unless his
      
      unless use_cos
        sims += mine.similarity_to his, use_calude
        # this is the +2 part
        num += 1 if use_calude
      else
        if mine.opinion.dimension.bool?
          mine_i = mine.ideal * 4 + 1
          his_i = his.ideal * 4 + 1
        else
          mine_i = mine.ideal
          his_i = his.ideal
        end
        
        # Set weight to I don't care if not available
        mine_w = (mine.weight ? mine.weight : 1)
        his_w = (his.weight ? his.weight : 1)
        
        
        sum_mine_his += mine_i * his_i + mine_w * his_w
        sum_mine_sq += mine_i * mine_i + mine_w * mine_w
        sum_his_sq += his_i * his_i + his_w * his_w
        
      end
      
      num += 1
    end

    if use_cos
      return (sum_mine_his / (Math.sqrt(sum_mine_sq) * Math.sqrt(sum_his_sq))) if num > 0
    elsif num > 0
      ret = sims / num
      return ret
    end
    
    return nil
  end
  
  # Returns rating out of 10
  def rating_for(entity, wf = 5)
    ratings = Rating.all :conditions => "entity_id=#{entity.id} and user_id=#{self.id}"
    return nil unless ratings and ratings.length > 0
    
    dist = 0
    num = 0
    ratings.each do |rating|
      weight = rating.opinion.weight
      next if weight < 1.1
      dist += Dimension.distance(rating.value, rating.opinion.ideal, weight / wf)
      num += 1
    end
    
    ((1 - dist / num) * 10.0)
  end
  
  def has_rated?(entity)
    ratings = Rating.all :conditions => "entity_id=#{entity.id} and user_id=#{self.id}"
    return false unless ratings and ratings.length > 0
    true
  end
  
  def get_rated_entities
    ratings = Rating.all :conditions => {:user_id => self.id}, :select => "DISTINCT(entity_id)", :include => :entity
    ratings.collect {|x| x.entity }
  end
  
  def get_avg_rating( wf = 5)
    num_ratings = 0
    total_rating = 0
    entities = get_rated_entities
    entities.each do |e|
      total_rating += self.rating_for e, wf
      num_ratings += 1
    end
    return total_rating / num_ratings if num_ratings > 0
    return nil
  end
end
