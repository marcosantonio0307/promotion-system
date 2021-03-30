class Promotion < ApplicationRecord
  validates :name, :code, :discount_rate, :coupon_quantity, :expiration_date,
  presence: true
  validates :code, :name, uniqueness: true
  has_many :coupons

  def generate_coupons
  	return if coupons.any?
    Coupon.transaction do
      (1..coupon_quantity).each do |number|
        self.coupons.create!(code: "#{code}-#{'%04d' % number}")
      end
    end
  end

  # TODO: adicionar validação de data de expiração
  def coupons?
  	coupons.any?
  end

  def self.search(query)
    where('name LIKE ?', "%#{query}%")
  end
end
