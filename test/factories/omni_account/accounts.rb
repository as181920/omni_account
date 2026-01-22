FactoryBot.define do
  factory :account, class: "OmniAccount::Account" do
    association :holder, factory: :tenant
    normal_balance { :debit }
    sequence :name do |n|
      "account_#{n}"
    end

    transient do
      parent_account { nil }
    end

    after(:build) do |account, evaluator|
      if evaluator.parent_account
        account.parent = evaluator.parent_account
        account.holder = evaluator.parent_account.holder
      end
    end
  end
end
