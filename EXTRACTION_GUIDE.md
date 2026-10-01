1. Remove OOB (tools/cut_off_oob.sh)
2. Use ubireader - https://github.com/onekey-sec/ubi_reader

For squashfs:

```
# Exclude not real files
unsquashfs -ex dev tmp ';' <filename>
```

For zip (to pack and send somewhere):

```
# Don't follow symlink, recursive add
zip --symlinks -r <file.zip> <extracted files>
```

