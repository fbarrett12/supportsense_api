class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.references :organization, null: false, foreign_key: true
      t.string :email, null: false
      t.string :encrypted_password, null: false
      t.string :role, null: false, default: "agent"
      t.string :name
      t.string :time_zone

      t.timestamps
    end

    add_index :users, [:organization_id, :email], unique: true
  end
end
