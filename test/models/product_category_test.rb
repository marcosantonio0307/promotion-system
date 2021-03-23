require "test_helper"

class ProductCategoryTest < ActiveSupport::TestCase
  test 'create and attributes cannot be blank' do
    product_category = ProductCategory.new

    refute product_category.valid?
    assert_includes product_category.errors[:name], 'não pode ficar em branco'
    assert_includes product_category.errors[:code], 'não pode ficar em branco'
  end

  test 'create and code must be uniq' do
    ProductCategory.create!(name: 'Antivirus', code: 'ANTIV')
    product_category = ProductCategory.new(code: 'ANTIV')

    refute product_category.valid?
    assert_includes product_category.errors[:code], 'já está em uso'
  end
end
