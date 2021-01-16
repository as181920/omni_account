require "test_helper"
require "benchmark"
require "with_advisory_lock"

module OmniAccount
  class BookkeepingPerformanceTest < ActiveSupport::TestCase
    setup do
      @credit_account = create(:account, normal_balance: :credit)
      @debit_accounts = 5.times.map { create(:account) }
    end

    test "concurrent with advisory lock" do
      puts Benchmark.measure {
        threads = 5.times.map do |idx|
          Thread.new {
            loop do
              begin
                OmniAccount::Account.with_advisory_lock("temp_lock_name") do
                  OmniAccount::BookkeepingService.new([ [@credit_account, -1], [@debit_accounts[idx], 1] ], @credit_account).perform
                end
                break if @credit_account.balance < -1000
              rescue => e
                Rails.logger.error "Thread #{idx} #{e.class.name}: #{e.message}"
              end
            end
          }
        end
        threads.each(&:join)
      }
    end
  end
end
