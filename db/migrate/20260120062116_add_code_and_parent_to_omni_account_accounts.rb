class AddCodeAndParentToOmniAccountAccounts < ActiveRecord::Migration[8.0]
  def change
    add_column :omni_account_accounts, :code, :string
    add_column :omni_account_accounts, :description, :text
    add_belongs_to :omni_account_accounts, :parent
  end
end
