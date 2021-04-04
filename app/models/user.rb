class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :promotions
  has_many :promotion_approvals
  has_one :approved_promotions, through: :promotion_approvals, source: :promotion
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
