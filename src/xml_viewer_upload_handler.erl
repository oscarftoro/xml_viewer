-module(xml_viewer_upload_handler).
-behaviour(cowboy_http_handler).

-export([init/3,handle/2,terminate/3]).

-ifdef(debug_flag).
-define(DEBUG(X),io:format("DEBUG ~p: ~p ~p~n",[?MODULE,?LINE,X])).
-else.
-define(DEBUG(X),void).
-endif.

init(_,Req, _Opts) ->
  {ok,Req, undefined}.

handle(Req,State) ->
  ?DEBUG(Req),
    {ok, Headers, Req2}  = cowboy_req:part(Req),
 ?DEBUG(Req2),
  {ok, Data, Req3}    = cowboy_req:part_body(Req2),
  ?DEBUG(Req3),
 
  {file, <<"inputfile">>, Filename, ContentType, _TE} = 
    cow_multipart:form_data(Headers),
  io:format("Received file ~p of content-type ~p as follow:~n~p~n~n",  
  [Filename, ContentType, Data]),
  %% now I have the data structure
  _ErlangTerm = xml_viewer_nucleus:decode_simple(Data),
  {ok, Req4} = cowboy_req:reply(200, [
    {<<"content-type">>, <<"application/json">>}
], <<"{\"message\":\"hi\"}">>, Req3),
  {ok, Req4, State}.
   

terminate(_Reason,_Req,_State) ->
    ok.
