FactoryBot.define do
  factory :account_history, class: "OmniAccount::AccountHistory" do
    association :account, factory: :account
    association :entry, factory: :entry
  end
end
