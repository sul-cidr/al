ActiveAdmin.register Category do

  config.sort_order = 'category_id_asc'

  index do
    column 'category id', :category_id
    column 'name', :name
    column 'dimmension id', :dimension_id

    actions
  end

end
