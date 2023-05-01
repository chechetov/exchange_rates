class RatesController < ApplicationController

require 'json'

def queries
  QueryController.new
end

def convert
  @currencies = Currency.all
  @currencies_code = Currency.pluck(:code)
  render "rates/convert"
end

def series
  @currencies = Currency.all
  #@currencies = Currency.pluck(:code)
  render "rates/series"
end

def convert_amount
  form_params = params.require(:params).permit(:from, :to, :amount, :date)
  p form_params

  if queries.validator( {:params => form_params, :method => "convert_amount"} )
    @response = JSON.parse(queries.convert_amount(form_params))
  else
    @response = { "success" => false }
  end
  
  p @response
  render 'rates/convert_result'
end

def get_series
  
  form_params = params.require(:params).permit(:start_date, :to_date, :from, :to)
  p form_params

  if queries.validator({:params => form_params, :method => "get_series"})
    @response = queries.series(form_params)
  else
    @response = { "success" => false }
  end
  
  p @response
  render 'rates/series_result'
end

end
