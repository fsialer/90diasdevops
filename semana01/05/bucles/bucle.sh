#!/bin/bash
for i in {1..5}; do
  echo "Número: $i"
done

contador=1
while [ $contador -le 3 ]; do # -le es menor igual que -lt es menor que
  echo "Contador: $contador"
  ((contador++))
done