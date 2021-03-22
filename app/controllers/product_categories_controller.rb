class ProductCategoriesController < ApplicationController
  before_action :set_product_category, only:[:show, :edit, :update, :destroy]

  def index
  	@product_categories = ProductCategory.all
  end

  def show
  end

  def new
  	@product_category = ProductCategory.new
  end

  def create
  	@product_category = ProductCategory.new product_category_params
  	if @product_category.save
  	  redirect_to @product_category, notice: 'Categoria criada com sucesso'
  	else
  	  render :new
  	end
  end

  def edit
  end

  def update
  	if @product_category.update product_category_params
  	  redirect_to @product_category, notice: 'Categoria editada com sucesso'
  	else
  	  render :edit
  	end
  end

  def destroy
  	@product_category.destroy!
  	redirect_to product_categories_path, notice: 'Categoria apagada com sucesso'
  end

  private
    def product_category_params
      params.require(:product_category).permit(:name, :code)
    end

    def set_product_category
      @product_category = ProductCategory.find(params[:id])
    end
end