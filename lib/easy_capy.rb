require "easy_capy/version"
require "exceptions"
require "logbert"

LOG = Logbert[self]

module EasyCapy

	class EasyCapyBot

		attr_accessor :timeout, :session

		def initialize(session, timeout=0)
			@timeout = timeout
			@session = session
		end

		def timeout
			return timeout
		end

		def hover(xpath)
			select = nil
			while select == nil
				begin
					select = session.find(:xpath, xpath)
				rescue Capybara::ElementNotFound
					puts "Hover Element Not Found"
					next
				end
			end
			select.hover
		end

		def click_an_element(xpath)
			select = nil
			while select == nil
				begin
					select = session.find(:xpath, xpath)
				rescue Capybara::ElementNotFound
					LOG.error("Didn't find xpath: #{xpath}")
					next
				end
			end
			select.click
		end

		def get_element(xpath)
			count = 0
			select = nil
			while select == nil
				begin
					select = @session.find(:xpath, xpath)
				rescue Capybara::ElementNotFound
					LOG.error("Didn't find xpath: " + xpath)
					if count >= @timeout
						raise TooManyChecks.new("Too many checks for xpath: #{xpath}")
					else
						count += 1
						next
					end
				end
			end
			return select
		end

		def select(xpath, value)
			get_element(@session, xpath).find("option[value='#{value}']").click
		end

		def fill_in(selectname, fill)
			@session.fill_in selectname, with: fill
		end

		def element_exists(xpath)
			begin
				select = @session.find(:xpath, xpath)
				if select != nil
					return true
				else
					return false
				end
			rescue Capybara::ElementNotFound
				return false
			end
		end

		#USed to wait for page to be fully loaded before moving on
		def element_check(xpath)
			count = 0
			check = false
			while check == false
				begin
					select = @session.find(:xpath, xpath)
					if (select != nil)
						return true
						end
					end
				rescue Capybara::ElementNotFound => e
					if count >= @timeout
						raise TooManyChecks.new("too many checks for xpath: #{xpath}")
					else
						count += 1
						next
					end
				end
			end

			return check
		end
	end
end