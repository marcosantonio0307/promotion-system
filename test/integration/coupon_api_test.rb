require 'test_helper'

class CouponApiTest < ActionDispatch::IntegrationTest
	test 'show coupon disabled' do
    coupon = Fabricate(:coupon, status: :disabled)
    get "/api/v1/coupons/#{coupon.code}"

    assert_response :not_found
  end

	test 'Disable a coupon' do
		coupon = Fabricate(:coupon)

		post "/api/v1/coupons/#{coupon.code}/disable"

		assert_response :success
		assert_equal "Cupom #{coupon.code} desabilitado com sucesso", response.parsed_body['notice']
	end
end