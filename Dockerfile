FROM debian:latest

RUN apt-get update && \
	apt-get install -y \
		build-essential \
		cmake \
		git \
		kmod \
		libglib2.0-dev \
		librtlsdr-dev \
		libzmq3-dev \
		pkg-config \
		rtl-sdr

# Install SDR RTL drivers
RUN echo "blacklist dvb_usb_rtl28xxu" > /etc/modprobe.d/blacklist-dvb.conf

# Compile libacars
WORKDIR /repos
RUN git clone https://github.com/szpajder/libacars.git && \
	cd libacars && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make -j && \
	make install && \
	ldconfig && \
	cd /repos && \
	rm -r libacars

# Compile dumpvdr2
WORKDIR /repos
RUN git clone https://github.com/szpajder/dumpvdl2.git && \
	cd dumpvdl2 && \
	mkdir build && \
	cd build && \
	cmake .. && \
	make -j && \
	make install && \
	cd /repos && \
	rm -r dumpvdl2

CMD sh /data/start.sh
