FROM debian:latest

RUN apt-get update && \
	apt-get install -y \
		build-essential \
		cmake \
		git \
		kmod \
		libglib2.0-dev \
		librtlsdr-dev \
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

CMD dumpvdl2 \
	--rtlsdr $DONGLE \
	--gain $GAIN \
	--correction $CORRECTION \
	--centerfreq $CENTERFREQ \
	--addrinfo $ADDRINFO \
	$(echo $OUTPUT | sed "s/,/\n/g" | awk '{ print "--output " $0 }') \
	$(echo $FREQS | sed "s/,/ /g")
