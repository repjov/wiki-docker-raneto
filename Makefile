dir = $(shell pwd)
container = raneto

ISCONTAINER = $(shell docker ps -a | grep -c $(container))

ifeq ($(ISCONTAINER), 0)
	running = $(MAKE) build
else
	running = $(MAKE) start
endif

run:
	$(running)

build:
	docker run --name $(container)  -v $(dir)/content/:/data/content/ -v $(dir)/config/config.default.js:/opt/raneto/example/config.default.js -p 3000:3000 -d appsecco/raneto

start:
	docker start $(container)

stop:
	docker stop $(container)

remove:
	$(MAKE) stop
	docker rm $(container)

restartapp:
	docker exec $(container) pm2 restart raneto

ssh:
	docker exec -it $(container) /bin/bash
