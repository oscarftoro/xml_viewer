PROJECT    = xml_viewer
DEPS       = sync lager erlsom cowboy jiffy triq
dep_reup   = git https://github.com/RJ/erlang-reup.git master
dep_bullet = https://github.com/extend/bullet.git 0.4.1

TEST_ERLC_OPTS = +'{parse_transform, lager_transform}'

include erlang.mk

get_client_deps: 
	cd priv/client; \
	bower install bower.json

start: 
	erl -pa ../xml_viewer/ebin ../xml_viewer/deps/*/ebin \
	../xml_viewer/files ../xml_viewer/include \
	-eval "xml_viewer_app:start()"

debug: $(ERLC_COMPILE_OPTS = +'{parse_transform, lager_transform}') 
debug: $(eval ERLC_OPTS = -Ddebug_flag)
debug: clean app
	erl -pa ../xml_viewer/ebin ../xml_viewer/deps/*/ebin \
	../xml_viewer/files ../xml_viewer/include \
	-eval "lager:start(),xml_viewer_app:start()"


