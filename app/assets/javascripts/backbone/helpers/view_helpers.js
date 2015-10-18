function hardSpace(string){
  return string.replace(/ /g,'&nbsp;')
}

function swap(point) {
  point = [point[1], point[0]]
  return point
}

var mapStyles = {

  features: {
    point: {
      "radius": 5,
      "weight": 1,
      "opacity": 0.5,
      "fillOpacity": 0.8
    },
    highlight: {
      "radius": 8,
      "weight": 2,
      "fillColor": "orange",
      "fillOpacity": 0.7
    }
  },
  street: {
    "color": "green",
    "weight": 3,
    "opacity": 0.85
  },
  area_placeref: {
    "color": "red",
    "weight": 1,
    "opacity": 0,
    "fillOpacity": 0
  },
  area: {
    start: {
    "color": "red",
    "weight": 1,
    "opacity": 0.5,
    "fillOpacity": 0
    },
    highlight: {
      "color": "orange",
      "weight": 2,
      "opacity": 1,
      "fillColor": "yellow",
      "fillOpacity": 0.1
    }
  },
  point_hood: {
    "color": "orange",
    "radius": 2,
    "weight": 1,
    "opacity": 1,
    "fillOpacity": 1
  },
  point_work: {
    "color": "green",
    "radius": 5,
    "weight": 1,
    "opacity": 0.5,
    "fillOpacity": 0.35
  },
  point_bio: {
    "color": "brown",
    "radius": 5,
    "weight": 1,
    "opacity": 0.5,
    "fillOpacity": 0.35
  }
};
