class CreateSupport < ActiveRecord::Migration[6.0]
  def self.up
    create_table "support", primary_key: "SERVERID", id: :bigint do |t|
      t.bigint "CHANNEL", null: false
      t.bigint "ROLE", null: false
      t.bigint "NOTIFICATION", null:false
    end
  end
  def self.down
    drop_table "support"
  end
end
