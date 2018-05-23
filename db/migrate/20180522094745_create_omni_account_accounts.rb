class CreateOmniAccountAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :omni_account_accounts do |t|
      t.references :holder, polymorphic: true
      t.string :name
      t.integer :normal_balance, index: true
      t.decimal :balance, null: false, precision: 12, scale: 2, default: 0.0

      t.timestamps null: false

      t.index [:holder_id, :holder_type, :name], unique: true, name: "index_omni_account_accounts_on_holder_and_name"
    end
  end
end
