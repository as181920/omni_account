require "test_helper"

module OmniAccount
  class AccountTest < ActiveSupport::TestCase
    # tree structure
    test "root account level should be 0" do
      account = create(:account)

      assert_equal 0, account.level
    end

    test "child account level should be 1" do
      parent = create(:account)
      child = create(:account, parent: parent)

      assert_equal 1, child.level
    end

    test "nested account level should be 2" do
      grandparent = create(:account)
      parent = create(:account, parent: grandparent)
      child = create(:account, parent: parent)

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
  end
end
