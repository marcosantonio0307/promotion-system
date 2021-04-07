Fabricator(:coupon) do
  code {sequence(:code){|i| "NATAL-'%04d' % #{i}"}}
  status 'active'
  promotion
end