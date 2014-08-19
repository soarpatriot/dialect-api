FactoryGirl.define do
  factory :subject do
    sequence(:name) {|i| "subject #{i}" }
    sequence(:description) {|i| "subject #{i}" }
    owner
  end
end
