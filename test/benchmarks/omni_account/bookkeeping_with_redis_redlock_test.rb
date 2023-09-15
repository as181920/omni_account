require "test_helper"
require "benchmark"
require "redlock"

module OmniAccount
  class BookkeepingPerformanceWithRedisRedlockTest < ActiveSupport::TestCase
    setup do
      @credit_account = create(:account, normal_balance: :credit)
      @debit_accounts = 5.times.map { create(:account) }
      DistributedLock = Redlock::Client.new
    end

    test "concurrent with advisory lock" do
      @debit_accounts = 5.times.map { create(:account) }
      puts Benchmark.measure {
        threads = 5.times.map do |idx|
          Thread.new {
            loop do
              begin
                DistributedLock.lock!("temp_redlock_name", 2000) do
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
