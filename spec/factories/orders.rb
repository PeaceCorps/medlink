FactoryGirl.define do
  factory :order do
    user
    fulfilled_at nil
    supply
    location 'Atlanta'
  end
end
