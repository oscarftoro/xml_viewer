
var LoadFileButton = React.createClass({
  componentDidMount: function() {

  },
  getInitialState: function() {
      var fileLoaded = false;
      return {path: ""};
  },
  handleClick: function(event) {
    console.log("hola " + event.target.value);
    console.log(this.props);
    this.props.bulletService.send("holi from javascript");

  },
  render: function() {

    return (
      <div class="form-group">
      <label for="xmlLoadButton">Select an {this.props.type} file</label>
      <input type="file" id={this.props.type + 'input'} onChange={this.handleClick} />
      </div>
    );
  }

});

/////////////////////////////////////
/// The sacred D3.js Tree Wrapper //
///////////////////////////////////
var Tree = React.createClass({
  propTypes: {
    width  : React.PropTypes.number,
    height : React.PropTypes.number
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

var bullet = function(){
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
}();

///////////////////////
//Auxiliar functions //   <LoadFileButton bulletService={bullet} type="XML"/>
///////////////////////

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
   <LoadFileButton bulletService={bullet} type="XML"/>
   <LoadFileButton bulletService={bullet} type="XSD"/>
   <Alert role="alert-info" message="use the button above" />
  </div>
  <div class="col-md-8"><Tree data={data} title="Hej Tree" /></div>
</div>,
  document.getElementById('container')
);
