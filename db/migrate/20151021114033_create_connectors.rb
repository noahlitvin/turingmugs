class CreateConnectors < ActiveRecord::Migration
  def change
    create_table :connectors do |t|
      t.string :channel
      t.string :mug_number
      t.string :user_number

      t.timestamps null: false
    end
  end
end
