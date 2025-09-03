PORT = 8055

default:
	@echo venv
	@echo server
	@echo view
	@echo publish
	@echo viewRemote
	@echo wpPublish
	@echo wpViewRemote

json:
	R -f prepTreePoints.R

venv:
	@echo source /Users/paul/github/slexil2/py3105slexil/bin/activate

server:
	python -m http.server $(PORT) &

view:
	open http://localhost:$(PORT)/mapWithTabs.html

DEST = paulshannnon@pshannon.net:public_html/pshannon.net/splitSite2025

publish:
	scp mapWithTabs.html $(DEST)/index.html
	scp map.js $(DEST)/
	scp map.css $(DEST)/
	scp ferns.json $(DEST)/
	scp ferns.tsv $(DEST)/
	scp *.png $(DEST)/

viewRemote:
	open https://pshannon.net/splitSite2025



