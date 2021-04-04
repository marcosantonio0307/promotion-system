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

  test 'can not create a promotion without login' do
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

  	assert_redirected_to new_user_session_path
  end

  test 'can not approve a promotion without login' do
    user = User.create!(email: 'marcos@iugu.com', password: '123456')
    christmas = Promotion.create(name: 'Natal', description: 'Promoção de Natal',
                                 code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                 expiration_date: '22/12/2033', user: user)
    post approve_promotion_path(christmas)

    assert_redirected_to new_user_session_path
  end

  test 'user can not approve your promotions' do
    user = login_user
    christmas = Promotion.create(name: 'Natal', description: 'Promoção de Natal',
                                 code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                 expiration_date: '22/12/2033', user: user)
    post approve_promotion_path(christmas)
    assert_redirected_to promotion_path(christmas)
    refute christmas.reload.approved?
    assert_equal 'Não é possível aprovar as próprias promoções', flash[:notice]
  end
end