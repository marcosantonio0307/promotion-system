require "test_helper"

class PromotionApiTest < ActionDispatch::IntegrationTest
  test 'show coupon' do
    coupon = Fabricate(:coupon, code: 'NATAL10-0001')
    get "/api/v1/coupons/#{coupon.code}"

    assert_response :success
    assert_equal coupon.promotion.discount_rate.to_s, response.parsed_body['discount_rate']
  end

  test 'show error if there is no coupon' do
  	get "/api/v1/coupons/test"

  	assert_response :not_found
  end

  test 'create promotion' do
  	user = User.create!(email: 'marcos@iugu.com.br', password: '123456')
  	post "/api/v1/promotions", params: {promotion: {name: 'Natal', description: 'Promoção de Natal',
                                       code: 'NATAL10', discount_rate: 10,
                                  	   coupon_quantity: 100,
                                  	   expiration_date: '22/12/2033', user_id: user.id}}

    assert_response :created
    assert_equal 'Natal', response.parsed_body['name']
    assert_equal 'NATAL10', response.parsed_body['code']
    assert_equal user.email, response.parsed_body['user']['email']
  end

  test 'create and attributes cannot be blank' do
    user = User.create!(email: 'marcos@iugu.com.br', password: '123456')
  	post "/api/v1/promotions", params: {promotion: {name: '', description: '',
                                       code: '', discount_rate: '',
                                  	   coupon_quantity: '',
                                  	   expiration_date: '', user_id: user.id}}

    assert_response :unprocessable_entity
    assert_includes response.parsed_body['name'], 'não pode ficar em branco'
    assert_includes response.parsed_body['code'], 'não pode ficar em branco'
    assert_includes response.parsed_body['discount_rate'], 'não pode ficar em branco'
  end

  test 'create and code must be unique' do
 	user = User.create!(email: 'marcos@iugu.com.br', password: '123456')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033',user: user)
    post "/api/v1/promotions", params: {promotion: {name: 'Natal', description: 'Promoção de Natal',
                                       code: 'NATAL10', discount_rate: 15,
                                  	   coupon_quantity: 40,
                                  	   expiration_date: '22/12/2021', user_id: user.id}}

    assert_response :unprocessable_entity
    assert_includes response.parsed_body['name'], 'já está em uso'
    assert_includes response.parsed_body['code'], 'já está em uso'
  end

  test 'edit promotion' do
  	user = User.create!(email: 'marcos@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                     			  expiration_date: '22/12/2033',user: user)
    patch "/api/v1/promotions/#{promotion.id}", params: {promotion: {code: 'NATAL20', coupon_quantity: 40, discount_rate: 20}}

    assert_response :success
    assert_equal 'NATAL20', response.parsed_body['code']
    assert_equal 40, response.parsed_body['coupon_quantity'].to_i
    assert_equal 20, response.parsed_body['discount_rate'].to_i
  end

  test 'show coupon disabled' do
    user = User.create!(email: 'marcos@iugu.com.br', password: '123456')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    coupon = Coupon.create!(code: 'NATAL10-0001', promotion: promotion, status: 'disabled')
    get "/api/v1/coupons/#{coupon.code}"

    assert_response :not_found
  end

  test 'delete promotion' do
    promotion = Fabricate(:promotion)

    delete "/api/v1/promotions/#{promotion.id}"
    
    assert_response :success
    assert_equal 'Promoção apagada com sucesso', response.parsed_body['notice']
  end

  #TODO: queimar cupom via API
  #get 200
  #created: 201
  #erro ao criar: 422
  #atualizado: 200
  #erro ao atualizar: 422

end