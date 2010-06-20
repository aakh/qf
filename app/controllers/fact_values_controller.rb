class FactValuesController < ApplicationController
  before_filter :check_staff
  
  def edit
    @fact_value = FactValue.find(params[:id])
  end
  
  def update
  end
end
