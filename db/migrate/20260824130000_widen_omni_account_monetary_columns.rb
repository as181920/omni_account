class WidenOmniAccountMonetaryColumns < ActiveRecord::Migration[8.1]
  def up
    change_column :omni_account_accounts, :balance, :decimal, precision: 18, scale: 2,
      default: 0.0, null: false
    change_column :omni_account_postings, :amount, :decimal, precision: 18, scale: 2, null: false
    change_column :omni_account_postings, :balance, :decimal, precision: 18, scale: 2, null: false
  end

  def down
    change_column :omni_account_accounts, :balance, :decimal, precision: 12, scale: 2,
      default: 0.0, null: false
    change_column :omni_account_postings, :amount, :decimal, precision: 12, scale: 2, null: false
    change_column :omni_account_postings, :balance, :decimal, precision: 12, scale: 2, null: false
  end
end
