ActiveAdmin.register Order do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :customer_id, :pst, :gst, :hst, :status, :grand_total, :order_items
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
    column :grand_total
    column :pst
    actions
  end

  show do
    attributes_table do
      row :customer
      row :status
      row :order_items
      row :stripe_payment_id
      row :hst
      row :gst
      row :pst
      row :created_at
      row :updated_at
    end
    active_admin_comments_for(resource)
  end

  form do |f|
    f.inputs "Order Details" do
      f.input :customer, :collection => Customer.pluck(:email, :id)
      f.input :order_items
      f.input :status, :as=>:select, :collection => [["New", "new"], ["Paid", "paid"], ["Shipped", "shipped"]]
      f.input :hst, :label=>'HST'
      f.input :gst, :label=>'GST'
      f.input :pst, :label=>'PST'
      f.input :grand_total, :as => :string, :input_html => { :readonly => true }
    end
    f.actions
  end
end
