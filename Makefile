
install:
	mkdir -p /etc/i2pd/tunnels.d \
		/etc/i2p-apt-cacher-ng \
		/lib/systemd/system \
		/usr/lib/i2p-apt-cacher-ng \
		/var/lib/i2p-apt-cacher-ng
	cp etc/i2pd/tunnels.d/apt-cacher-ng.conf /etc/i2pd/tunnels.d/apt-cacher-ng.conf
	cp etc/logrotate.d/i2p-apt-cacher-ng /etc/logrotate.d/i2p-apt-cacher-ng
	cp etc/cron.daily/i2p-apt-cacher-ng /etc/cron.daily/i2p-apt-cacher-ng
	cp etc/init.d/i2p-apt-cacher-ng /etc/init.d/i2p-apt-cacher-ng
	cp etc/default/i2p-apt-cacher-ng /etc/default/i2p-apt-cacher-ng
	cp etc/i2p-apt-cacher-ng/zz_debconf.conf /etc/i2p-apt-cacher-ng/zz_debconf.conf
	cp etc/i2p-apt-cacher-ng/backends_maintainers /etc/i2p-apt-cacher-ng/backends_maintainers
	cp etc/i2p-apt-cacher-ng/backends_invisiblec /etc/i2p-apt-cacher-ng/backends_invisiblec
	cp etc/i2p-apt-cacher-ng/backends_invisible /etc/i2p-apt-cacher-ng/backends_invisible
	cp etc/i2p-apt-cacher-ng/backends_community /etc/i2p-apt-cacher-ng/backends_community
	cp etc/i2p-apt-cacher-ng/acng.conf /etc/i2p-apt-cacher-ng/acng.conf
	cp etc/i2p-apt-cacher-ng/security.conf /etc/i2p-apt-cacher-ng/security.conf
	chown root:apt-cacher-ng /etc/i2p-apt-cacher-ng/security.conf
	cp lib/systemd/system/i2p-apt-cacher-ng.service /lib/systemd/system/i2p-apt-cacher-ng.service
	cp usr/lib/i2p-apt-cacher-ng/delconfirm.html /usr/lib/i2p-apt-cacher-ng/delconfirm.html
	cp usr/lib/i2p-apt-cacher-ng/report.html /usr/lib/i2p-apt-cacher-ng/report.html
	cp usr/lib/i2p-apt-cacher-ng/style.css /usr/lib/i2p-apt-cacher-ng/style.css
	cp usr/lib/i2p-apt-cacher-ng/backends_maintainers /usr/lib/i2p-apt-cacher-ng/backends_maintainers
	cp usr/lib/i2p-apt-cacher-ng/backends_invisiblec /usr/lib/i2p-apt-cacher-ng/backends_invisiblec
	cp usr/lib/i2p-apt-cacher-ng/backends_invisible /usr/lib/i2p-apt-cacher-ng/backends_invisible
	cp usr/lib/i2p-apt-cacher-ng/maint.html /usr/lib/i2p-apt-cacher-ng/maint.html
	cp usr/lib/i2p-apt-cacher-ng/userinfo.html /usr/lib/i2p-apt-cacher-ng/userinfo.html
	cp usr/lib/i2p-apt-cacher-ng/backends_community /usr/lib/i2p-apt-cacher-ng/backends_community
	cp usr/sbin/i2p-apt-cacher-ng /usr/sbin/i2p-apt-cacher-ng
	cp var/lib/i2p-apt-cacher-ng/backends_debian.default /var/lib/i2p-apt-cacher-ng/backends_debian.default
	cp var/lib/i2p-apt-cacher-ng/backends_ubuntu.default /var/lib/i2p-apt-cacher-ng/backends_ubuntu.default


docker:
	docker build --no-cache -t eyedeekay/i2p-apt-cacher-ng .

run: docker
	docker run --rm -i -t -d \
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
	tar --exclude "./.git" --exclude "./debian" --exclude "*.png" -czvf ../"$(NAME)_$(VERSION).tar.gz" .

debian:
	dh_make -i -n -c mit \
		-e "$(EMAIL)" \
		-p "$(NAME)_$(VERSION)" \

deb: gz
	debuild -us -uc

signed: gz
	debuild

debclean:
	 dpkg-buildpackage -rfakeroot -Tclean
