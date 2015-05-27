-module(xml_viewer_app).
-behaviour(application).

-export([start/2]).
-export([stop/1]).
-export([start/0,stop/0]).

start(_Type, _Args) ->

  Path_list = path_list(), 
  Dispatch = cowboy_router:compile([
    {'_',Path_list}
  ]),
    {ok,_pid} = cowboy:start_http(http,10,[{port,8181}],
  [{env,[{dispatch,Dispatch}]}]),
  xml_viewer_sup:start_link().

stop(_State) ->
	ok.
start() ->
  application:ensure_all_started(xml_viewer).
stop()->
  application:stop(xml_viewer).

path_list() ->
  % we are only going to serve static files this time
  Static_assets = {"/[...]",cowboy_static,{priv_dir,xml_viewer,"client",
  [{mimetypes, cow_mimetypes, all}]}},
   Index        = {"/",cowboy_static,{priv_file,xml_viewer,"client/index.html",
   [{mimetypes, {<<"text">>, <<"html">>, []}}]}},
  UploadFile = {"/upload",xml_viewer_upload_handler,[]},
  WebSockets = {"/ws",bullet_handler,[{handler,xml_viewer_ws_handler}]},
  
  %% the order is very important, 
  %% does not work if bullet_handler compiles as the last element of the list 
  [Index,UploadFile,WebSockets,Static_assets].
