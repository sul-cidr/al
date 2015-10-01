function hardSpace(string){
  return string.replace(/ /g,'&nbsp;')
}

function swap(point) {
  point = [point[1], point[0]]
  return point
}

var mapStyles = {
  street: {
    "color": "steelblue",
    "weight": 3,
    "opacity": 0.85
  },
  area: {
    "color": "red",
    "weight": 1,
    "opacity": 0,
    "fillOpacity": 0
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
