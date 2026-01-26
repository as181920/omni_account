module OmniAccount
  class Account < ApplicationRecord
    belongs_to :holder, polymorphic: true
    belongs_to :parent, class_name: name, optional: true
    has_many :children, class_name: name, foreign_key: :parent_id, inverse_of: :parent, dependent: nil
    has_many :postings, dependent: :restrict_with_error
    has_many :entries, through: :postings

    enum :normal_balance, [:debit, :credit]

    validates_presence_of :holder_id, :holder, :name, :normal_balance
    validates_uniqueness_of :name, scope: [:holder_id, :holder_type]
    validates_uniqueness_of :code, scope: [:holder_id, :holder_type], allow_blank: true
    validates_numericality_of :balance, greater_than_or_equal_to: 0, if: :debit?
    validates_numericality_of :balance, less_than_or_equal_to: 0, if: :credit?
    validate :holder_must_match_parent_holder
    validate :parent_must_not_create_cycle, if: :will_save_change_to_parent_id?

    before_validation :set_initial_attrs, on: :create
    before_save :clear_level_cache, if: :will_save_change_to_parent_id?

    scope :roots, -> { where(parent_id: nil) }
    scope :tree_ordered, -> { order(Arel.sql("NULLIF(code, '') NULLS LAST"), Arel.sql("COALESCE(parent_id, id)"), :id) }

    delegate :to_s, to: :name

    class << self
      def ransackable_attributes(_auth_object = nil)
        %w[name code description holder_type holder_id parent_id normal_balance balance]
      end

      def ransackable_associations(_auth_object = nil)
        %w[parent postings entries]
      end

      def ransackable_scopes(_auth_object = nil)
        %w[roots]
      end
    end

    def indented_name
      "#{'　' * level}#{name}"
    end

    def display_label
      "#{'　' * level}#{[code, name].compact_blank.join(' - ')}"
    end

    def root
      node = self
      node = node.parent while node.parent
      node
    end

    def nth_parent(nth)
      node = self
      nth.times do
        node = node.parent
        break node if node.nil?
      end
      node
    end

    def level
      @level ||= parent ? parent.level + 1 : 0
    end

    def descendants
      children.flat_map { |child| [child, *child.descendants] }
    end

    def self_and_descendants
      [self] + descendants
    end

    def total_balance
      self_and_descendants.sum(&:balance)
    end

    def parent_select_options
      self.class.where(holder:).where.not(id: self_and_descendants.pluck(:id).compact_blank).tree_ordered.map do |acct|
        [acct.display_label, acct.id]
      end
    end

    private

      def set_initial_attrs
        self.holder ||= parent&.holder
      end

      def holder_must_match_parent_holder
        return if parent.nil? || (holder == parent.holder)

        errors.add(:holder, "must match parent's holder")
      end

      def parent_must_not_create_cycle
        return if parent_id.blank?

        node = parent
        while node
          errors.add(:parent_id, "parent cannot be self or descendants") && break if node.id == id
          node = node.parent
        end
      end

      def clear_level_cache
        @level = nil
        children.each(&:clear_level_cache)
      end
  end
end
