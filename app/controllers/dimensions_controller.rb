class DimensionsController < ApplicationController
  before_filter :check_staff, :only => :delete
  before_filter :check_logged_in
  before_filter :check_administrator, :only => :enable
  
  def index
    @fact_dimensions = Dimension.fact_dimensions
    @opinion_dimensions = Dimension.opinion_dimensions
  end
  
  def enable
    @dimension = Dimension.find(params[:id])
    @dimension.enabled = !@dimension.enabled?
    @dimension.save!
    
    if @dimension.valuable_type == 'Fact'
      vt = 'Opinion'
    else
      vt = 'Fact'
    end
    
    # Disable/Enable the corresponding fact/opinion if there is one
    @other = Dimension.find_by_name_and_valuable_type @dimension.name, vt
    if @other
      @other.enabled = @dimension.enabled
      @other.save!
    end
    
    flash[:notice] = (@dimension.enabled? ? "Enabled" : "Disabled") + " " + @dimension.name
    redirect_to :back
  end
  
  def show
    @dimension = Dimension.find(params[:id])
    @opinion = @dimension.valuable
    
    @num_who_care = @opinion.num_ideals
    
    if @opinion.num_weights > 0
      @weight = @opinion.total_weight / @opinion.num_weights
    else
      @weight = nil
    end
    
    if @num_who_care > 0
      @ideal = @opinion.total_ideal / @opinion.num_ideals
    else
      @ideal = nil
    end
    
    @countries = Hash.new
    
    beliefs = Belief.find :all, :conditions => "opinion_id=#{@opinion.id.to_s}"
    
    beliefs.each do |b|
      unless b.user.country.blank?
        unless @countries[b.user.country]
          @countries[b.user.country] = Hash.new
        end
        @countries[b.user.country][:num_ideals] = 0 unless @countries[b.user.country][:num_ideals]
        @countries[b.user.country][:num_ideals] += 1
        @countries[b.user.country][:total_ideal] = 0 unless @countries[b.user.country][:total_ideal]
        @countries[b.user.country][:total_ideal] += b.ideal
        if b.weight
          @countries[b.user.country][:num_weights] = 0 unless @countries[b.user.country][:num_weights]
          @countries[b.user.country][:num_weights] += 1
          @countries[b.user.country][:total_weight] = 0 unless @countries[b.user.country][:total_weight]
          @countries[b.user.country][:total_weight] += b.weight
        end
      end
    end
    
    @countries.each do |key, val|
      if val[:num_ideals]
        val[:ideal] = val[:total_ideal] / val[:num_ideals]
      else
        val[:ideal] = 0
      end
      if val[:num_weights]
        val[:weight] = val[:total_weight] / val[:num_weights]
      else
        val[:weight] = 0
      end
    end
    
    params[:countries] = @countries
    #ss.ss
    
  end
  
  def edit
    @dimension = Dimension.find(params[:id])
    
    
    session[:last_dimension_path] = request.env["HTTP_REFERER"] || dimensions_url
    if @dimension.valuable_type == "Opinion"
      # If there's a fact with the same name, do not allow this opinion to be edited
      if Fact.find_by_name @dimension.name
        flash[:error] = "Not allowed to edit that dimension"
        redirect_to :back
      else
        @opinion = @dimension.valuable
        @opinion.dimension.edited_by = current_user.id
        render 'opinions/edit'
      end
    else
      @fact = @dimension.valuable
      @fact.dimension.edited_by = current_user.id
      render 'facts/edit'
    end
  end
    
  def destroy
    @dimension = Dimension.find(params[:id])
    @dimension.destroy

    redirect_to :back
  end
end
