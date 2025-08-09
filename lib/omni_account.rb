require "omni_account/engine"

module OmniAccount
  extend ActiveSupport::Concern

  included do
    has_many :accounts, class_name: "::OmniAccount::Account", as: :holder, dependent: :restrict_with_exception do
      def by_name(name, options = {})
        find_or_initialize_by(name: name).tap { |account| account.update!(normal_balance: (options[:normal_balance].presence || "debit")) if account.new_record? }
      end
    end
    has_many :postings, through: :accounts, source: :postings
  end

  class_methods do
  end

  def account(name, options = {})
    accounts.by_name(name, options)
  end

  def total_account_balance
    accounts.sum(:balance)
  end

  private
end
