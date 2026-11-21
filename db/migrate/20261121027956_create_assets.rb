class CreateAssets < ActiveRecord::Migration[8.1]
  def change
    create_table :assets do |t|
      t.belongs_to :network, foreign_key: true
      t.string :type, default: "Asset"
      t.string :description
      t.string :contract_address

      # Metadata
      t.string :name
      t.citext :symbol
      t.integer :decimals
      t.decimal :total_supply, precision: 36, scale: 18
      t.integer :holders_count, default: 0
      t.integer :trades_count, default: 0
      t.jsonb :metadata

      t.timestamps
      t.index :symbol
      t.index :contract_address
    end
  end
end
