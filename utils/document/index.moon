
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

	if @headers.author
		for i = 1, #@headers.author
			author = @headers.author[i]

			@headers.author[i] = switch author\gsub("<[^>]*>", "")
				when "Amicale des Informaticiens de l’Université de Strasbourg"
					"AIUS"
				when "Association Strasbourgeoise des Cursus Master Ingénierie"
					"ASCMI"
				else
					author

	header

