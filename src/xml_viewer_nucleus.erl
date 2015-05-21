-module(xml_viewer_nucleus).
-export([decode_simple/1,
         validate_schema/2]).

%% given a file as string path
%% returns a tuple with the decoded xml 
-spec decode_simple(string()) -> any() | {error,any()}.

decode_simple(F)->
  {ok, Xml}  = file:read_file(F),
  {ok,Res,_} = erlsom:simple_form(Xml),
  Res.   

-spec validate_schema(string(),string()) -> any() | [any()].

validate_schema(Xsd,Xml)->
  {ok,XmlTuple} = file:read_file(Xml),
  {ok,Model}    = erlsom:compile_file(Xsd),

  case erlsom:scan(XmlTuple,Model) of
      {ok,Res,_} ->  Res;
      {error,Ex} ->  Ex
  end.
  
