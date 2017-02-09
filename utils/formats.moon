
formats = {
	{
		extension: "html"
		options: {
			"--template", "template.html", "-N"
			"--css=/pv.css", "--toc"
		}
	}
	{
		extension: "epub"
		options: {"-s", "--toc"}
	}
	{
		extension: "7"
		options: {"-s", "--toc"}
	}
	{
		extension: "pdf"
		options: {
			"--latex-engine=xelatex",
			"-H", "header.tex",
			"--template", "template.tex",
			"-N",
			"-V", "babel-otherlangs=french",
			"-V", "documentclass=article",
			"--toc"
		}
	}
	{
		extension: "json"
		buildable: false
	}
}

formats

