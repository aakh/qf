# == Schema Information
# Schema version: 20100614023756
#
# Table name: dimensions
#
#  id            :integer         not null, primary key
#  name          :string(255)
#  desc          :string(255)
#  ideal         :float           default(0.0)
#  weight        :float           default(0.0)
#  valuable_id   :integer
#  valuable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#

class Dimension < ActiveRecord::Base
  belongs_to :valuable, :polymorphic => true
  has_and_belongs_to_many :concepts
  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :valuable_type, :case_sensitive => false
   
  before_validation :analyze_attributes
  after_save :create_opinion_if_fact
  
  def analyze_attributes
    @attributes['name'].capitalize!
    @attributes['name'].strip!
    
    #If name has a question mark at the end (spaces should not be there after strip!)
    if @attributes['name'] =~ /\?\Z/
      @attributes['bool'] = true
    end
  end
  
  def <=>(dim) # Comparison operator for sorting
    name <=> dim.name
  end
  
  def self.fact_dimensions
    Dimension.all :conditions => "valuable_type = 'Fact'", :order => "name"
  end
  
  def self.opinion_dimensions
    Dimension.all :conditions => "valuable_type = 'Opinion'", :order => "name"
  end
  
  def type_s
    return "boolean" if bool?
    "ordinal"
  end
  
  # Create an opinion that goes along with the fact.
  def create_opinion_if_fact
    if valuable_type == 'Fact'
      op = Opinion.find_by_name(name)
      
      unless op
        op = Opinion.new
        op.dimension = Dimension.new(:name => name)
      end
      
      # Give the opinions the same associations as the fact
      # with the migrations this table is not created when the default
      # facts are added in
      if connection.tables.include? "concepts_dimensions"
        op.dimension.concepts.clear
        
        concepts.each do |c|
          op.dimension.concepts << c
        end
      end
      
      op.save
    end
  end
  
end
