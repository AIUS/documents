
colors = require "utils.colors"

ui =
	section: (...) ->
		io.write colors.blue, ":: ", colors.white
		io.write ...
		io.write "\n", colors.reset

	info: (...) ->
		io.write colors.green, ":: ", colors.white
		io.write ...
		io.write "\n", colors.reset

	error: (...) ->
		io.stderr\write colors.red, ":: ", colors.white
		io.stderr\write ...
		io.stderr\write "\n", colors.reset

	debug: (...) ->
		io.stderr\write colors.cyan, ":: "
		io.stderr\write ...
		io.stderr\write "\n", colors.reset

return ui

