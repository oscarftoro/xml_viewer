
var LoadFileButton = React.createClass({
  componentDidMount: function() {

  },
  getInitialState: function() {

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
//define a box to
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


React.render(
<div class="row">
  <div class="col-md-4">
   <LoadFileButton bulletService={bullet} type="XML"/>
   <LoadFileButton bulletService={bullet} type="XSD"/>
   <Alert role="alert-info" message="use the button above" />
  </div>
  <div class="col-md-8">A tree here</div>
</div>,
  document.getElementById('container')
);
