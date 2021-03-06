#!/usr/bin/env python

import sys
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

    with open("/etc/machine-id", "w") as f:
        f.write(uid + "\n")
except:
    sys.exit(sys.exc_info()[:2])
