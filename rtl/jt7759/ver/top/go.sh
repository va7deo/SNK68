#!/bin/bash

iverilog test.v ../../hdl/*.v -o sim -s test -DSIMULATION && sim -lxt
