RSpec::Matchers.define :require_admin_login do |expected|
	match do |actual|
		expect(actual).to redirect_to Rails.application.routes.url_helpers.new_admin_session_path
	end

	failure_message_for_should do |actual|
		"expected to require admin login to access the method"
	end

	failure_message_for_should_not do |actual|
		"expected not to require admin login to access the method"
	end

	description do
		"redirect to the admin login form"
	end
end