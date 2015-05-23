var GenericWrapper = React.createClass({
  componentDidMount: function() {
    console.log(Array.isArray(this.props.children)); // => true
     ;
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

// var bullet = function(){
//     var bullet = $.bullet('ws://localhost:8181/ws');
//     bullet.onopen = function(){
//         console.log('bullet: opened');
//     };
//     bullet.ondisconnect = function(){
//         console.log('bullet: disconnected');
//     };
//     bullet.onclose = function(){
//         console.log('bullet: closed');
//     };
//     bullet.onmessage = function(e){
//         alert(e.data);
//     };
//     bullet.onheartbeat = function(){
//         bullet.send('ping');
//     }
// }; 

///////////////////////
//Auxiliar functions //
///////////////////////
function notify(text) {
  var date = (new Date()).toLocaleString();
  output.innerHTML = output.innerHTML + '[' + date + '] ' + text + '\n';
}

function onData(data) {
  notify(data);
}
var bullet = function bullet(){
};

function start(url, options, notify, onData) {
  var connection = $.bullet(url, options);

  connection.onopen = function(){
    notify('online');
   };

   connection.onclose = connection.ondisconnect = function(){
     notify('offline');
   };

   connection.onmessage = function(e){
     if (e.data === 'pong'){
       notify('pong');
     } else {
       onData(e.data);
     }
   };

   connection.onheartbeat = function(){
     connection.send('ping');
        notify('ping');
   };
     return connection;
}

  connection = start("ws://" + window.location.host + "/ws", {}, notify, onData);




React.render(
  <LoadXMLButton />,
  document.getElementById('container')
);
