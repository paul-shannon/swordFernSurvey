default:
	@echo venv
	@echo run
	@echo publish
	@echo runRemote


venv:
	@echo source /Users/paul/github/slexil2/py3105slexil/bin/activate

run:
	python app.py

publish:
	scp googleApiTest.html paulshannnon@pshannon.net:public_html/pshannon.net/survey/

runRemote:
	open https://pshannon.net/survey/googleApiTest.html



