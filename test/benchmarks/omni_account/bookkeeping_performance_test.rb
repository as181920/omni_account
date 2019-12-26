require "test_helper"
require "benchmark"

module OmniAccount
  class BookkeepingPerformanceTest < ActiveSupport::TestCase
    # setup do
    #   @credit_account = create(:account, normal_balance: :credit)
    #   @debit_account = create(:account)
    # end
    #
    # test "performance" do
    #   puts Benchmark.measure {
    #     500.times do
    #       OmniAccount::BookkeepingService.new([ [@credit_account, -1], [@debit_account, 1] ], @credit_account).perform
    #     end
    #   }
    # end
  end
end
