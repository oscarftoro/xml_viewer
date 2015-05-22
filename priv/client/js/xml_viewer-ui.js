var GenericWrapper = React.createClass({
  componentDidMount: function() {
    console.log(Array.isArray(this.props.children)); // => true
    (bullet);
  },

  render: function() {
    return <div />;
  }
});

var LoadXMLButton = React.createClass({
  getInitialState: function() {

    return {path: ""};// i'm using double quotes here...
  },
  handleClick: function(event) {
    console.log("hola " + event.target.value);
    var Path = event.target.value; 
    console.log(document.getElementById('xmlinput').item[0].getDataURL());
    this.setState({path: Path});
  },
  render: function() {
    var Path = "";
    return (
      <div class="form-group">
      <label for="xmlLoadButton">Select and XML file</label>
      <input type="file" id='xmlinput' onChange={this.handleClick} />
      </div>
    );
  }

});

/////////////////////////
// bullet communication//
/////////////////////////

var bullet = function(){
    var bullet = $.bullet('ws://localhost:8181/ws');
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
        alert(e.data);
    };
    bullet.onheartbeat = function(){
        bullet.send('ping');
    }
}();

React.render(
  <LoadXMLButton />,
  document.getElementById('container')
);
