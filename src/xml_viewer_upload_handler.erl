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
%TODO:this is ugly, implement as a recursive handle
handle(Req,State) ->
  {ok, XMLHeaders, Req2} = cowboy_req:part(Req),
  %%take the first part(XML file)
  {ok, XMLData, Req3}    = cowboy_req:part_body(Req2),
  %%take the second part (XSD file)
  {ok,XSDHeaders,Req4}   = cowboy_req:part(Req3),  
  {ok,XSDData,Req5}      = cowboy_req:part_body(Req4),
 
  {file,_XmlFile,_XmlFileName,_XmlType,_7bit} = 
    cow_multipart:form_data(XMLHeaders),
  {file,_XsdFile,_XsdFileName,_XsdTupe,_} =
     cow_multipart:form_data(XSDHeaders),
  %%XML analysis
  _XMLTerm = xml_viewer_nucleus:decode_simple(XMLData),
  ?DEBUG(_XMLTerm),
  _IsSchemaValid = isSchemaValid(XMLData,XSDData),


  %_ErlangTerm = xml_viewer_nucleus:decode_simple(Data),
  %build my response sending a dummy tree in json
New = <<"{\"tree\":{\"name\":\"foo\",\"children\":[{\"name\":\"bar\",\"children\":[{\"name\":\"y\"}]},{\"name\":\"bar\",\"children\":[{\"name\":\"x\"}]},{\"name\":\"attr\",\"children\":[{\"name\":\"baz\"}]}]}}">>,%%old: {"name":"oscar","children":[{"name":"color","children":{"name":"Red"}},{"name":"country","children":{"name":"US"}}]}
_Old = <<"{\"tree\":{\"name\":\"oscar\",\"children\":[{\"name\":\"bar\",\"children\":[{\"name\":\"y\"}]},{\"name\":\"bar\",\"children\":[{\"name\":\"x\"}]}]}}">>,

_Dummy = <<"{\"tree\": {\"name\": \"foo\", \"children\" : [{\"name\": \"attr\", \"children\":[{\"name\": \"baz\"}]},{\"name\": \"bar\",\"children\":[{\"name\":\"x\"},{\"name\":\"y\"}]}]} }">>,
  {ok, Req6} = cowboy_req:reply(200, [
    {<<"content-type">>, <<"application/json">>}
],New, Req5),
  {ok, Req6, State}.   	  
    
terminate(_Reason,_Req,_State) ->
    ok.

%%Auxiliar functions
isSchemaValid(XML,XSD)->
  case xml_viewer_nucleus:validate_schema(XSD,XML) of
    {error,Ex} -> {false,Ex};
    _          -> true
  end.
