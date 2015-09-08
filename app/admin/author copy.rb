ActiveAdmin.register Author do

	config.sort_order = 'surname_asc'
	
	index do
		column 'author_id', :author_id
		column 'last name', :surname 
		column 'died', :death_year
		column 'full name', :prefname
		column 'VIAF id', :viaf_id
		actions
	end

	filter :prefname, label: 'full name'
	filter :surname, label: 'last name'
	filter :categories

	sidebar 'Works by this Author', :only => :show do
    table_for Work.joins(:author).where(:author_id => author.author_id) do |t|
      t.column("Title") { |work| work.title 
      	link_to work.title, admin_work_path(work) }
    end
  end

  permit_params :surname, :birth_year, :death_year, :prefname, :viaf_id

end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#

#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


