require "test_helper"

module OmniAccount
  class BookkeepingServiceTest < ActiveSupport::TestCase
    setup do
      @credit_account = create(:account, normal_balance: :credit)
      @debit_account = create(:account)
    end

    test "normal bookkeeping with array transfers" do
      assert OmniAccount::BookkeepingService.new(
        [
          [@credit_account, -2, "withdraw"],
          [@debit_account, 2, "deposit"]
        ],
        @credit_account
      ).perform
      assert_equal 0, OmniAccount::Account.sum(:balance)
    end

    test "normal bookkeeping with hash transfers" do
      assert OmniAccount::BookkeepingService.new(
        [
          {account: @credit_account, amount: -9, description: "filler"},
          {account: @debit_account, amount: 9, description: "filler"}
        ],
        @credit_account
      ).perform
      assert_equal 0, OmniAccount::Account.sum(:balance)
    end

    test "transfers should not empty" do
      assert_raises OmniAccount::BookkeepingService::EmptyTransfersError do
        OmniAccount::BookkeepingService.new([], @credit_account).perform
      end
    end

    test "transfer should from and to account object" do
      assert_raises OmniAccount::BookkeepingService::InvalidTransferAccountError do
        OmniAccount::BookkeepingService.new([ [create(:tenant), -1], [create(:tenant), 1] ], @credit_account).perform
      end
    end

    test "transfer amount shold not be zero" do
      assert_raises OmniAccount::BookkeepingService::InvalidTransferAmountError do
        OmniAccount::BookkeepingService.new([ [@credit_account, 0], [@debit_account, 0] ], @credit_account).perform
      end
    end

    test "transfer amount should sum as zero" do
      assert_raises OmniAccount::BookkeepingService::TransferAmountEquationError do
        OmniAccount::BookkeepingService.new([ [@credit_account, -1], [@debit_account, 1.01] ], @credit_account).perform
      end
    end

    # test "concurrently create history for one account" do
    #   new_account = create(:account)
    #   exception = assert_raises ActiveRecord::RecordInvalid do
    #     threads = 20.times.map do |idx|
    #       Thread.new do
    #         OmniAccount::BookkeepingService.new([ [@credit_account, -1], [new_account, 1] ], @credit_account).perform
    #       end
    #     end
    #     threads.each(&:join)
    #   end
    #   assert_equal "Validation failed: Previous has already been taken", exception.message
    #   assert_equal 0, OmniAccount::Account.sum(:balance)
    # end

    test "concurrently transactions result in original balance" do
      OmniAccount::BookkeepingService.new([ [@credit_account, -1], [@debit_account, 1] ], @credit_account).perform
      OmniAccount::BookkeepingService.new([ [@debit_account, -1], [@credit_account, 1] ], @debit_account).perform
      assert_equal 0, OmniAccount::Account.sum(:balance)
    end
  end
end
