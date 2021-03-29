class CouponsController < ApplicationController
  before_action :authenticate_user!
  def disable
  	@coupon = Coupon.find(params[:id])
  	@coupon.disabled!
  	redirect_to @coupon.promotion, notice: t('.success', coupon_code: @coupon.code)
  end
end