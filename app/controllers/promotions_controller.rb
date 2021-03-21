class PromotionsController < ApplicationController
  before_action :set_promotion, only:[:generate_coupons, :show, :edit, :update]
  before_action :promotion_params, only:[:create, :update]
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

  	flash[:notice] = 'Cupons gerados com sucesso'
  	redirect_to @promotion
  end

  def edit
  	if @promotion.coupons.any?
  	  flash[:notice] = 'Não é possivel editar promoção com cupons gerados'
  	  redirect_to @promotion
  	end
  end

  def update
  	if @promotion.update promotion_params
  	  flash[:notice] = 'Promoção editada com sucesso'
  	  redirect_to @promotion
  	else
      render :edit
  	end
  end

  def show
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