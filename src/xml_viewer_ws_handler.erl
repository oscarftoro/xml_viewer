-module(xml_viewer_ws_handler).
-export([init/4, stream/3, info/3, terminate/2]).

-ifdef(debug_flag).
-define(DEBUG(X),io:format("DEBUG ~p: ~p ~p~n",[?MODULE,?LINE,X])).
-else.
-define(DEBUG(X),void).
-endif.

init(_Transport, Req, _Opts, _Active) ->
  ?DEBUG(Req),
  io:format("hola web socket "),
  {ok, Req, undefined_state}.
 
stream(Data, Req, State) ->
  
  ?DEBUG(Data),
  ?DEBUG(Req),
   
  {reply, Data, Req, State}.
  
info(_Info, Req, State) ->
    {ok, Req, State}.
 
terminate(_Req, _State) ->
  ?DEBUG(_Req),
  io:format("bullet terminate~n"),
  ok.


