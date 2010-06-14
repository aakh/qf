class FactValuesController < ApplicationController
  def edit
    @fact_value = FactValue.find(params[:id])
  end
  
  def update
  end
end
