require "test_helper"

class OmniAccount::Test < ActiveSupport::TestCase
  setup do
    @holder = create(:tenant)
  end

  test "initia account for holder" do
    assert @holder.accounts.by_name("cash")
    assert @holder.accounts.by_name("manual_deposit", normal_balance: :credit)
  end
end
