module OmniAccount
  class AccountHistory < ApplicationRecord
    belongs_to :account
    belongs_to :entry
    belongs_to :previous, class_name: self.name, foreign_key: :previous_id, optional: true
    has_one :next, class_name: self.name, foreign_key: :previous_id

    validates_presence_of :account_id, :entry_id, :previous_id
    validates :amount, presence: true, numericality: {other_than: 0}
    validates :balance, presence: true, numericality: true
    validates_uniqueness_of :previous_id, scope: :account_id

    with_options on: :create do
      before_validation :auto_set_previous
      before_validation :auto_calculate_balance
    end
    after_create :update_account_balance

    private
      def auto_set_previous
        self.previous_id = account&.histories&.last&.id || 0
      end

      def auto_calculate_balance
        self.balance = (previous&.balance || 0) + amount
      end

      def update_account_balance
        account.update!(balance: balance)
      end
  end
end
