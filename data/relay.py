#!/bin/python3

import socket
import json

s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
s.bind(('', 13372))

buf = b''
while True:
    message, server = s.recvfrom(1024)
    buf += message

    try:
        data = json.loads(buf.decode('utf-8'))
        
        # uncomment to write received data to disk
        # with open("/data/planejson.log", "a",) as file:
            # file.write(json.dumps(data))
            # file.write('\n')

        buf = b''

    except ValueError:
        continue
    
