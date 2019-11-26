FactoryGirl.define do
  factory :category do
    sequence :name do |n|
      "My Category #{n}"
    end
  end
end
