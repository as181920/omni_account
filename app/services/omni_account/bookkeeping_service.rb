module OmniAccount
  class BookkeepingService
    EmptyTransfersError = Class.new StandardError
    InvalidTransferAccountError = Class.new StandardError
    InvalidTransferAmountError = Class.new StandardError
    TransferAmountEquationError = Class.new StandardError
    EntryHistroyAmountEquationError = Class.new StandardError

    attr_accessor :transfers, :origin, :uid, :description

    def initialize(transfers = [], origin = nil, options = {})
      @transfers = transfers
      @origin = origin
      @uid = options[:uid]
      @description = options[:description]
    end

    def perform
      Rails.logger.info "Bookkeeping : #{self.to_json}"

      ::OmniAccount::Account.transaction do
        post_double_entry
      end
    end

    private

      def post_double_entry
        entry = ::OmniAccount::Entry.create!(origin: origin, uid: uid, description: description)
        histories = parsed_transfers.map { |transfer| entry.account_histories.create!(transfer) }
        histories.sum(&:amount).zero? ? true : raise(EntryHistroyAmountEquationError)
      end

      def parsed_transfers
        transfers.map do |transfer|
          if transfer.is_a?(Array)
            HashWithIndifferentAccess.new.tap { |h| h[:account], h[:amount], h[:description] = transfer }
          elsif transfer.is_a?(Hash)
            HashWithIndifferentAccess.new(transfer).slice(:account, :amount, :description)
          else
            {}
          end
        end.tap do |transfers|
          raise EmptyTransfersError unless transfers.present?
          raise InvalidTransferAccountError unless transfers.all? { |t| t[:account].class.name == "OmniAccount::Account" }
          raise InvalidTransferAmountError unless transfers.all? { |t| t[:amount].is_a?(Numeric) && t[:amount].nonzero? }
          raise TransferAmountEquationError unless transfers.sum { |t| t[:amount] }.zero?
        end
      end
  end
end
