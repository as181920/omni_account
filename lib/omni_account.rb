require "omni_account/engine"

module OmniAccount
  extend ActiveSupport::Concern

  included do
    has_many :accounts, as: :holder, class_name: "::OmniAccount::Account" do
      def by_name(name, options={})
        find_or_initialize_by(name: name).tap{ |account| account.update!(normal_balance: (options[:normal_balance].presence || "debit")) if account.new_record? }
      end
    end
    has_many :account_histories, through: :accounts
  end

  class_methods do
  end

  def account(name, options={})
    accounts.by_name(name, options)
  end

  def total_account_balance
    accounts.sum(:balance)
  end

  private
end
