var extend = function(child, parent) {
  for (var key in parent) {
    if (hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor();
    child.__super__ = parent.prototype;
    return child; },
  
  hasProp = {}.hasOwnProperty;

this.AL.module("PlacesApp.Show", function(Show, App, Backbone, Marionette, $, _) {
  return Show.Places = (function(superClass) {
    extend(Places, superClass);

    function Places() {
      return Places.__super__.constructor.apply(this, arguments);
    }

    Places.prototype.template = "places/show/templates/show_places";

    return Places;

  })(Marionette.ItemView);
});

