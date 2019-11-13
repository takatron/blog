FactoryGirl.define do
  factory :user do
    firstname { 'John' }
    lastname { 'Smith' }
    email { 'john@test.com' }
    flare { '' }
    password { 'password123'}
  end
end
