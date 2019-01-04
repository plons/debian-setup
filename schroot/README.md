Initial install:

su
apt-get install debootstrap schroot
mkdir ~/chroot_wheezy
debootstrap wheezy ~/chroot_wheezy http://httpredir.debian.org/debian/
cp schroot.conf /etc/schroot/schroot.conf
cp -r darwyn/ /etc/schroot/

# In chroot
schroot
adduser peter
