class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :characters do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.integer :stat_combat
      t.integer :stat_durability
      t.integer :stat_intelligence
      t.integer :stat_power
      t.integer :stat_speed
      t.integer :stat_strength
      t.references :publisher, null: false, foreign_key: true
      t.references :alignment, null: false, foreign_key: true
      t.references :race, null: false, foreign_key: true

      t.timestamps
    end
  end
end
