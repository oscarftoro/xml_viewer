{application, xml_viewer, [
	{description, ""},
	{vsn, "0.1.0"},
	{id, ""},
	{modules, ['xml_viewer_app', 'xml_viewer_sup']},
	{registered, []},
	{applications, [
		kernel,
		stdlib,
                sasl,
                cowboy,
                erlsom,
                reup
	]},
	{mod, {xml_viewer_app, []}},
	{env, []}
]}.
