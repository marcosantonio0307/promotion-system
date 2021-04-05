class Api::V1::CouponsController < Api::V1::ApiController
  def show
  	@coupon = Coupon.find_by(code: params[:code])
  	return render json: @coupon if @coupon
  	render json: {error: 'Cupom não existe'}
  end
end
