require "test_helper"

class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'show coupon' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion)
    get "/api/v1/coupons/#{coupon.code}"

    assert_response :success
    assert_equal coupon.code, response.parsed_body['code']
  end

  test 'show error if there is no coupon' do
  	get "/api/v1/coupons/test"

  	assert_response :success
  	assert_equal 'Cupom não existe', response.parsed_body['error']
  end
end