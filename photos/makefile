default:
	@echo sync
	@echo check


sync:
	rsync -a * paulshannnon@pshannon.net:public_html/pshannon.net/photos/fernSurvey2025/

check:
	curl -I https://pshannon.net/photos/fernSurvey2025/larrabee-1/IMG_6292.jpg 2>&1 | grep -i "content-length"

