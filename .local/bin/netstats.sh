#!/usr/bin/env bash
old_rx=0
old_tx=0
tx=0
rx=0

divider=524288
total_divider=107374182

show_internal() {
    value=$(($1 / $2))
    padded_value=$(printf "%02d" "$value")
    formatted_value="${padded_value:0:${#padded_value}-1}.${padded_value: -1}"
    echo $formatted_value
}
show() {
    show_internal $1 $divider
}
show_total() {
    show_internal $1 $total_divider
}

while true; do
    old_rx=$rx
    old_tx=$tx

    rx=$(ifconfig wlan0 | grep 'RX packets' | awk '{print $5}')
    tx=$(ifconfig wlan0 | grep 'TX packets' | awk '{print $5}')

    rx_diff="$(($rx - $old_rx))"
    tx_diff="$(($tx - $old_tx))"

    frx="$(show $rx_diff)"
    ftx="$(show $tx_diff)"

    total_frx="$(show_total $rx)"
    total_ftx="$(show_total $tx)"

    echo "${total_frx}G Trx   ${total_ftx}G Ttx     ${frx}M rx   ${ftx}M tx" > /tmp/netstats

    sleep 5
done
