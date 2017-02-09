
lyaml = require "lyaml"
json = require "json"

ui = require "utils.ui"
formats = require "utils.formats"

=>
	content = do
		file = io.open @filename, "r"
		c = file\read "*all"
		file\close!
		c\match("%-%-%-\n(.*)%.%.%.\n.*")\gsub("%.%.%..*", "")

	output = do
		filename = @filename\sub(1, #@filename - 3) .. ".json"

		io.open filename, "w"

	header = lyaml.load content

	output\write json.encode header

	output\close!

	@headers = header

	header

