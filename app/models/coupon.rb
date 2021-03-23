class Coupon < ApplicationRecord
  belongs_to :promotion, dependent: :destroy
  enum status:{active: 0, disabled: 10}
end
