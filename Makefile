dir = $(shell pwd)
container = wikilds
config_path = $(dir)/config/config.default.js
conent_path = $(dir)/content/


run:
	./script.sh run --content=$(conent_path) --config=$(config_path)

clear:
	./script.sh clear

restartapp:
	./script.sh app_restart

ssh:
	docker exec -it $(container) /bin/bash
