#
# Regular cron jobs for the i2p-apt-cacher-ng package
#
0 4	* * *	root	[ -x /usr/bin/i2p-apt-cacher-ng_maintenance ] && /usr/bin/i2p-apt-cacher-ng_maintenance
