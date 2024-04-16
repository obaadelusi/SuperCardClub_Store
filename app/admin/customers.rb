ActiveAdmin.register Customer do
  # Your Active Admin configuration for customers

  permit_params :email, :encrypted_password, :first_name, :last_name, :street, :city, :province_id, :country, :postal_code

  index do
    # selectable_column
    id_column
    column :email
    column :encrypted_password
    column :first_name
    column :last_name
    column :street
    column :city
    column :province
    column :country
    column :postal_code
    actions
  end

  filter :email
  filter :city
  filter :country

  form do |f|
    f.inputs "Customer Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
      f.input :street
      f.input :city
      f.input :province
      f.input :country, :as=>:string
      f.input :postal_code
    end
    f.actions
  end

  # controller do
  #   def update
  #     # Ensure password is not updated if left blank
  #     if params[:customer][:password].blank? && params[:customer][:password_confirmation].blank?
  #       params[:customer].delete("password")
  #       params[:customer].delete("password_confirmation")
  #     end
  #     super
  #   end
  # end
end
