
ui = require "utils.ui"
formats = require "utils.formats"

=>
	for _, data in ipairs formats
		input = @filename
		output = do
			s = input\sub 1, #input - 3
			s .. "." .. data.extension

		ui.info "  removing " .. data.extension

		os.execute "rm -f '" .. output .. "'"
	
