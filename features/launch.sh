#!/bin/bash

{ time cmake -B build >/dev/null && cmake --build build >/dev/null; } |& grep real | sed -E 's/[^0-9\.]+//g' | tr -d '\n' |
    (cat && echo " * 1000") | bc | xargs printf "Build completed in %.2f ms\n\n"

{ time ./build/app >/dev/tty; } |& grep real | sed -E 's/[^0-9\.]+//g' | tr -d '\n' |
    (cat && echo " * 1000") | bc | xargs printf "\nProgram executed in %.2f ms\n"
