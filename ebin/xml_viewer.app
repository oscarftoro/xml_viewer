{application, xml_viewer, [
	{description, ""},
	{vsn, "0.1.0"},
	{id, "b1262fd-dirty"},
	{modules, ['xml_viewer_app', 'xml_viewer_sup', 'xml_viewer_nucleus']},
	{registered, []},
	{applications, [
		kernel,
		stdlib,
                sasl,
                cowboy,
                bullet,
                erlsom,
                reup
	]},
	{mod, {xml_viewer_app, []}},
	{env, []}
]}.
