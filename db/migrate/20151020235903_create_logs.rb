class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.string :title
      t.json :raw_data

      t.timestamps null: false
    end
  end
end
