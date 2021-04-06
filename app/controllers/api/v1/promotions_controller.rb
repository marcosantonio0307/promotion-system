class Api::V1::PromotionsController < Api::V1::ApiController
  def create
    @promotion = Promotion.new(promotion_params)
    if @promotion.save
  	  render status: :created, json: @promotion.as_json(except: :user_id, include: :user)
  	else
  	  render status: :unprocessable_entity, json: @promotion.errors
  	end
  end

  def update
  	@promotion = Promotion.find(params[:id])
  	if @promotion.update promotion_params
  	  render json: @promotion
  	end
  end

  private
    def promotion_params
      params.require(:promotion).permit(:name, :description, :code, 
      									:discount_rate, :coupon_quantity,
      									:expiration_date, :user_id)
    end
end