#!/bin/python3

import socket
import json
import csv

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.bind(('', 13372))

buf = b''
freqs = {}
while True:
    message, server = s.recvfrom(1024)
    buf += message

    try:
        data = json.loads(buf.decode('utf-8'))

        freq = data["vdl2"]["freq"]

        try:
            freqs[freq] += 1
        except KeyError:
            freqs[freq] = 1
        
        with open("/data/freqs.csv", "w",) as file:
            writer = csv.writer(file)
            
            for f, n in freqs.items():
                writer.writerow([f, n])

        buf = b''

    except ValueError:
        continue
    
