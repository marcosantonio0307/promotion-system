class Api::V1::CouponsController < Api::V1::ApiController 
  def show
  	@coupon = Coupon.active.find_by!(code: params[:code])
  	return render json: @coupon if @coupon
  end

  def disable
  	@coupon = Coupon.find_by!(code: params[:code])
  	@coupon.disabled!
  	render status: 200, json: {notice: "Cupom #{@coupon.code} desabilitado com sucesso"}
  end
end
