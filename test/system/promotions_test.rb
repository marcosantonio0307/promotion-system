require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'view promotions' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')

    login_user
    visit root_path
    click_on 'Promoções'

    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'view promotion details' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 90,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033')

    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'no promotion are available' do
    login_user
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    assert_current_path promotions_path
  end

  test 'create promotion' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Criar promoção'

    assert_current_path promotion_path(Promotion.last)
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    click_on 'Criar promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'create and code must be unique' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    login_user
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Natal'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'NATAL10'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '22/12/2033'
    click_on 'Criar promoção'

    assert_text 'já está em uso', count: 2
  end

  test 'generate coupon for promotion' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    login_user
    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    assert_text 'Cupons gerados com sucesso'
    assert_no_link 'Gerar cupons'
    assert_no_text 'NATAL10-0000'
    assert_text 'NATAL10-0001 (ativo)'
    assert_text 'NATAL10-0002 (ativo)'
    assert_text 'NATAL10-0100 (ativo)'
    assert_no_text 'NATAL10-0101'
    assert_link 'Desabilitar', count: promotion.coupon_quantity
  end

  test 'edit promotion with correct attributes' do
    Promotion.create!(name: 'Cyber Monday',
                      description: 'Promoção de Natal',
                      code: 'CYBER15', discount_rate: 10,
                      coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    login_user
    visit promotion_path(promotion)
    assert_link 'Gerar cupons'
    click_on 'Editar promoção'
    fill_in 'Descrição', with: 'Promoção Natalina'
    fill_in 'Quantidade de cupons', with: 80
    click_on 'Salvar'

    assert_text 'Promoção editada com sucesso'
    assert_text 'Promoção Natalina'
    assert_text '80'
  end

  test 'edit promotion and code must be unique' do
    Promotion.create!(name: 'Cyber Monday',
                      description: 'Promoção de Natal',
                      code: 'CYBER15', discount_rate: 10,
                      coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    login_user
    visit promotion_path(promotion)
    assert_link 'Gerar cupons'
    click_on 'Editar promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    click_on 'Salvar'

    assert_text 'já está em uso', count: 2
  end

  test 'edit promotion and attributes cannot blank' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    login_user
    visit promotion_path(promotion)
    assert_link 'Gerar cupons'
    click_on 'Editar promoção'
    fill_in 'Nome', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Salvar'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'edit promotion after generate coupons' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    login_user
    visit promotion_path(promotion)
    click_on 'Gerar cupons'
    click_on 'Editar promoção'

    assert_text 'Não é possivel editar promoção com cupons gerados'
  end

  test 'delete promotion' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    login_user
    visit promotion_path(promotion)
    click_on 'Apagar promoção'
    
    assert_current_path promotions_path
    assert_text 'Promoção apagada com sucesso'
    assert_no_link 'Natal'
  end

  test 'do not view promotion without login' do
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    visit promotion_path(promotion)

    assert_current_path new_user_session_path
  end

  test 'can not create promotion without login' do
    visit new_promotion_path

    assert_current_path new_user_session_path
  end

  test 'search promotions by term and finds results' do
    christmas = Promotion.create(name: 'Natal', description: 'Promoção de Natal',
                                 code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                 expiration_date: '22/12/2033')
    christmassy = Promotion.create(name: 'Natalina', description: 'Promoção de Natal',
                                 code: 'NATAL20', discount_rate: 10, coupon_quantity: 100,
                                 expiration_date: '22/12/2033')
    cyber_monday = Promotion.create(name: 'Cyber Monday', description: 'Promoção Cyber Monday',
                                 code: 'CYBER15', discount_rate: 10, coupon_quantity: 100,
                                 expiration_date: '22/12/2033')

    login_user
    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'natal'
    click_on 'Buscar'

    assert_text 'Resultados encontrados para a busca'
    assert_link 'Voltar'
    assert_text christmas.name
    assert_text christmassy.name
    assert_no_text cyber_monday.name
  end

  test 'not results' do
    christmas = Promotion.create(name: 'Natal', description: 'Promoção de Natal',
                                 code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                 expiration_date: '22/12/2033')

    login_user
    visit root_path
    click_on 'Promoções'
    fill_in 'Busca', with: 'Cyber'
    click_on 'Buscar'

    assert_text 'Nenhuma promoção encontrada'
    assert_no_text christmas.name
  end

  test 'can not search without login' do
    visit search_promotions_path

    assert_current_path new_user_session_path
  end
end