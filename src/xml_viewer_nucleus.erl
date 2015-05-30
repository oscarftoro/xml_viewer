-module(xml_viewer_nucleus).
-export([decode_simple/1,
         decode_sax/1,
         validate_schema/2,
         parse_term/1
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


%% %% A simple version of the tree: 
%% children([{Name,_,[Value | [] ]}| Rest], Acc)  ->
%%   children(Rest,[[do_name(Name),{<<"children">>,[Value]}]|Acc]) ;
%% parse_list([H|T],Acc)->
%%     parse_list(T,do_tree(H,Acc));
%% parse_list([],Acc)->
%%     Acc.

%% do_name(Value)->
%%   #{<<"name">> => Value}.

%% do_children(Value)->
%%   #{<<"children">> => [do_name(Value)]}.
%% add_children(Map,Value) ->
%%     List = maps:get(<<"children">>),
%%     maps:update(<<"children">>,[Value|List],Map).
    
%% add_child({<<"children">>,List},Value)->   
%%   {<<"children">>,[Value|List]}.

%% do_tree({Name,_,[[{N,_,_V}| []] | Rest] }, Acc)->
    
%%   Res = 
%%     {<<"children">>,[{<<"name">>,Name},{<<"children">>,[{<<"name">>,N}]}]},
%%   do_tree(Rest,[Res|Acc]);

%% do_tree({Name,_,[Head|Rest]}, Acc) ->
%%   {N,_,V} = Head,
%%   case Name =:= N of
%%     true -> 
%%       add_child(Acc,V);
%%     _    ->
%%       do_children(Acc,V)
%%   end,
%%   do_tree(Rest,Acc);

%% do_tree([],Acc) ->
%%   Acc.  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%when the list contain only one element( a string)
%% parse_term({Name,_,[Head | [] ]}, Acc)->
parse_term(Tuple) ->
  List = tuple_to_list(Tuple),
  [H|[T]] = List,
  Acc =#{<<"name">> => list_to_binary(H),
      <<"children">> => []},
  tree(T,Acc).

tree([[{Name,Value}]|T],Acc) ->
  L = maps:get(<<"children">>,Acc),
  ?DEBUG(L),
  Attribute = do_tree(Name,Value,[]),
  ?DEBUG(Attribute),
  Acc2 = Acc#{<<"children">> := [Attribute|L]},
  ?DEBUG(Acc2),
  tree(T,Acc2);


tree([{Name,_,Value}|T],Acc) ->
 ?DEBUG(Value),
  tree([[{Name,Value}]|T],Acc);

%% tree([{Name,_,[Value|OtherVals]}|T],Acc)->
%%   ok;
tree([],Acc) ->
  Acc.

%% -spec do_tree(string,[map()])-> map().
do_tree(Name,Child,Acc) ->
  #{<<"name">> => list_to_binary(Name),
      <<"children">> => do_child(Child,Acc)}.
do_child(Child,Acc) ->
  [#{<<"name">> => list_to_binary(Child)}|Acc].
%% parse_term({N,_,Ls},N,Acc) ->
  
%% parse_term({N,_,[]},N,Acc)->
%%     Acc.
