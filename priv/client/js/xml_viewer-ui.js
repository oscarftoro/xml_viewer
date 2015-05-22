var GenericWrapper = React.createClass({
  componentDidMount: function() {
    console.log(Array.isArray(this.props.children)); // => true
  (function(){
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
})(); 
  },

  render: function() {
    return <div />;
  }
});


React.render(
  <GenericWrapper><span/><span/><span/></GenericWrapper>,
  document.getElementById('example')
);
/*
$(document).ready(function(){
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
}); 


*/
