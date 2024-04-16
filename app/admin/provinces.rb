ActiveAdmin.register Province do
  # Your Active Admin configuration for customers

  permit_params :email, :name, :abbreviation, :country

  index do
    selectable_column
    id_column
    column :name
    column :abbreviation
    column :country
    actions
  end

  filter :name

  form do |f|
    f.inputs "Province Details" do
      f.input :name
      f.input :abbreviation
      f.input :country
    end
    f.actions
  end

end
