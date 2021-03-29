require "test_helper"

class PromotionFlowTest < ActionDispatch::IntegrationTest
  test 'can create a promotion' do
  	login_user
  	post '/promotions', params: {
  	  promotion: {
  	  	name: 'Natal',
  	  	description: 'Promoção de Natal',
  	  	code: 'NATAL10',
  	  	discount_rate: 15,
  	  	coupon_quantity: 5,
  	  	expiration_date: '22/12/2033'
  	  }
  	}
  	assert_redirected_to promotion_path(Promotion.last)
  	follow_redirect!  
  	assert_select 'p', 'Natal'
  end
end