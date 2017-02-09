
argparse = require "argparse"

with argparse "helper", "Helper for AIUS’ documents."
	\flag "-d --debug", "Adds a verbose debug output."

	\command "h help"

	with \command "l list"
		\flag "-c --colors --colours", "Adds colours to the output."

	with \command "b build"
		with \argument "filename", "Filename of the markdown file from which to generate documents."
			\args "*"

	with \command "c clean"
		with \argument "filename", "Filename of the markdown file from which to clean generated documents."
			\args "*"

	with \command "s status"
		with \argument "filename", "Filename of the markdown file for which to get status."
			\args "*"

	with \command "i index"
		with \argument "filename", "Filename of the markdown file for which to update the index."
			\args "*"

