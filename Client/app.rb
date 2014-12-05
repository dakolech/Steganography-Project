class App
	attr_accessor :test_proc
	
	def run
		Thread.new do
			puts "App.run was executed"
			@test_proc.call
		end
	end
end