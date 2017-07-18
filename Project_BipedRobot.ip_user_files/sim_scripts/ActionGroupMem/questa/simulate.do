onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib ActionGroupMem_opt

do {wave.do}

view wave
view structure
view signals

do {ActionGroupMem.udo}

run -all

quit -force
