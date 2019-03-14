class CreateBadges < ActiveRecord::Migration[5.2]
  def change
    create_table :badges do |t|
      t.string :name, null: false
      t.references :question, foreign_keys: true

      t.timestamps
    end
  end
end
