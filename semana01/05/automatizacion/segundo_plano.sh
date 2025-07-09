#!/bin/bash
proceso_largo() {
    sleep 5
    echo "Proceso completado"
}
proceso_largo &
pid=$!
wait $pid