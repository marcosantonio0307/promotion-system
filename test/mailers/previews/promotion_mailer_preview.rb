class PromotionMailerPreview < ActionMailer::Preview
  def approval_email
    PromotionMailer(Promotion.first, User.first)
  end
end