class CreateOmniAccountAccountHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :omni_account_account_histories do |t|
      t.references :account, index: true, foreign_key: {to_table: :omni_account_accounts}
      t.references :entry, index: true, foreign_key: {to_table: :omni_account_entries}
      t.references :previous, index: {unique: true}
      t.decimal :amount, null: false, precision: 12, scale: 2, default: 0.0
      t.decimal :balance, null: false, precision: 12, scale: 2, default: 0.0
      t.text :description

      t.datetime :created_at, null: false
    end
  end
end
