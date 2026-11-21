class CreateDeposits < ActiveRecord::Migration[8.1]
  def change
    create_table :deposits do |t|
      t.references :user, null: false, foreign_key: true
      t.references :asset, null: false, foreign_key: true
      t.references :wallet, null: false, foreign_key: true
      t.string :tx, null: false
      t.integer :tx_idx, null: false
      t.decimal :amount, precision: 36, scale: 18, null: false
      t.integer :block_height
      t.integer :confirmations, null: false, default: 0
      t.datetime :credited_at
      t.timestamps
    end

    add_index :deposits, [ :wallet_id, :tx, :tx_idx ], unique: true
  end
end
