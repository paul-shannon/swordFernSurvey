default:
	@echo venv
	@echo server
	@echo view
	@echo publish
	@echo viewRemote

venv:
	@echo source /Users/paul/github/slexil2/py3105slexil/bin/activate

PORT=9012

server:
		python -m http.server $(PORT) &


PROJ = fernSurvey2025
DEST = paulshannnon@pshannon.net:public_html/pshannon.net/$(PROJ)

publish:
	scp map.html $(DEST)/index.html
	scp *.geojson $(DEST)/
	scp *.json $(DEST)/

view:
	@echo disable CORS in chrome
	open http://localhost:$(PORT)/map3.html

viewRemote:
	open https://pshannon.net/fernSurvey2025


