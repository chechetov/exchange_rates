class Task

	def initialize
		puts("INIT")
	end

	def get_latest
		puts("task:get_latest")
		query = QueryController.new
		query.get_latest_daily
	end

end