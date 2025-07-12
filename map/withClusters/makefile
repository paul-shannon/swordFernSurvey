default:
	@echo venv
	@echo server
	@echo view
	@echo publish
	@echo viewRemote

venv:
	@echo source /Users/paul/github/slexil2/py3105slexil/bin/activate

PORT=9013

server:
		python -m http.server $(PORT) &


PROJ = fernSurvey2025
DEST = paulshannnon@pshannon.net:public_html/pshannon.net/$(PROJ)

publish:
	scp newMap.html $(DEST)/index.html
	scp map.js $(DEST)
	scp map.css $(DEST)
	scp *.geojson $(DEST)/
	scp *.json $(DEST)/

view:
	@echo disable CORS in chrome
	open http://localhost:$(PORT)/newMap.html

viewRemote:
	open https://pshannon.net/fernSurvey2025


