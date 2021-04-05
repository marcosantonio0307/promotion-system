class Api::V1::PromotionsController < Api::V1::ApiController
  def create
    @promotion = Promotion.create!(promotion_params)
    if @promotion.save
  	  render json: @promotion.as_json(except: :user_id, include: :user)
  	end
  end

  private
    def promotion_params
      params.require(:promotion).permit(:name, :description, :code, 
      									:discount_rate, :coupon_quantity,
      									:expiration_date, :user_id)
    end
end