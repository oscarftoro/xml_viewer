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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%Translate XML to JSON%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%for now, we translate XML attributes as a leave with  with one child
%% tree([[{Name,Value}]|T],Acc) ->
%%   L = maps:get(<<"children">>,Acc),
%%   Attribute = do_tree(Name,Value,[]),
%%   Acc2 = Acc#{<<"children">> := [Attribute|L]},
%%   tree(T,Acc2);

%% three elements nested in a list

%% tree([{Name,_,[Value|OtherVals]}|T],Acc) when OtherVals /= [] ->
%%   ?DEBUG(Value),
%%   {InnerName,_,InnerValue} = Value,
%%   Tree = do_tree(Name,no_child,no_acc),
%%   Attribute = tree([{InnerName,InnerValue}|OtherVals],Acc),
%%   List = maps:get(<<"children">>,Tree),
%%   ?DEBUG(Attribute),
%%   Acc3 =   Acc#{<<"children">> := [Attribute|List]},
%%   tree(T,Acc3);

%% tree([],Acc) ->
%%   Acc.

%% -spec do_tree(string,[map()])-> map().
%% do_tree([{Name,Val}|Tail]) ->
%%   #{<<"name">> =>list_to_binary(Name),
%%     <<"children">> =>[do_tree(Tail)]}.
%% do_tree(Name,Child,Acc) ->
%%   #{<<"name">> => list_to_binary(Name),
%%     <<"children">> => do_child(Child,Acc)}.


%% do_child(Child,Acc) ->
%%   [#{<<"name">> => list_to_binary(Child)}|Acc]

%% the first value is either a string or a tuple,

parse_term(Tuple) ->
  List = tuple_to_list(Tuple),
  start_tree(List).

start_tree([H|T])->
  ?DEBUG(T),
  #{<<"name">> => list_to_binary(H),
    <<"children">> => do_tree(T,[])}.

do_tree([[{TpName,TpVal}]|T],Acc) ->
  Tree = tree(TpName,TpVal,do_tree), %original without acc
  do_tree(lists:flatten(T),[Tree|Acc]);


%% when the TpVal is not a list 
do_tree([{TpName,_,TpVal}| T],Acc) ->  
  do_tree([[{TpName,TpVal}]|T],Acc);

%% % when the Tp val is a list of Triples
%% do_tree([{TpName,_,[TrHead|TrTail]}| T],Acc)->
%%   {TrName,_,TrValue} = TrHead,
%%   NewTree    = tree(TpName),
%%   InnerTree  = do_tree([[{TrName,TrValue}]|TrTail],[]),
%%   ResultTree = add_child(NewTree,InnerTree),
%%   do_tree(lists:flatten(T),[ResultTree|Acc]);
 

do_tree([],Acc)->
    Acc.
% I am trying to make the tree recurse over
%% the values which are lists.
-spec tree(string(),[any()],atom())-> map().
tree(Name,Values,do_tree)->
  Acc = #{<<"name">> => list_to_binary(Name),
         <<"children">> => []},
  ?DEBUG(Name),
  ?DEBUG(Values),
  rec_tree(Values,Acc).

rec_tree([{Name,Value}|T],Acc) ->
    ?DEBUG(Name),
    ?DEBUG(Value),
    Child = child(Value),
    Tree = tree(Name),
    TreeWithChild = add_child(Tree,Child),
    NewAcc = add_child(Acc,TreeWithChild),
    rec_tree(T,NewAcc);
rec_tree([],Acc) ->
    Acc.
    
%%Auxiliar functions
tree(Name)->
  #{<<"name">> => list_to_binary(Name),
    <<"children">> => []}.

child(Val)->
    #{<<"name">> => list_to_binary(Val)}.

add_child(Tree,Child)->
  
  List = maps:get(<<"children">>,Tree),
  maps:update(<<"children">>,[Child|List],Tree).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%old tree that works and takes only one value
%% tree(Name,Val) ->

%%   #{<<"name">> => list_to_binary(Name),
%%     <<"children">> => [child(Val)]}.
%this is the old child, also working
%% child(Val)->
%%     #{<<"name">> => list_to_binary(Val)}.
