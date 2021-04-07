Fabricator(:promotion) do
  name {sequence(:name) {|i| "Natal#{i}"}}
  description 'Promoção de Natal'
  code {sequence(:code) {|i| "NATAL#{i}"}}
  discount_rate 15
  coupon_quantity 100
  expiration_date '20/12/2022'
  user
end