from smbus import SMBus

i2c = SMBus(1)
data = i2c.read_i2c_block_data(0x58, 0x80, 16)
uid = ''.join(map(lambda x:"%02x"%x, data))
print(uid)
