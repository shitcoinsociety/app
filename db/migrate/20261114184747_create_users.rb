class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    enable_extension "citext"

    create_table :users do |t|
      t.citext :email, null: false
      t.string :password_digest, null: false
      t.citext :handle
      t.string :locale, default: "en"
      t.string :name
      t.string :bio
      t.jsonb :social_links, default: {}
      t.timestamps
    end

    add_index :users, :handle, unique: true
    add_index :users, :email, unique: true
  end
end
