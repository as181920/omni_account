class CreateOmniAccountEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :omni_account_entries do |t|
      t.references :origin, polymorphic: true, index: { unique: true }
      t.string :uid, index: { unique: true }
      t.text :description

      t.datetime :created_at, null: false
    end
  end
end
