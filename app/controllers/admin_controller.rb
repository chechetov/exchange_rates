class AdminController < ApplicationController
 before_action :authenticate_user!	
	require 'json'

	def queries
  	QueryController.new
	end
	
	def index
	end

	def view_config
		@config = Config.last
		render 'admin/config/view'
	end

	def update_config
		@config = Config.last
		render 'admin/config/update'
	end

	def save_config
		update_params = params.require(:params).permit(:url,:apikey)
		config = Config.new(:url=>update_params["url"],:apikey=>update_params["apikey"])
		config.save
		@config = config
		render 'admin/config/view'
	end

def list_currencies
  @currencies = Currency.all
  render 'admin/currencies/table'
end

def get_currencies
  response = JSON.parse(queries.get_all_currencies)
  @response = response
  @currencies = response["symbols"]
  @@currencies = @currencies
  render 'admin/currencies/table'
end

def save_currencies
  @response = Array.new
  @@currencies.each do |key, value|
    if Currency.exists?(:code => key, :desc => value)
      @response.push(key + " already exists ")
    else
      currency = Currency.new(:code => key, :desc => value)
      currency.save
      @response.push(key + "saved")
    end
  end
  render 'admin/currencies/saved'
end

def delete_currencies
  Currency.delete_all
  @currencies = Currency.all
  render 'admin/currencies/table'
end

end
