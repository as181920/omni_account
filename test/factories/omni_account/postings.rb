FactoryBot.define do
  factory :posting, class: "OmniAccount::Posting" do
    association :account, factory: :account
    association :entry, factory: :entry
  end
end
