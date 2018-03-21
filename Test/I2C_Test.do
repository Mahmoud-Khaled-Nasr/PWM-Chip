vsim -gui work.i2c_interface

add wave -position insertpoint  \
sim:/i2c_interface_module/CHIP_ADDRESS \
sim:/i2c_interface_module/DATA_OUT \
sim:/i2c_interface_module/PWM_BUFFER_BIT_SIZE \
sim:/i2c_interface_module/PWM_BUFFER_BYTE_SIZE \
sim:/i2c_interface_module/PWM_ENABLE \
sim:/i2c_interface_module/REGISTER_ADDRESS \
sim:/i2c_interface_module/SCL \
sim:/i2c_interface_module/SDA \
sim:/i2c_interface_module/WRITE_SIGNAL \
sim:/i2c_interface_module/ack \
sim:/i2c_interface_module/chip_chosen \
sim:/i2c_interface_module/enable \
sim:/i2c_interface_module/pwm_byte_read_count \
sim:/i2c_interface_module/pwm_shift_register \
sim:/i2c_interface_module/register_chosen \
sim:/i2c_interface_module/shift_register \
sim:/i2c_interface_module/start

force -freeze sim:/i2c_interface/SCL 0 0, 1 {50 ps} -r 100
force -freeze sim:/i2c_interface/SDA 1 0

run 100
# Generate start signal
run 75
force -freeze sim:/i2c_interface/SDA 0 0
run 25
noforce sim:/i2c_interface/SDA

# Send the address of the chip "0010001" and "0" for writing

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

# Send the address of the register 0x"00"

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

# Send the data 0x"F0"

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

# Send the data 0x"F0"

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





