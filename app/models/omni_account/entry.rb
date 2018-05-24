module OmniAccount
  class Entry < ApplicationRecord
    belongs_to :origin, polymorphic: true
    has_many :account_histories, dependent: :restrict_with_exception
    has_many :accounts, through: :account_histories

    validates :uid, presence: true, uniqueness: true
    validates_presence_of :origin_id, :origin
    validates_uniqueness_of :origin_id, scope: :origin_type

    before_validation :auto_set_uid, on: :create

    private
      def auto_set_uid
        self.uid ||= generate_uid
      end

      def generate_uid
        DateTime.now.strftime("%Y%m%d%H%M%S%L") + Random.rand(99999).to_s.rjust(5, '0')
      end
  end
end
