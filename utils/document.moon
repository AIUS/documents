
lfs = require "lfs"

formats = require "utils.formats"

html_tags = =>
	s = ""

	for _, tag in ipairs @headers.tags or {}
		s ..= "<li class=\"tag\">" .. tag .. "</li>"

	for _, author in ipairs @headers.author or {}
		author = author\gsub ",.*", ""
		s ..= "<li class=\"author\">" .. author .. "</li>"

	s

html_formats = =>
	s = ""

	for _, format in ipairs formats
		if format.buildable == false
			continue

		filename = @filename\gsub("%.[^/]*$", "." .. format.extension)
		s ..= "<li class=\"format-alt\"><a href=\"#{filename}\">#{format.extension}</a></li>"

	s

html_date = =>
	unless @headers.date
		return ""

	y, m, d = @headers.date\match "(%d%d%d%d)%-(%d%d)%-(%d%d)%D.*"

	if y and m and d
		return "#{y}-#{m}-#{d}"
	else
		return ""

class
	new: (@filename) =>

	@find_all: ->
		traversal = (where) ->
			for entry in lfs.dir where
				if entry\sub(1, 1) == "."
					continue

				entry = where .. "/" .. entry

				attributes = lfs.attributes entry

				if attributes.mode == "directory"
					traversal entry
				else
					if not entry\match(".md$")
						continue

					coroutine.yield entry\sub(3, #entry), attributes

		coroutine.wrap -> traversal "."

	status: require "utils.document.status"
	clean: require "utils.document.clean"
	build: require "utils.document.build"
	index: require "utils.document.index"

	to_html: =>
		name = @filename\gsub ".*/", ""
		
		directories = [match for match in @filename\gmatch("[^/]+")]
		directories[#directories] = nil

		"
			<div class=\"document #{table.concat directories, "-"}\">
				<div class=\"filename\">#{table.concat directories, ", "}</div>
				<h3 class=\"title\">
					<a href=\"#{@filename\gsub("%.[^/]*", ".html")}\">#{@headers.title}</a>
					<span class=\"date\">#{html_date @}</span>
				</h3>
				#{if @headers.subtitle then "<h4 class=\"subtitle\">#{@headers.subtitle}</h4>" else ""}
				<ul class=\"formats\">
					#{html_formats @}
				</ul>
				<ul class=\"tags\">
					#{html_tags @}
				</ul>
			</div>
		"\gsub "	*", ""

