class FactValuesController < ApplicationController
  before_filter :check_logged_in
  before_filter :check_staff_role
  
  def edit
    @fact_value = FactValue.find(params[:id])
  end
  
  def update
  end
end
