class PromotionsController < ApplicationController
  def index
  	@promotions = Promotion.all
  end

  def new
  	@promotion = Promotion.new
  end

  def create
  	promotion_params
  	@promotion = Promotion.new promotion_params
  	@promotion.save!
  end

  def show
  	@promotion = Promotion.find(params[:id])
  end

  private
    def promotion_params
      params.require(:promotion).permit(:name, :description, :code, 
      									:discount_rate, :coupon_quantity,
      									:expiration_date)
    end
end