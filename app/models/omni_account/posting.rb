module OmniAccount
  class Posting < ApplicationRecord
    belongs_to :account
    belongs_to :entry
    belongs_to :previous, class_name: self.name, foreign_key: :previous_id, optional: true
    has_one :next, class_name: self.name, foreign_key: :previous_id

    validates_presence_of :account_id, :entry_id, :previous_id
    validates :amount, presence: true, numericality: { other_than: 0 }
    validates_uniqueness_of :previous_id, scope: :account_id
    # validates :balance, presence: true, numericality: true
    validates_numericality_of :balance, greater_than_or_equal_to: 0, if: :account_debit?
    validates_numericality_of :balance, less_than_or_equal_to: 0, if: :account_credit?

    with_options on: :create do
      before_validation :auto_set_previous
      before_validation :auto_calculate_balance
    end
    after_create :update_account_balance

    delegate :debit?, :credit?, to: :account, prefix: true

    class << self
      def ransackable_attributes(_auth_object = nil)
        %w[id acount_id entry_id previous_id amount balance description created_at]
      end

      def ransackable_associations(_auth_object = nil)
        %w[account entry previous next]
      end
    end

    def debit? = amount.positive?
    def credit? = amount.negative?

    private

      def auto_set_previous
        self.previous_id = account&.postings.where.not(id: nil)&.last&.id || 0
      end

      def auto_calculate_balance
        self.balance = (previous&.balance || 0) + amount
      end

      def update_account_balance
        account.reload.update!(balance: balance)
      end
  end
end
