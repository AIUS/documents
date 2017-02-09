
ui = require "utils.ui"
formats = require "utils.formats"

=>
	for _, data in ipairs formats
		if data.buildable == false
			continue

		input = @filename
		output = do
			s = input\sub 1, #input - 3
			s .. "." .. data.extension

		ui.info "  building " .. data.extension

		command = do
			s = "pandoc "
			s ..= input
			s ..= " -o "
			s ..= output
			s ..= " "
			do
				directories = [match for match in @filename\gmatch("[^/]*")]
				directories[#directories] = nil

				for i = #directories, 1, -1
					s ..= " -V path=#{directories[i]}"

			s ..= " "
			s ..= table.concat(data.options, " ")
			s

		if arg.debug
			ui.debug command

		r = os.execute command
		if not r and r != 0
			ui.error "Command returned #{r}."

