require "test_helper"

module OmniAccount
  class AccountTest < ActiveSupport::TestCase
    # to_s
    test "should delegate to_s to name" do
      account = create(:account)

      assert_equal account.to_s, account.name
    end

    # tree structure
    test "root account level should be 0" do
      account = create(:account)

      assert_equal 0, account.level
    end

    test "child account level should be 1" do
      parent = create(:account)
      child = create(:account, parent_account: parent)

      assert_equal 1, child.level
    end

    test "nested account level should be 2" do
      grandparent = create(:account)
      parent = create(:account, parent_account: grandparent)
      child = create(:account, parent_account: parent)

      assert_equal 2, child.level
    end

    # codable
    test "code can be nil" do
      account = create(:account, code: nil)

      assert_nil account.code
    end

    test "code can be empty and duplicate" do
      account1 = create(:account, code: "")
      account2 = create(:account, code: "")

      assert_predicate account2, :valid?
    end

    test "code must be unique within holder" do
      create(:account, code: "CODE123")

      assert_not build(:account, code: "CODE123").valid?
    end

    test "code can be same for different holders" do
      tenant1 = create(:tenant)
      tenant2 = create(:tenant)
      create(:account, holder: tenant1, code: "CODE123")
      account2 = create(:account, holder: tenant2, code: "CODE123")

      assert_predicate account2, :valid?
    end

    test "should calculate total balance includes children balances" do
      account = create(:account, balance: 1)
      sub_account = create(:account, parent_account: account, balance: 2)
      _deep_account = create(:account, parent_account: sub_account, balance: 3.3)

      assert_equal 6.3.to_d, account.total_balance
    end

    test "child account holder must match parent holder" do
      parent = create(:account)
      different_holder = create(:tenant)
      child = build(:account, parent: parent, holder: different_holder)

      assert_not child.valid?
      assert_includes child.errors[:holder], "must match parent's holder"
    end
  end
end
