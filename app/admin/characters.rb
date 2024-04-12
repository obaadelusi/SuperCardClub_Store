ActiveAdmin.register Character do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name, :description, :price, :stat_combat, :stat_durability, :stat_intelligence, :stat_power, :stat_speed, :stat_strength, :publisher_id, :alignment_id, :race_id, :image
  remove_filter :image_attachment, :image_blob
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :description, :price, :stat_combat, :stat_durability, :stat_intelligence, :stat_power, :stat_speed, :stat_strength, :publisher_id, :alignment_id, :race_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  form do |f|
    f.semantic_errors
    f.inputs
    f.inputs do
      f.input :image, as: :file, hint: f.object.image.present? ? image_tag(f.object.image) : ""
    end
    f.actions
  end

end
