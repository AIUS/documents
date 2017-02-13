
lfs = require "lfs"
lyaml = require "lyaml"

ui = require "utils.ui"
formats = require "utils.formats"

=>
	content = do
		f = io.open @filename, "r"
		c = f\read "*all"
		f\close!
		c

	headers = lyaml.load content\gsub("%.%.%..*", "..."), nil

	if headers.date
		date = do
			s = headers.date\sub 2, #headers.date - 1
			s\gsub "T.*", ""
		file_date = @filename\gsub(".*/", "")\gsub("-[^0-9]+", "")

		if file_date\match "%d*-%d*-%d"
			-- Filename begins by a date.

			if date != file_date
				ui.error "Filename’s date and headers’ date do not match."
	else
		ui.error "Missing header date."

	do
		title = headers.title

		unless title
			ui.error "Missing header title."

	do
		subtitle = headers.subtitle

		if @filename\match("^pv/") and not subtitle
			ui.error "Missing header subtitle in a PV."

	do
		authors = headers.author
		t = type(authors)

		switch t
			when "string"
				ui.error "Headers’ author is a string."
			when "nil"
				ui.error "Missing headers’ author."
			else
				unless t == "table"
					ui.error "Headers’ author is a #{t}, not a table"

	sourceAttributes = lfs.attributes @filename

	for _, data in ipairs formats
		if data.buildable == false
			continue

		input = @filename
		output = do
			s = input\sub 1, #input - 3
			s .. "." .. data.extension

		outputAttributes = lfs.attributes output
		if outputAttributes
			if outputAttributes.modification < sourceAttributes.modification
				ui.error "  outdated: " .. output
			else
				ui.info "  file: " .. output
		else
			ui.error "  missing: " .. output

