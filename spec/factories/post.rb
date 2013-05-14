FactoryGirl.define do
  factory :post do
    sequence :title do |n|
      "This is a title#{n}"
    end
    body "This is the body"
    user
  end
end
