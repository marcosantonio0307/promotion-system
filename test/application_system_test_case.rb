require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Warden::Test::Helpers
  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  Capybara.server = :puma, { Silent: true }

  def take_failed_screenshot
  	false
  end

  def login_user
  	@user = User.create!(email: 'marcos@iugu.com.br', password: '123456')

  	login_as @user, scope: :user
  end
end
