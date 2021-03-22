class Coupon < ApplicationRecord
  belongs_to :promotion, dependent: :destroy
end
