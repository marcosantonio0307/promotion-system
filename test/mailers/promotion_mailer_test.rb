require 'test_helper'

class PromotionMailerTest < ActionMailer::TestCase
  test 'approval_email' do
    approver = Fabricate(:user, email: 'approver@iugu.com.br')
    promotion = Fabricate(:promotion, name: 'Carnaval')
    email = PromotionMailer.approval_email(promotion, approver)

    assert_equal [promotion.user.email], email.to
    assert_equal 'Sua promoção foi aprovada', email.subject
    assert_includes email.body, approver.email
  end
end