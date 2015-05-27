
var FileForm = React.createClass({
  componentDidMount: function() {

  },
  getInitialState: function() {

      return {data_uri:null};
  },
  hamdleSubmit: function(event) {
    event.preventDefault();
  },
  handleChange: function(event) {
    console.log("file " + event.target.value);

    //test to try bullet; this works!
    //bullet.send("hola" + event.target.value);
    //upload file

    document.forms["xmldata"].submit();
    event.preventDefault();
  },
  render: function() {

    return (
      <form name="xmldata" method="post" onSubmit={this.handleSubmit} encType="multipart/form-data" action="/upload">
      <div class="form-group">
      <label for="LoadButton">Select an XML file</label>
      <input type="file" name="inputfile" onChange={this.handleChange} />
      </div>
      </form>
    );
  }

});
///////////////////////
//The Sacred D3 Tree //
///////////////////////

function createTree(dom,props) {
  var margin = {top: 20, right: 120, bottom: 20, left: 120},
  width      = props.width - margin.right - margin.left,
  height     = props.height - margin.top - margin.bottom;

  var i    = 0,
  duration = 750,
  root; //root is undefined

  var tree = d3.layout.tree()
      .size([height,width]);
  var diagonal = d3.svg.diagonal()
    .projection(function(d) { return [d.y, d.x]; });

  var svg = d3.select("body").append("svg")
    .attr("width", width + margin.right + margin.left)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  //load data
  root = props.data;
  root.x0 = height / 2;
  root.y0 = 0;

  function collapse(d) {
    if (d.children) {
      d._children = d.children;
      d._children.forEach(collapse);
      d.children = null;
    }
  }

  root.children.forEach(collapse);
  update(root);
  //end load of data - this was a function

  d3.select(self.frameElement).style("height", "800px");

  function update(source) {

    // Compute the new tree layout.
    var nodes = tree.nodes(root).reverse(),
        links = tree.links(nodes);

    // Normalize for fixed-depth.
    nodes.forEach(function(d) { d.y = d.depth * 180; });

    // Update the nodes\u2026
    var node = svg.selectAll("g.node")
        .data(nodes, function(d) { return d.id || (d.id = ++i); });

    // Enter any new nodes at the parent's previous position.
    var nodeEnter = node.enter().append("g")
        .attr("class", "node")
        .attr("transform", function(d) { return "translate(" + source.y0 + "," + source.x0 + ")"; })
        .on("click", click);

    nodeEnter.append("circle")
        .attr("r", 1e-6)
        .style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; });

    nodeEnter.append("text")
        .attr("x", function(d) { return d.children || d._children ? -10 : 10; })
        .attr("dy", ".35em")
        .attr("text-anchor", function(d) { return d.children || d._children ? "end" : "start"; })
        .text(function(d) { return d.name; })
        .style("fill-opacity", 1e-6);

    // Transition nodes to their new position.
    var nodeUpdate = node.transition()
        .duration(duration)
        .attr("transform", function(d) { return "translate(" + d.y + "," + d.x + ")"; });

    nodeUpdate.select("circle")
        .attr("r", 4.5)
        .style("fill", function(d) { return d._children ? "lightsteelblue" : "#fff"; });

    nodeUpdate.select("text")
        .style("fill-opacity", 1);

    // Transition exiting nodes to the parent's new position.
    var nodeExit = node.exit().transition()
        .duration(duration)
        .attr("transform", function(d) { return "translate(" + source.y + "," + source.x + ")"; })
        .remove();

    nodeExit.select("circle")
        .attr("r", 1e-6);

    nodeExit.select("text")
        .style("fill-opacity", 1e-6);

    // Update the links\u2026
    var link = svg.selectAll("path.link")
        .data(links, function(d) { return d.target.id; });

    // Enter any new links at the parent's previous position.
    link.enter().insert("path", "g")
        .attr("class", "link")
        .attr("d", function(d) {
          var o = {x: source.x0, y: source.y0};
          return diagonal({source: o, target: o});
        });

    // Transition links to their new position.
    link.transition()
        .duration(duration)
        .attr("d", diagonal);

    // Transition exiting nodes to the parent's new position.
    link.exit().transition()
        .duration(duration)
        .attr("d", function(d) {
          var o = {x: source.x, y: source.y};
          return diagonal({source: o, target: o});
        })
        .remove();

    // Stash the old positions for transition.
    nodes.forEach(function(d) {
      d.x0 = d.x;
      d.y0 = d.y;
    });
    }

    // Toggle children on click.
    function click(d) {
      if (d.children) {
        d._children = d.children;
        d.children = null;
      } else {
        d.children = d._children;
        d._children = null;
      }
      update(d);
    }

  }//end update

//////////////////////////////////////////
/// The sacred D3's Tree React Wrapper //
////////////////////////////////////////
var Tree = React.createClass({
  propTypes: {
    width  : React.PropTypes.number,
    height : React.PropTypes.number
  },
  getDefaultProps: function() {
    return {
      width : 960,
      height: 800,
    };
  },
  componentDidMount: function() {
    var dom = this.getDOMNode();
    createTree(dom,this.props);
  },
  shouldComponentUpdate: function(nextProps, nextState) {
    var dom = this.getDOMNode();//try with nextProps
    createTree(dom,this.props);
  },
  render:  function(){
    return(
      <div>
      <h4> {this.props.title}</h4>
      </div>
    );
  }

});

///////////////////////////////////////////
//define an Alert to print message status//
///////////////////////////////////////////

var Alert = React.createClass({

  render: function(){
    // the role can be:alert-success,
    // alert-info,alert-warning or
    // alert-danger
    return(
      React.createElement(
        'div',{className:'alert ' +
        this.props.role},this.props.message)
    );
  }
});

/////////////////////////
// bullet communication//
/////////////////////////
var bulletService = function(){
    var bullet = $.bullet("ws://" + window.location.host + "/ws",{});
    bullet.onopen = function(){
        console.log('bullet: opened');
    };
    bullet.ondisconnect = function(){
        console.log('bullet: disconnected');
    };
    bullet.onclose = function(){
        console.log('bullet: closed');
    };
    bullet.onmessage = function(e){
        console.log(e.data);
    };
    bullet.onheartbeat = function(){
        bullet.send('ping');

    }
    return bullet;
};


// initiallize the global bullet function
//var bullet = bulletService();




// dummy data to be replaced
var data = {
 "name": "flare",
 "children": [
  {
   "name": "analytics",
   "children": [
    {
     "name": "cluster",
     "children": [
      {"name": "AgglomerativeCluster", "size": 3938},
      {"name": "CommunityStructure", "size": 3812},
      {"name": "HierarchicalCluster", "size": 6714},
      {"name": "MergeEdge", "size": 743}
     ]
    },
    {
     "name": "graph",
     "children": [
      {"name": "BetweennessCentrality", "size": 3534},
      {"name": "LinkDistance", "size": 5731},
      {"name": "MaxFlowMinCut", "size": 7840},
      {"name": "ShortestPaths", "size": 5914},
      {"name": "SpanningTree", "size": 3416}
     ]
    }
    ]
  }]};

React.render(
<div class="row">
  <div class="col-md-4">
   <FileForm/>

   <Alert role="alert-info" message="use the button above" />
  </div>
  <div class="col-md-8"><Tree data={data} title="Hej Tree" /></div>
</div>,
  document.getElementById('container')
);
