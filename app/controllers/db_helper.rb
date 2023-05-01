class DbHelper < ApplicationController

def get_currencies
	return Currency.all.pluck(:code)
end

def check_rate(params)
    # Checks if there is a rate for date

    if params[:date] == ( "" or nil )
      params[:date] = Date.today
    end

    # Fetch from db
    rate_at_date = Rate.where(:date => params[:date], :base => params[:from], :to => params[:to])

    if rate_at_date.exists?
      puts("Rate in db!")
      return rate_at_date.pluck(:rate)[0]
    else
      puts("Rate not in db!")
      return false
  	end
  return rate_at_date.has_key("rate") ? rate_at_date["rate"] : false
end

def save_rates(params)
	# Saves rate to db
	# params { :date, :base :rates }

	rates = params[:rates]
	
	rates.each do |key, value|
		rate = Rate.new(:date => params[:date], :base => params[:from], :to => key, :rate=> value)
		if rate.save
			puts("saved to db: ")
			p rate
		else
			puts("not saved to db!")
			p rate
		end
	end
end

def get_series(params)
	
	# Get series for
	# params = { from_date, to_date, base, to}
	puts ("get_series() : ")
	rates = Rate.all.where(:date => params[:start_date]..params[:to_date], :base => params[:from], :to => params[:to]).pluck(:date, :rate)
	rates_res = Hash.new
	p rates_res

	for rate in rates
		rates_res.store(rate[0],rate[1])
	end

	return rates_res
end

end