module OmniAccount
  class AccountHistory < ApplicationRecord
    belongs_to :account
    belongs_to :entry
    belongs_to :previous, class_name: self.name, foreign_key: :previous_id, optional: true
    has_one :next, class_name: self.name, foreign_key: :previous_id

    validates_presence_of :account_id, :account, :entry_id, :entry
    validates :amount, presence: true, numericality: {other_than: 0}
    validates :balance, presence: true, numericality: true

    validate :sequentiality_by_previous_link, on: :create

    before_validation :auto_set_previous, on: :create
    before_validation :auto_calculate_balance, on: :create
    after_save :update_account_balance

    private
      def auto_set_previous
        self.previous = account&.histories&.last
      end

      def auto_calculate_balance
        self.balance = (previous&.balance || 0) + amount
      end

      def update_account_balance
        account.update!(balance: balance)
      end

      def sequentiality_by_previous_link
        if account&.histories&.exists?
          errors.add(:previous_id, "Must have previous link to the last history of account") unless account.histories.where("previous_id >= ?", previous_id).empty? && previous&.account.eql?(self.account)
        else
          errors.add(:previous_id, "Must be nil as first history of account") if previous_id.present?
        end
      end
  end
end
