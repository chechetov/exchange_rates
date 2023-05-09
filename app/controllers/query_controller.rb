class QueryController < ApplicationController
  # API calls to fixer

  require "uri"
  require "net/http"
  require "json"
  require 'date'

  def initialize()
    @url = Config.last.url
    @apikey = Config.last.apikey
    @db = DbHelper.new()
  end

  def validator(params)
    # Validates differrent conditions for request params
    Rails.logger.debug "Validator Params: #{params}"
    if params[:method] == "convert_amount"
      params = params[:params]
      if params[:date] == "" or params[:date] == nil
        # Latest date fixup
        # by timezone of server
        date = Date.today
      else
        date = Date.parse(params[:date])
      end

      Rails.logger.debug "Validator date : #{date}"

      # Conditions
      currency_from = Currency.where(:code => params[:from]).exists?
      currency_to = Currency.where(:code => params[:to]).exists?
      amount_positive = params[:amount].to_f > 0 ? true : false
      date_not_future = Date.today - date >= 0 ? true : false

      if currency_from && currency_to && amount_positive && date_not_future
        Rails.logger.debug "True"
        return true
      else
        Rails.logger.debug "False"
        return false
      end

    elsif params[:method] == "get_series"
      params = params[:params]

      if params[:start_date] == "" || params[:to_date] == ""
        return false
      end

      currency_from = Currency.where(:code => params[:from]).exists?
      currency_to = Currency.where(:code => params[:to]).exists?
      start_date = Date.parse(params[:start_date])
      to_date = Date.parse(params[:to_date])
      diff = to_date - start_date

      days_limit = diff.to_i < 365 ? true : false
      interval_positive = diff.to_i > 0 ? true : false
      start_date_not_future = Date.today - start_date >= 0 ? true : false
      to_date_not_future = Date.today - to_date >= 0 ? true : false

      if currency_from && currency_to && days_limit && interval_positive && start_date_not_future && to_date_not_future
        return true
      else
        return false
      end
      # If no method
    else
      return false
    end
  end

  def generic_request(*args)
    # Generic http request
    tail, params = *args
    url = URI(@url + tail)
    https = Net::HTTP.new(url.host, url.port);
    https.use_ssl = true
    puts("Url: " + url.to_s)
    begin
      request = Net::HTTP::Get.new(url)
      request['apikey'] = @apikey
      Rails.logger.debug "Request OUT: #{request}"
      response = https.request(request)
      ret = response.read_body
    rescue StandardError => e
      Rails.logger.debug "Request exception: #{e.backtrace}"
      ret = { "success": false }.to_json
    end
    p ret
    return ret
  end

  def convert_amount_external(params)
    # Converts amount using Fixer API calculation
    # Not used
    tail = "/convert?to=#{params[:to]}&from=#{params[:from]}&amount=#{params[:amount]}"
    return generic_request(tail, params)
  end

  def get_latest_daily
    # For cron
    # Updates latest rates for list of currencies
    puts("get_latest_daily")
    currencies = @db.get_currencies
    for currency in currencies do
        rate = get_rate_at_date(params = { :date => "", :from => currency })
      end
    end

    def get_rate_at_date(params)
      # Checks if there is a rate in db
      # If not
      # Makes calls to Fixer Api to get rate at a date or latest
      # Saves retrieved rates

      rate_in_db = @db.check_rate(params)

      if rate_in_db
        rate = { params[:to] => rate_in_db }
        return { :success => true, :rates => rate }
      else
        if params[:date] == Date.today
          puts("latest!")
          tail = "/latest?base=#{params[:from]}"
          resp = generic_request(tail)
        else
          puts("Getting rate for " + params[:date])
          date = Date.parse(params[:date]).strftime("%Y-%m-%d")
          tail = "/#{date}?base=#{params[:from]}"
          resp = generic_request(tail)
        end
        resp = JSON.parse(resp)
        Rails.logger.debug "get_rate_at_date() -> resp: #{resp}"
        if resp["success"] == true
          rates = resp["rates"]
          @db.save_rates(param = {:date=>params[:date], :from=>params[:from], :rates => rates })
          return { :success => true, :rates => rates }
        else
          ret = {}
          if resp["message"]
            ret = { :success => false, :rates => {}, :message => resp["message"] }
          else
            ret = { :success => false, :rates => {}, :message => "none" }
          end
          return ret
        end
      end
    end

    def convert_amount(params)
      # Converts amount using params

      resp = get_rate_at_date(params)

      Rails.logger.debug "convert_amount() resp: #{resp}"

      if resp[:success] == true
        rates = resp[:rates]
        to   = params[:to]
        rate = rates["#{to}"]

        response = {
          "success" => true,
          "from" => params[:from],
          "to"   => params[:to],
          "date" => params[:date],
          "rate" => rate,
          "amount" => params[:amount].to_f,
          "result" => params[:amount].to_f * rate
        }.to_json
      else
        response = { "success" => false, "message" => resp[:message] }.to_json
      end
      Rails.logger.debug "convert_amount() -> last_resp: #{response}"

      return response
    end

    def series(params)
      # get series from db
      # if does not exist - request
      # and save

      # query from db
      days = Date.parse(params[:to_date]).mjd - Date.parse(params[:start_date]).mjd + 1
      series = @db.get_series(params)

      # Full data in db
      if series.length == days
        puts("full data in db")
        puts(series.length.to_s + " values for " + days.to_s + " days")

        response = {
          "success" => true,
          "from" => params[:from],
          "to" => params[:to],
          "start_date" => params[:start_date],
          "to_date" => params[:to_date],
          "series" => series
        }
        return response
      else
        # No data in db
        puts("no full data in db")
        puts(series.length.to_s + " values for " + days.to_s + " days")

        start_date = Date.parse(params[:start_date]).strftime("%Y-%m-%d")
        to_date = Date.parse(params[:to_date]).strftime("%Y-%m-%d")

        # do api request

        tail="/timeseries?start_date=#{start_date}&end_date=#{to_date}&base=#{params[:from]}"

        resp = generic_request(tail, params)
        resp = JSON.parse(resp)

        if resp["success"]
          puts("Success")
          rates = resp["rates"]
          rates.each do | date, rates|
            param = {:date => date, :from => params[:from], :rates => rates}
            puts ("Saving rates for: " + param[:date].to_s + " " + param[:from].to_s)
            @db.save_rates(param)
          end
          resp = series(params)
        else
          puts("False")
          resp = { "success" => false }.to_json
        end
        return resp
      end
    end

    def get_all_currencies
      tail = "/symbols"
      return generic_request(tail)
    end

  end
