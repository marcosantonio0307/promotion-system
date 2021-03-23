require 'application_system_test_case'

class ProductCategoriesTest < ApplicationSystemTestCase
  test 'view product categories' do
    ProductCategory.create!(name: 'Antivirus', code: 'ANTIV')
    ProductCategory.create!(name: 'Software de Gestão', code: 'SWGESTAO')

    visit root_path
    click_on 'Categorias de Produtos'

    assert_link 'Antivirus'
    assert_link 'Software de Gestão'
  end

  test 'view details' do
  	ProductCategory.create!(name: 'Antivirus', code: 'ANTIV')
    ProductCategory.create!(name: 'Software de Gestão', code: 'SWGESTAO')

    visit product_categories_path
    click_on 'Antivirus'

    assert_text 'Antivirus'
    assert_text 'ANTIV'
  end

  test 'no product categories avaliable' do
  	visit product_categories_path

  	assert_text 'Nenhuma categoria de produto cadastrada'
  end

  test 'view product categories and return to home page' do
  	visit product_categories_path
  	click_on 'Voltar'

  	assert_current_path root_path
  end

  test 'view datails and return to product categories page' do
  	ProductCategory.create!(name: 'Antivirus', code: 'ANTIV')

  	visit product_categories_path
  	click_on 'Antivirus'
  	click_on 'Voltar'

  	assert_current_path product_categories_path
  end

  test 'create product category' do
  	visit product_categories_path
  	click_on 'Registrar categoria de produto'
  	fill_in 'Nome', with: 'Antivirus'
  	fill_in 'Código', with: 'ANTIV'
  	click_on 'Salvar'

  	assert_current_path product_category_path(ProductCategory.last)
  	assert_text 'Categoria criada com sucesso'
  	assert_text 'Antivirus'
  	assert_text 'ANTIV'
  end

  test 'create product category and attributes cannot be blank' do
  	visit new_product_category_path
  	fill_in 'Nome', with: ''
  	fill_in 'Código', with: ''
  	click_on 'Salvar'

  	assert_text 'não pode ficar em branco', count: 2
  end

  test 'create product category and code must be unique' do
  	ProductCategory.create!(name: 'Antivirus', code: 'ANTIV')

  	visit new_product_category_path
  	fill_in 'Nome', with: 'Antivirus'
  	fill_in 'Código', with: 'ANTIV'
  	click_on 'Salvar'

  	assert_text 'já está em uso'
  end

  test 'edit product category and correct attributes' do
  	product_category = ProductCategory.create!(name: 'Antivirus', code: 'ANTIV')

  	visit product_category_path(product_category)
  	click_on 'Editar'
  	fill_in 'Nome', with: 'Antivirus especiais'
  	fill_in 'Código', with: 'ANTIVESP'
  	click_on 'Salvar'

  	assert_text 'Categoria editada com sucesso'
  	assert_text 'Antivirus especiais'
  	assert_text 'ANTIVESP'
  end

  test 'edit and attributes cannot be blank' do
  	product_category = ProductCategory.create!(name: 'Antivirus', code: 'ANTIV')

  	visit edit_product_category_path(product_category)
  	fill_in 'Nome', with: ''
  	fill_in 'Código', with: ''
  	click_on 'Salvar'

  	assert_text 'não pode ficar em branco', count: 2
  end

  test 'edit and code must be unique' do
  	ProductCategory.create!(name: 'Antivirus', code: 'ANTIV')
  	product_category = ProductCategory.create!(name: 'Antivirus especiais', code: 'ANTIVESP')

  	visit edit_product_category_path(product_category)
  	fill_in 'Código', with: 'ANTIV'
  	click_on 'Salvar'

  	assert_text 'já está em uso'
  end

  test 'delete product category' do
    ProductCategory.create!(name: 'Software de Gestão', code: 'SWGESTAO')
  	product_category = ProductCategory.create!(name: 'Antivirus', code: 'ANTIV')
    
  	visit product_category_path(product_category)
  	click_on 'Apagar categoria'

  	assert_current_path product_categories_path
  	assert_text 'Categoria apagada com sucesso'
  	assert_link 'Software de Gestão'
  	assert_no_link 'Antivirus'
  end
end