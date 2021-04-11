require 'rails_helper'

describe 'Promotions Test' do
	before do
		driven_by(:rack_test)
	end

	it 'view promotions' do
    user = User.create!(email: 'marcos@iugu.com.br', password: '123456')
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', coupon_quantity: 100,
                      description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15,
                      expiration_date: '22/12/2033', user: user)
    login_as user, scope: :user

    visit root_path
    click_on 'Promoções'

    expect(page).to have_text('Natal')
    expect(page).to have_text('Promoção de Natal')
    expect(page).to have_text('10,00%')
    expect(page).to have_text('Cyber Monday')
    expect(page).to have_text('Promoção de Cyber Monday')
    expect(page).to have_text('15,00%')
  end

  it 'edit promotion with correct attributes' do
    user = User.create!(email: 'marcos@iugu.com.br', password: '123456')
    Promotion.create!(name: 'Cyber Monday',
                      description: 'Promoção de Natal',
                      code: 'CYBER15', discount_rate: 10,
                      coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    promotion = Promotion.create!(name: 'Natal',
                                  description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10,
                                  coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    promotion.create_promotion_approval(
      user: User.create!(email: 'gerson@iugu.com.br', password: '123456')
    )
    login_as user, scope: :user

    visit promotion_path(promotion)
    click_on 'Editar promoção'
    fill_in 'Descrição', with: 'Promoção Natalina'
    fill_in 'Quantidade de cupons', with: 80
    click_on 'Salvar'

    expect(page).to have_link 'Gerar cupons'
    expect(page).to have_text('Promoção editada com sucesso')
    expect(page).to have_text('Promoção Natalina')
    expect(page).to have_text('80')
  end
end