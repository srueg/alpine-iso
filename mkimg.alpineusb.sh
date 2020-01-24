profile_alpineusb() {
    #profile_extended
    profile_standard
    profile_abbrev="usb"
    title="Alpine USB Boot Stick"
    desc="Used for auto setup."
    arch="x86_64"
    hostname="alpine-usb"
    # output_format="custom"
    # kernel_addons="$kernel_addons zfs"
    kernel_flavors="lts"
    kernel_cmdline="console=tty0 console=ttyS0,115200"
    syslinux_serial="0 115200"
    modloop_sign=no
    apks="$apks vim curl tmux htop"
    # apkovl="genapkovl.sh"
}

create_image_custom() {

    prepare_chroot .

    sudo chroot $DESTDIR sh -c "setup-keymap ch ch_de-mac" \
			|| die 'Script failed'

    create_image_iso
}



mount_bind() {
	sudo mkdir -p "$2"
	sudo mount --bind "$1" "$2"
	sudo mount --make-private "$2"
}

prepare_chroot() {
	local dest="$1"

	sudo mkdir -p "$dest"/proc
	sudo mount -t proc none "$dest"/proc
	mount_bind /dev "$dest"/dev
	mount_bind /sys "$dest"/sys

	#install -D -m 644 /etc/resolv.conf "$dest"/etc/resolv.conf
}