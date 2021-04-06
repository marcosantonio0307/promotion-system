class Coupon < ApplicationRecord
  belongs_to :promotion, dependent: :destroy
  enum status:{active: 0, disabled: 10}

  delegate :discount_rate, to: :promotion

  def as_json(options = {})
  	super({methods: :discount_rate}.merge(options))
  end
end
