class TooManyChecks < StandardError
	def initialize(message)
		@message = message
	end
end