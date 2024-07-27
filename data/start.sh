#!/bin/sh

chmod +x /data/relay.py

/data/relay.py &
dumpvdl2 \
	--rtlsdr $DONGLE \
	--gain $GAIN \
	--correction $CORRECTION \
	--centerfreq $CENTERFREQ \
	--addrinfo $ADDRINFO \
	$(echo $OUTPUT | sed "s/;/\n/g" | awk '{ print "--output " $0 }') \
	$(echo $FREQS | sed "s/;/ /g")

