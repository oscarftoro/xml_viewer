-module(xml_viewer_nucleus).
-export([decode_simple/1,
         decode_sax/1,
         validate_schema/2
         %childs/2
         %generate_tree/1
        ]).

-ifdef(debug_flag).
-define(DEBUG(X),io:format("DEBUG ~p: ~p ~p~n",[?MODULE,?LINE,X])).
-else.
-define(DEBUG(X),void).
-endif.
%% given a file as string path
%% returns a tuple with the decoded xml 
-spec decode_simple(binary()) -> any() | {error,any()}.

decode_simple(Xml)->
    {ok,Res,_} = erlsom:simple_form(Xml),
  Res. 
  
decode_sax(Xml)->
  case file:read_file(Xml) of
    {ok, Bin} ->
      {ok, _A, _} = erlsom:parse_sax(Bin, ok, fun callback/2);
    Error ->
      Error
  end.

callback(Event, State) ->
  io:format("~p\n", [Event]),
  State.

-spec validate_schema(string(),string()) -> any() | [any()].

validate_schema(Xsd,Xml)->
  
  {ok,Model}    = erlsom:compile(Xsd),

  case erlsom:scan(Xml,Model) of
      {ok,Res,_}                        ->  Res;
      {error,[{exception,Exception}|_]} ->  Exception
  end.

%% construct_tree(startDocument,Acc)->
%%   ok;
%% construct_tree({processingInstruction,_Xml,_Rest},Acc)->
%%   parse_sa

%%   Tree = {[{<<"name">>,TreeName},{<<"children">>,Children}]}
%%   Children = {<<"children">>,[Tree]}
    

%% -type tree()     :: {[{binary(),binary(),children()}]}.
%% -type children() :: {binary(),[{tree()}]}.
%% generate_tree(Expression)->
%%   {Name,PropList,Tree} = Expression
%%   childs(Childs,[]).
 
%% childs([{Name,_,List}||Rest],Acc)->
%%     childs(Rest,[{ <<"children">>,{list_to_binary(Name),[list_to_binary(Name)]} }]); 
%% childs([],Acc) ->
%%   Acc.


%% child_generator([Name,_,Value])->
%%   <<"children">>.
