ActiveAdmin.register Province do
  # Your Active Admin configuration for customers

  permit_params :email, :name, :abbreviation, :country, :hst, :gst, :pst

  index do
    selectable_column
    id_column
    column :name
    column :abbreviation
    column :pst
    column :gst
    column :hst
    actions
  end

  filter :name

  form do |f|
    f.inputs "Province Details" do
      f.input :name
      f.input :abbreviation
      f.input :country, :as=>:string
      f.input :hst, :label=>'HST'
      f.input :gst, :label=>'GST'
      f.input :pst, :label=>'PST'
    end
    f.actions
  end

end
