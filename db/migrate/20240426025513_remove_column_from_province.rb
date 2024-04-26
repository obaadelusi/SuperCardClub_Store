class RemoveColumnFromProvince < ActiveRecord::Migration[7.1]
  def change
    remove_column :provinces, :abbreviation, :string
  end
end
