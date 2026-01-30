module OmniAccount
  class Entry < ApplicationRecord
    belongs_to :origin, polymorphic: true
    has_many :postings, dependent: :restrict_with_error
    has_many :accounts, through: :postings

    validates :uid, presence: true, uniqueness: true
    validates_presence_of :origin_id, :origin

    before_validation :auto_set_uid, on: :create

    class << self
      def ransackable_attributes(_auth_object = nil)
        %w[id origin_type origin_id uid description created_at]
      end

      def ransackable_associations(_auth_object = nil)
        %w[origin postings accounts]
      end
    end

    private

      def auto_set_uid
        self.uid ||= generate_uid
      end

      def generate_uid
        Time.current.strftime("%Y%m%d%H%M%S%L") + Random.rand(99999).to_s.rjust(5, "0")
      end
  end
end
