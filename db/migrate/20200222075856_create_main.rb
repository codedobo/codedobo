class CreateMain < ActiveRecord::Migration[6.0]
  def self.up
    create_table "main", primary_key: "SERVERID", id: :bigint do |t|
      t.string "LANGUAGE", null: false
      t.string "PREFIX", null: false
    end
  end
  def self.down
    drop_table "main"
  end
end
