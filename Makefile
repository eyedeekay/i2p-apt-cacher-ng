
docker:
	docker build --no-cache -t eyedeekay/i2p-apt-cacher-ng .

run: docker
	docker run --rm -i -t \
		--name i2p-apt-cacher-ng \
		--publish 127.0.0.1:7342:7342 \
		eyedeekay/i2p-apt-cacher-ng

bin:
	@echo '#! /usr/bin/env sh' | tee usr/sbin/i2p-apt-cacher-ng
	@echo '/usr/sbin/apt-cacher-ng $$@' | tee -a usr/sbin/i2p-apt-cacher-ng
	chmod +x usr/sbin/i2p-apt-cacher-ng

SEARCHME="apt-cacher-ng"
EXCLUDEME=thisnevermatchesanything
FILTERME=thisnevermatchesanything

files:
	find ./etc ./lib ./usr ./var -type f -exec grep -Hn $(SEARCHME) {} \; \
		|  grep -v $(EXCLUDEME) \
		| grep -v $(FILTERME)

VERSION=0.1
DEBEMAIL=hankhill19580@gmail.com
NAME=i2p-apt-cacher-ng

gz:
	tar --exclude "./.git" --exclude "./debian" -czvf ../"$(NAME)_$(VERSION).tar.gz" .

debian:
	dh_make -i -n -c mit \
		-e "$(EMAIL)" \
		-p "$(NAME)_$(VERSION)" \

deb: gz
	debuild -us -uc

signed: gz
	debuild

GENMKFILE_PATH ?= /usr/share/genmkfile
GENMKFILE_ROOT_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

export GENMKFILE_PATH
export GENMKFILE_ROOT_DIR

include $(GENMKFILE_PATH)/makefile-full
