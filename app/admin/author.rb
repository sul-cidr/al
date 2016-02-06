ActiveAdmin.register Author do
  permit_params :author_id, :prefname, :surname, :middle, :given,
    :label, :birth_date, :death_date, :birth_year, :death_year,
    :wiki_id, :viaf_id

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

end

# sidebar query:
# SELECT "works".* FROM "works"
# INNER JOIN "authors" ON "authors"."author_id" = "works"."author_id"
# WHERE "works"."author_id" = $1  [["author_id", 10436]]


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
