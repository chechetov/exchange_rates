class ApiController < ActionController::API

	include ActionController::MimeResponds

	def queries
		QueryController.new
	end

	def convert
		# Post
		params[:params] = request.POST
		convert_params = params.require(:params).permit(:from, :to, :amount, :date)
		response = queries.convert_amount(convert_params)

		 respond_to do |format|
      format.json { render json: response }
      format.xml  { render xml: response }
    end
	end

	def currencies
		# Get
		response = Currency.all
		resp_hash = {}

		for currency in response
			resp_hash[currency["code"]] = currency["desc"]
		end

		respond_to do |format|
			format.json { render json: resp_hash }
			format.xml  { render xml: resp_hash }
    end
	end

	def series
		# post
		response = queries.series(params)

		respond_to do |format|
			format.json { render json: response }
			format.xml  { render xml: response }
    end
	end
end