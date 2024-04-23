ActiveAdmin.register Order do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :customer_id, :pst, :gst, :hst, :status, :order_item_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:customer_id, :tax_rate, :status]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column :customer
    column :status
    column :order_items
    actions
  end

  form do |f|
    f.inputs "Order Details" do
      f.input :customer, :collection => Customer.pluck(:email, :id)
      f.input :order_items
      f.input :status, :as=>:select, :collection => [["New", "new"], ["Paid", "paid"], ["Shipped", "shipped"]]
      f.input :hst, :label=>'HST'
      f.input :gst, :label=>'GST'
      f.input :pst, :label=>'PST'
    end
    f.actions
  end
end
