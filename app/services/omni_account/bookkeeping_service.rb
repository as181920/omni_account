=begin
TODO: add test cover
case 1: account balance not updated when another process changed balance and matches calc balance in current transaction
case 2: ensure data consistency with update! for account balance, without ! account balance may not updated
end
=end
module OmniAccount
  class BookkeepingService
    EmptyTransfersError = Class.new StandardError
    InvalidTransferAccountError = Class.new StandardError
    InvalidTransferAmountError = Class.new StandardError
    TransferAmountEquationError = Class.new StandardError
    EntryHistroyAmountEquationError = Class.new StandardError

    attr_accessor :transfers, :origin, :uid, :description

    def initialize(transfers=[], origin=nil, options={})
      @transfers = transfers
      @origin = origin
      @uid = options[:uid]
      @description = options[:description]
    end

    def perform(options={})
      Rails.logger.info "Bookkeeping : #{self.to_json}"

      if options[:transaction] == false
        perform_without_transaction
      else
        perform_with_transaction
      end
    end

    private
      def perform_with_transaction
        ::OmniAccount::Account.transaction do
          perform_without_transaction
        end
      end

      def perform_without_transaction
        entry = ::OmniAccount::Entry.create!(origin: origin, uid: uid, description: description)
        histories = parsed_transfers.map { |transfer| entry.account_histories.create!(transfer.tap{ |t| t.merge!(account_id: t.delete(:account).id) }) }
        histories.sum(&:amount).zero? ? true : raise(EntryHistroyAmountEquationError)
      end

      def parsed_transfers
        transfers.map do |transfer|
          if transfer.is_a?(Array)
            HashWithIndifferentAccess.new.tap{ |h| h[:account], h[:amount], h[:description] = transfer }
          elsif transfer.is_a?(Hash)
            HashWithIndifferentAccess.new(transfer).slice(:account, :amount, :description)
          else
            {}
          end
        end.tap do |transfers|
          raise EmptyTransfersError unless transfers.present?
          raise InvalidTransferAccountError unless transfers.all?{ |t| t[:account].class.name == "OmniAccount::Account" }
          raise InvalidTransferAmountError unless transfers.all?{ |t| t[:amount].is_a?(Numeric) && t[:amount].nonzero? }
          raise TransferAmountEquationError unless transfers.sum{ |t| t[:amount] }.zero?
        end
      end
  end
end
