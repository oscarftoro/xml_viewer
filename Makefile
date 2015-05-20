PROJECT  = xml_viewer
DEPS     = reup lager erlsom cowboy bullet triq
dep_reup = git https://github.com/RJ/erlang-reup.git master

TEST_ERLC_OPTS = +'{parse_transform, lager_transform}'

include erlang.mk


shell: app
	erl -pa ../xml_viewer/ebin ../xml_viewer/deps/*/ebin \
	../xml_viewer/files \
	-eval "xml_viewer_app:start()"

debug: ERLC_COMPILE_OPTS = +'{parse_transform, lager_transform}'
debug: clean app
	erl -pa ../xml_viewer/ebin ../xml_viewer/deps/*/ebin \
	../xml_viewer/files \
	-eval "lager:start(),xml_viewer_app:start()"

