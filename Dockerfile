FROM eyedeekay/whonix:unstable
#ENV DEBIAN_FRONTEND=noninteractive
USER root
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -yq
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-cacher-ng make
RUN dpkg -L apt-cacher-ng
COPY . /usr/src/i2p-apt-cacher-ng
WORKDIR /usr/src/i2p-apt-cacher-ng
#RUN mkdir -p /lib
RUN make install
RUN sed -i 's|127.0.0.1|0.0.0.0|g' /etc/i2p-apt-cacher-ng/*.conf
CMD /usr/sbin/i2p-apt-cacher-ng -c /etc/i2p-apt-cacher-ng ForeGround=1
