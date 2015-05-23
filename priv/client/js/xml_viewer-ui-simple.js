


$(document).ready(function(){
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
});


