FactoryGirl.define do
  factory :post do
    title { 'my title' }
    content { 'my content' }
    slug { 'some_slug' }
  end
end
