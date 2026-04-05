#!/bin/bash

build_time=$({ time { cmake -B build -DCMAKE_COLOR_DIAGNOSTICS=ON >/dev/null && cmake --build build >build_log 2>&1; }; } 2>&1)
status=$?

if [ $status -ne 0 ]; then
    echo "-- (!!) Build failed"
    cat build_log
    rm build_log
    exit $status
fi

rm build_log

echo "$build_time" | grep real | sed -E 's/[^0-9\.]+//g' | tr -d '\n' |
    (cat && echo " * 1000") | bc | xargs printf "-- Build completed in %.2f ms\n\n"

{ time ./build/app >/dev/tty; } |& grep real | sed -E 's/[^0-9\.]+//g' | tr -d '\n' |
    (cat && echo " * 1000") | bc | xargs printf "\n-- Program executed in %.2f ms\n"
