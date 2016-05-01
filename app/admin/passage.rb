ActiveAdmin.register Passage do
  permit_params :passage_id, :work_id, :subject_id, :text

  index do
		column 'passage_id', :passage_id
    column 'work', :work
		column :text

		actions
	end

	filter :work, collection: proc { Work.order(:title)}
	filter :text

end
