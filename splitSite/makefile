default:
	@echo venv
	@echo server
	@echo run


CODE_ROOT=/Users/paul/github/slexil2
venv:
	@echo source $(CODE_ROOT)/py3105slexil/bin/activate


PORT=8088

server:
	python -m http.server $(PORT) &

run:
	open http://localhost:$(PORT)/hemlockMap.html
