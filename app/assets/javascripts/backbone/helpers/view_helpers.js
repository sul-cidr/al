function hardSpace(string){
  return string.replace(/ /g,'&nbsp;')
}

function swap(point) {
  point = [point[1], point[0]]
  return point
}

function createPolygonFromBounds(latLngBounds) {
  // var center = latLngBounds.getCenter()
    lnglats = [];

  lnglats.push([latLngBounds.getSouthWest().lng, latLngBounds.getSouthWest().lat]);//bottom left
  lnglats.push([latLngBounds.getNorthWest().lng, latLngBounds.getNorthWest().lat]);//top left
  lnglats.push([latLngBounds.getNorthEast().lng, latLngBounds.getNorthEast().lat]);//top right
  lnglats.push([latLngBounds.getSouthEast().lng, latLngBounds.getSouthEast().lat]);//bottom right
  lnglats.push([latLngBounds.getSouthWest().lng, latLngBounds.getSouthWest().lat]);//bottom left
  //
  // latlngs.push({ lat: latLngBounds.getSouth(), lng: center.lng });//bottom center
  // latlngs.push({ lat: center.lat, lng: latLngBounds.getEast() });// center right
  // latlngs.push({ lat: latLngBounds.getNorth(), lng: map.getCenter().lng });//top center
  // latlngs.push({ lat: map.getCenter().lat, lng: latLngBounds.getWest() });//center left

  return lnglats;
  // return new L.polygon(latlngs);
}
