default:
	@echo venv
	@echo server
	@echo view
	@echo publish   # map
	@echo publishData # uwObs.tsv
	@echo viewRemote

venv:
	@echo source /Users/paul/github/slexil2/py3105slexil/bin/activate

PORT=8012

server:
		python -m http.server $(PORT) &

run:
	open http://localhost:$(PORT)/map2.html


PROJ = fernSurvey2025
DEST = paulshannnon@pshannon.net:public_html/pshannon.net/$(PROJ)

publish:
	scp map.html $(DEST)/index.html
	scp *.geojson $(DEST)/
	scp *.json $(DEST)/
	scp uwObs.tsv $(DEST)/

view:
	@echo disable CORS in chrome
	open http://localhost:$(PORT)/map.html

viewBug:
	@echo disable CORS in chrome
	open http://localhost:$(PORT)/map-uwOnly.html

viewRemote:
	open https://pshannon.net/fernSurvey2025

viewBugRemote:
	scp map-uwOnly.html $(DEST)/bug.html
	open https://pshannon.net/fernSurvey2025/bug.html


publishData:
	scp uwObs.tsv paulshannnon@pshannon.net:public_html/pshannon.net/fernSurvey2025/

