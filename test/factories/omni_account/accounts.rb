FactoryBot.define do
  factory :account, class: 'OmniAccount::Account' do
    association :holder, factory: :tenant
    normal_balance { :debit }
    sequence :name do |n|
      "account_#{n}"
    end
  end
end
