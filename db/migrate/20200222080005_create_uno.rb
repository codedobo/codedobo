class CreateUno < ActiveRecord::Migration[6.0]
  def self.up
    create_table "uno", primary_key: "SERVERID", id: :bigint do |t|
      t.string "THEME", null: false
      t.bigint "CATEGORY"
    end
  end
  def self.down
    drop_table "uno"
  end
end
