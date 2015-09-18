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
    "opacity": 1,
    "fillOpacity": 0
  },
  point: {
    "color": "green",
    "radius": 5,
    "weight": 1,
    "opacity": 0.5,
    "fillOpacity": 0.35
  }
};
