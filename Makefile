dir = $(shell pwd)
container = wikilds

ISCONTAINER = $(shell docker ps -a | grep -c $(container))
ISIMAGE = $(shell docker image ls -a | grep -c grep -c -G Up.*$(container))
ISRUNNING = $(shell docker ps -a | grep -c Up)

ifeq ($(ISCONTAINER), 0)
	ifeq ($(ISIMAGE), 0)
		running = $(MAKE) build && $(MAKE) run
	else
		running = $(MAKE) run-container
	endif
else
	ifeq ($(ISRUNNING), 0)
		running = $(MAKE) start
	else
		running = $(MAKE) restart
	endif
endif

run:
	$(running)

build:
	docker build -t $(container) . --rm 

run-container:
	docker run --name $(container)  \
		-v $(dir)/content/:/data/content/ \
		-v $(dir)/config/config.default.js:/opt/raneto/example/config.default.js \
		-p 3000:3000 -d $(container)

start:
	docker start $(container)

restart:
	docker restart $(container)

stop:
	docker stop $(container)

clear:
	$(MAKE) stop
	docker rm $(container)

restartapp:
	docker exec $(container) pm2 restart $(container)

ssh:
	docker exec -it $(container) /bin/bash
