ActiveAdmin.register Work do
  permit_params :work_id, :title, :sorter, :author_id, :work_year, :keywords

	config.sort_order = 'author_id_asc_and_title_asc'

	index do
		column :work_id
		column :title
		column :author
		column :work_year
    
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
