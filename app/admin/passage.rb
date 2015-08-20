ActiveAdmin.register Passage do

	index do
		column 'id', :passage_id
		column :text
		column 'work', :work
		column 'places', :placerefs

		# actions TODO -> broken
	end

	filter :work, collection: proc { Work.order(:title)}
	filter :text
	filter :placerefs, label: "places"

end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end