// returns value between 0 and 1;
// r = [min,max] of dataset
function scale(value,r) {
  return value * ( 1/(r[1] - r[0]) );
}

// returns value in ems suitable for font size
function scaleFont(value,range) {
  s = d3.scale.linear()
    .domain(range)
    .range([0.8,1.4]) // em
  return s(value);
}

function poetize(string) {
  return string.replace(/\/(?!span)/g,'<br/>');
}

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


// $(function() {
//
//   var toponyms = new Bloodhound({
//     datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value'),
//     queryTokenizer: Bloodhound.tokenizers.whitespace,
//     prefetch: 'places.json',
//     // remote: {
//     //   url: '../data/films/queries/%QUERY.json',
//     //   wildcard: '%QUERY'
//     // }
//   });
//
//   $('#search_places .typeahead').typeahead(null, {
//     name: 'toponyms',
//     source: toponyms
//   });
//
//   $('#search_passages .typeahead').typeahead(null, {
//     name: 'toponyms',
//     source: toponyms
//   });
//   // $('#search_place').typeahead([
//   // {
//   // name: 'areas',
//   // prefetch: '/areas.json',
//   // }
//   // ]);
// })
