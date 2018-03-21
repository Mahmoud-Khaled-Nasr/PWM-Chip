vsim -gui work.pwm_chip
# vsim -gui work.pwm_chip 
# Start time: 21:28:59 on Mar 20,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.pwm_chip(pwm_chip_arch)
# Loading work.i2c_interface_module(i2c_interface_arch)
# Loading work.pwm_module(pwm_module_arch)
add wave -position insertpoint  \
sim:/pwm_chip/I2C_DATA_OUT \
sim:/pwm_chip/PWM_ENABLE_SIGNAL \
sim:/pwm_chip/PWM_SIGNAL \
sim:/pwm_chip/SCL \
sim:/pwm_chip/SDA
add wave -position insertpoint  \
sim:/pwm_chip/I2C/ENABLE \
sim:/pwm_chip/I2C/START
add wave -position insertpoint  \
sim:/pwm_chip/PWM/CLK \
sim:/pwm_chip/PWM/DUTY_CYCLE \
sim:/pwm_chip/PWM/HIGH_COUNTER \
sim:/pwm_chip/PWM/LOW_COUNTER \
sim:/pwm_chip/PWM/START

force -freeze sim:/pwm_chip/SCL 0 0, 1 {50 ps} -r 100
force -freeze sim:/pwm_chip/SDA 1 0

run 100

run 75
force -freeze sim:/pwm_chip/SDA 0 0
run 25
noforce sim:/pwm_chip/SDA

force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 1 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 1 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
noforce sim:/pwm_chip/SDA
run 100


force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
noforce sim:/pwm_chip/SDA
run 100


force -freeze sim:/pwm_chip/SDA 1 0
run 100
force -freeze sim:/pwm_chip/SDA 1 0
run 100
force -freeze sim:/pwm_chip/SDA 1 0
run 100
force -freeze sim:/pwm_chip/SDA 1 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
noforce sim:/pwm_chip/SDA
run 100

force -freeze sim:/pwm_chip/SDA 1 0
run 100
force -freeze sim:/pwm_chip/SDA 1 0
run 100
force -freeze sim:/pwm_chip/SDA 1 0
run 100
force -freeze sim:/pwm_chip/SDA 1 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
force -freeze sim:/pwm_chip/SDA 0 0
run 100
noforce sim:/pwm_chip/SDA
run 100
