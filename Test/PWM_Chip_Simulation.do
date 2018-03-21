vsim -gui work.pwm_chip

add wave -position insertpoint  \
sim:/pwm_chip/PWM_SIGNAL \
sim:/pwm_chip/SCL \
sim:/pwm_chip/SDA \
sim:/pwm_chip/i2c_data_out \
sim:/pwm_chip/pwm_enable_signal
add wave -position insertpoint  \
sim:/pwm_chip/I2C/enable \
sim:/pwm_chip/I2C/start
add wave -position insertpoint  \
sim:/pwm_chip/PWM/DUTY_CYCLE \
sim:/pwm_chip/PWM/clk \
sim:/pwm_chip/PWM/high_counter \
sim:/pwm_chip/PWM/low_counter \
sim:/pwm_chip/PWM/start

force -freeze sim:/pwm_chip/SCL 0 0, 1 {50 ps} -r 100
force -freeze sim:/pwm_chip/SDA 1 0

run 100
# Generate start signal
run 75
force -freeze sim:/pwm_chip/SDA 0 0
run 25
noforce sim:/pwm_chip/SDA

# Send the address of the chip "0010001" and "0" for writing

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

# Send the address of the register 0x"00" 

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

# Send the data 0x"F0"

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

# Send the data 0x"F0"

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
