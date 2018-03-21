vsim -gui work.i2c_interface
# vsim -gui work.i2c_interface 
# Start time: 21:33:59 on Mar 19,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.my_package
# Loading work.i2c_interface(i2c_interface_arch)
add wave -position insertpoint  \
sim:/i2c_interface/ACK \
sim:/i2c_interface/CHIP_ADDRESS \
sim:/i2c_interface/CHIP_CHOSEN \
sim:/i2c_interface/DATA_OUT \
sim:/i2c_interface/ENABLE \
sim:/i2c_interface/PWM_BUFFER_BYTE_SIZE \
sim:/i2c_interface/PWM_BYTE_READ_COUNT \
sim:/i2c_interface/PWM_SHIFT_REGISTER \
sim:/i2c_interface/REGISTER_ADDRESS \
sim:/i2c_interface/REGISTER_CHOSEN \
sim:/i2c_interface/SCL \
sim:/i2c_interface/SDA \
sim:/i2c_interface/SHIFT_REGISTER \
sim:/i2c_interface/START \
sim:/i2c_interface/WRITE_SIGNAL \
sim:/i2c_interface/PWM_INITIALIZATION_COMPLETE

force -freeze sim:/i2c_interface/SCL 0 0, 1 {50 ps} -r 100
force -freeze sim:/i2c_interface/SDA 1 0

run 100

run 75
force -freeze sim:/i2c_interface/SDA 0 0
run 25
noforce sim:/i2c_interface/SDA

force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 1 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 1 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
noforce sim:/i2c_interface/SDA
run 100


force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
noforce sim:/i2c_interface/SDA
run 100


force -freeze sim:/i2c_interface/SDA 1 0
run 100
force -freeze sim:/i2c_interface/SDA 1 0
run 100
force -freeze sim:/i2c_interface/SDA 1 0
run 100
force -freeze sim:/i2c_interface/SDA 1 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
noforce sim:/i2c_interface/SDA
run 100

force -freeze sim:/i2c_interface/SDA 1 0
run 100
force -freeze sim:/i2c_interface/SDA 1 0
run 100
force -freeze sim:/i2c_interface/SDA 1 0
run 100
force -freeze sim:/i2c_interface/SDA 1 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
force -freeze sim:/i2c_interface/SDA 0 0
run 100
noforce sim:/i2c_interface/SDA
run 100





