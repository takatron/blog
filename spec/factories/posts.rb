FactoryGirl.define do
  factory :post do
    sequence :title do |n|
      "My Title #{n}"
    end
    sequence :content do |n|
      "My content #{n}"
    end
    slug { 'some_slug' }
  end
end
