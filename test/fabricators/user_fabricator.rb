Fabricator(:user) do	
  email {sequence(:email) {|i| "marcos#{i}@iugu.com.br"}}
  password '123456'
end