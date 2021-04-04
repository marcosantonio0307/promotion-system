require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase
  test 'user sign up' do
  	visit root_path
  	click_on 'Cadastrar usuário'
  	fill_in 'Email', with: 'marcos@iugu.com.br'
  	fill_in 'Senha', with: '123456'
  	fill_in 'Confirme a senha', with: '123456'
  	click_on 'Registrar'

  	assert_text 'Bem vindo!'
  	assert_text 'marcos@iugu.com.br'
  	assert_link 'Sair'
  	assert_no_link 'Cadastrar usuário'
  	assert_current_path root_path
  	#validar qualidade da senha
  	#captcha
  	#TODO: testar erros de cadastro
  	#TODO: testar erros de entrar
  	#TODO: recuperar senha
  	#TODO: user i18n
  	#TODO: editar usuario
  	#TODO: incluir name no user
  end

  test 'user sign in' do
  	user = User.create!(email: 'marcos@iugu.com.br', password: '123456')

  	visit root_path
  	click_on 'Entrar'
  	fill_in 'Email', with: user.email
  	fill_in 'Senha', with: user.password
  	click_on 'Log in'

  	assert_text 'Login efetuado com sucesso!'
  	assert_current_path root_path
  	assert_text user.email
  	assert_link 'Sair'
  	assert_no_link 'Entrar'	
  end

  test 'user sign out' do
    login_user

    visit promotions_path
    click_on 'Sair'

    assert_current_path root_path
    assert_link 'Entrar'
  end

  test 'do not view promotion link without login' do
 	visit root_path

 	refute_link 'Promoções'
  end

  test 'do not view promotions using route without login' do
  	visit promotions_path

  	assert_current_path new_user_session_path
  end

  test 'do not view product category using route without login' do
  	visit product_categories_path

  	assert_current_path new_user_session_path
  end
end