module OmniAccount
  class Account < ApplicationRecord
    belongs_to :holder, polymorphic: true
    has_many :histories, class_name: "::OmniAccount::AccountHistory"
    has_many :entries, through: :histories

    enum normal_balance: [:debit, :credit]

    validates_presence_of :holder_id, :holder, :name, :normal_balance
    validates_uniqueness_of :name, scope: [:holder_id, :holder_type]
    validates :balance, numericality: {greater_than_or_equal_to: 0}, if: :debit?
    validates :balance, numericality: {less_than_or_equal_to: 0}, if: :credit?
  end
end
