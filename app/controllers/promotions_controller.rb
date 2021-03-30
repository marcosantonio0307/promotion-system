class PromotionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_promotion, only:[:generate_coupons, :show, :edit, :update, :destroy]
  
  def index
  	@promotions = Promotion.all
  end

  def new
  	@promotion = Promotion.new
  end

  def create
  	@promotion = Promotion.new promotion_params
  	if @promotion.save
  	  redirect_to @promotion
  	else
  	  render :new
  	end
  end

  def generate_coupons
  	@promotion.generate_coupons
  	redirect_to @promotion, notice: 'Cupons gerados com sucesso'
  end

  def edit
  	if @promotion.coupons.any?
  	  redirect_to @promotion, notice: 'Não é possivel editar promoção com cupons gerados'
  	end
  end

  def update
  	if @promotion.update promotion_params
  	  redirect_to @promotion, notice: 'Promoção editada com sucesso'
  	else
      render :edit
  	end
  end

  def show
  end

  def search
    @promotions = Promotion.search(params[:search])
    if @promotions.any?
      flash[:notice] = 'Resultados encontrados para a busca'
    else
      flash[:notice] = 'Nenhuma promoção encontrada'
    end
    render :index
  end

  def destroy
  	@promotion.destroy!
  	redirect_to promotions_path, notice: 'Promoção apagada com sucesso'
  end

  private
    def promotion_params
      params.require(:promotion).permit(:name, :description, :code, 
      									:discount_rate, :coupon_quantity,
      									:expiration_date)
    end

    def set_promotion
      @promotion = Promotion.find(params[:id])
    end
end