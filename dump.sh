#!/bin/sh

set -e
set -o pipefail

# The script expects OpenWRT host with correct mtd partitions
if [[ "$#" -ne 2 ]]; then
	echo "Usage: $0 <hostname/ipaddr> <board name>"
	exit 1
fi

HOST="$1"
ROUTER="$2"

UBI_MTD_NUM=""

function cmd() {
	ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR root@"$HOST" $@
}

# Note - the function doesn't save mtd addresses.
# You will need correct partitioning to restore it
function dump_mtd() {
	proc_mtd="$(cmd 'cat /proc/mtd')"
	echo "$proc_mtd" > "$ROUTER"/proc_mtd
	# Skip header line
	mtds="$(echo "$proc_mtd" | awk -F' ' '{ if (FNR > 1) print $1}' | tr -d ':')"

	for mtd in $mtds; do
		cmd "nanddump --oob /dev/$mtd" | gzip > "$ROUTER"/"$mtd".nand.gz
	done
}
function restore_mtd() {
	# Sort isn't actually needed, but that is what user might expect
	mtds="$(find "$ROUTER" -name 'mtd*.nand.gz' -printf '%f\n' | sort | sed -E 's/(mtd[0-9]+).nand.gz/\1/')"

	for mtd in $mtds; do
		if cmd "mtd erase /dev/$mtd"; then
			# --noecc is questionable
			cat "$ROUTER"/"$mtd".nand.gz | gunzip | cmd "nandwrite --noecc --skip-all-ffs --oob /dev/$mtd -"
		else
			echo "Write to '$mtd' failed; consider it read-only"
		fi
	done
}

if echo "$0" | grep -qw dump; then
	mkdir -p "$ROUTER"

	dump_mtd
elif echo "$0" | grep -qw restore; then
		if [[ ! -d "$ROUTER" ]]; then
		echo "No '$ROUTER' dumps found"
		exit 1
	fi

	restore_mtd
else
	echo "Script name must be either 'dump' or 'restore'!"
	exit 1
fi

