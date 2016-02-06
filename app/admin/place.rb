ActiveAdmin.register Place do
  permit_params :place_id, :prefname, :place_type, :latitude,
    :longitude, :geom_wkt, :geom_wkt_l, :geom_wkt_a, :source

  config.sort_order = 'prefname'

  index do
    column 'id', :place_id
    column 'prefname', :prefname
    column 'source', :source
    column 'geom_wkt', :geom_wkt
    column 'geom_wkt_l', :geom_wkt_l

    actions
  end

  filter :source
  filter :prefname



end
