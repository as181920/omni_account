FactoryBot.define do
  factory :entry, class: "OmniAccount::Entry" do
    association :origin, factory: :account
  end
end
