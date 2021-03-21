class Promotion < ApplicationRecord
  validates :name, :code, :discount_rate, :coupon_quantity, :expiration_date,
  presence: {message: 'não pode ficar em branco'}
  validates :code, :name, uniqueness: {message: 'deve ser único'}
  has_many :coupons

  def generate_coupons
  	(1..coupon_quantity).each do |number|
      Coupon.create!(code: "#{code}-#{'%04d' % number}", promotion: self)
  	end
  end
end
