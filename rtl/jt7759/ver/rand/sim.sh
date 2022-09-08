#!/bin/bash

TOP=jt7759

verilator -F ../../hdl/jt7759.f -cc test.cpp -exe --top-module $TOP \
    --trace -DDEBUG --timescale 1ns/1ps || exit $?
export CPPFLAGS="$CPPFLAGS -O3"


if ! make -j -C obj_dir -f V${TOP}.mk V${TOP} > make.log; then
    cat make.log
    exit 1
else
    rm make.log
fi

obj_dir/V$TOP
sed -i "s/timescale 1ps/timescale 1ns/" test.vcd