#!/usr/bin/env python3

import sys
import time
import subprocess
from smbus import SMBus



try:
    i2c = SMBus(1)
    data = i2c.read_i2c_block_data(0x58, 0x80, 16)
    uid = ''.join(map(lambda x:"%02x"%x, data))

    try:
        subprocess.call(["umount", "/etc/machine-id"])
    except:
        pass
    
    id = ""

    while id != uid:
        f = open("/etc/machine-id", "r")
        id = f.read().rstrip()
        f.close()

        if id != uid:
            f = open("/etc/machine-id", "w")
            f.write(uid + "\n")
            f.close()
            print("Changed ID.")
            f = open("/etc/machine-id", "r")
            id = f.read().rstrip()
            f.close()
        else:
            print("ID was the same.")
            break

        time.sleep(5)

except:
    sys.exit(sys.exc_info()[:2])
