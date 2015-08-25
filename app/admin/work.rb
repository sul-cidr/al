ActiveAdmin.register Work do

	config.sort_order = 'author_id_asc_and_title_asc'

	index do
		column :work_id
		column :title 
		column :author
		column :pub_year
		actions
	end

	filter :author
	filter :title

	sidebar 'Passages from this work', :only => :show do
    table_for Passage.joins(:work).where(:work_id => work.work_id) do |t|
      t.column("text") { |passage| passage.text }
    end
  end

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
