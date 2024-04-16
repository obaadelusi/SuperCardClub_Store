class CreateProvinces < ActiveRecord::Migration[7.1]
  def change
    create_table :provinces do |t|
      t.string :name
      t.string :abbreviation
      t.string :country

      t.timestamps
    end
  end
end
