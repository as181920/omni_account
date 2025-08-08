require "test_helper"

module OmniAccount
  class EntryTest < ActiveSupport::TestCase
    test "uid should be unique" do
      assert create(:entry, uid: "123")
      assert_not build(:entry, uid: "123").valid?
    end
  end
end
