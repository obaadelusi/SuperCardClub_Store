ActiveAdmin.register Customer do
  # Your Active Admin configuration for customers

  # permit_params :email, :password, :password_confirmation

  # index do
  #   selectable_column
  #   id_column
  #   column :email
  #   actions
  # end

  # filter :email

  # form do |f|
  #   f.inputs "Customer Details" do
  #     f.input :email
  #     f.input :password
  #     f.input :password_confirmation
  #   end
  #   f.actions
  # end

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
