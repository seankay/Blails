FactoryGirl.define do
  factory :post do
    sequence :title do |n|
      "This is a title#{n}"
    end
    sequence :body do |n|
      "This is the body for post #{n}"
    end
    user
  end
end
