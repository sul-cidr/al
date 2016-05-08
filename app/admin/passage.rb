ActiveAdmin.register Passage do
  permit_params :passage_id, :work_id, :subject_id, :text

  index do
		column 'id', :passage_id
		column :text
		column 'work', :work
		column 'places', :placerefs

		actions
	end

  form do |f|
    f.inputs "Passage" do
      f.input :work
      f.input :passage_id
      f.input :text
    end
    f.actions
  end

	filter :work, collection: proc { Work.order(:title)}
	filter :text
	filter :placerefs, label: "places"

end
