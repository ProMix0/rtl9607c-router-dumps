#!/bin/sh
# dump_cut_oob.sh script by xeros
# Source code released under GPL License

# this script is just for testing purpose for partition images creation from nanddump dumps

# DO NOT FLASH SUCH CONVERTED IMAGES

# Taken from https://github.com/openlgtv/lgmod_bcm/blob/master/OpenLGTV_BCM-src/scripts/dump_cut_oob.sh

data_block_size=2048
oob_block_size=64

ifile=$1
[ ! -f "$ifile" ] && echo "ERROR: missing input file: $1" && exit 1
ofile=$ifile.without_oob
obs=$data_block_size
ibs=$(($data_block_size+$oob_block_size))
size=`wc -c $ifile | cut -d' ' -f1`
nblocks=$(($size/$ibs))
[ -f "$ofile" ] && rm -f $ofile
i=0
while [ "$i" -lt "$nblocks" ]
do
    dd if=$ifile ibs=$ibs skip=$i count=1 2>/dev/null | head -c $obs >> $ofile
    i=$(($i+1))
done

