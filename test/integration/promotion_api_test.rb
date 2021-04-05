require "test_helper"

class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'show coupon' do
    user = User.create!(email: 'marcos@iugu.com.br', password: '123456')
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

  test 'create promotion' do
  	user = User.create!(email: 'marcos@iugu.com.br', password: '123456')
  	post "/api/v1/promotions", params: {promotion: {name: 'Natal', description: 'Promoção de Natal',
                                       code: 'NATAL10', discount_rate: 10,
                                  	   coupon_quantity: 100,
                                  	   expiration_date: '22/12/2033', user_id: user.id}}

    assert_response :success
    assert_equal 'Natal', response.parsed_body['name']
    assert_equal 'NATAL10', response.parsed_body['code']
    assert_equal user.email, response.parsed_body['user']['email']
  end
end