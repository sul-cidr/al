var packAuths = function (auths) {
  // console.log(JSON.stringify(auths))
  var bleed = 10,
      width = 340,
      height = 400;

  var pack = d3.layout.pack()
      .sort(null)
      .size([width, height + bleed * 2])
      .padding(2);

  var svg = d3.select("#place_content_region").append("svg")
      .attr("width", width)
      .attr("height", height)
    .append("g")
      .attr("transform", "translate(0," + -bleed + ")");

  // d3.json(auths, function(error, json) {
    // if (error) throw error;

  var node = svg.selectAll(".node")
      .data(pack.nodes(auths)
        .filter(function(d) { return !d.children; }))
    .enter().append("g")
      .attr("class", "node")
      .attr("transform", function(d) {
        return "translate(" + d.x + "," + d.y + ")"; })
      .on("click", function(d){
        console.log('clicked '+ d.key)
        AL.PlacesApp.Show.Controller.listPlacePassages(d.key)
      });

  node.append("circle")
      .attr("r", function(d) { return d.r; });

  node.append("text")
      .text(function(d) { return authLabel[d.key]; })
      .style("font-size", function(d) {
        return Math.min(2 * d.r, (2 * d.r - 8) / this.getComputedTextLength() * 24) + "px";
      })
      .attr("dy", ".35em");
  // });

  d3.select(self.frameElement).style("height", height + "px");
}
