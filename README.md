Test clock precision on a FreeSWITCH host
=========================================


Introduction
------------

This is a set of test scripts that verify if the FreeSWITCH host system
has a precise enough clock, so that FreeSWITCH can reliably send RTP
with even intervals. Some versions of KVM and VmWare are known to
deliver poor clock precision.

These scripts are based on the experience gained from FS-7805 issue in
FreeSWITRCH JIRA.


Installing FreeSWITCH on Debian
-------------------------------

The following procedure installs a minimal configuration and the daily
master branch build of FreeSWITCH. You can also install the stable
branch if you remove the "debian-unstable" repository link. Also the
stable branch can be installed on a Wheezy host.

If you prefer not to use the minimal configuration, the default (so
called vanilla) configuration will also work with this test suite.

```
apt-get update && apt-get install -y curl git

cd /etc
git clone https://github.com/voxserv/freeswitch_conf_minimal.git freeswitch

cat >/etc/apt/sources.list.d/freeswitch.list <<EOT
deb http://files.freeswitch.org/repo/deb/debian-unstable/ jessie main
deb http://files.freeswitch.org/repo/deb/debian/ jessie main
EOT

wget -O - https://files.freeswitch.org/repo/deb/debian/key.gpg |apt-key add -

apt-get update && apt-get install -y freeswitch-all
```

Installing this test suite
--------------------------

```
apt-get install -y libmath-vector-real-perl libmath-vector-real-xs-perl
cd /opt
git clone https://github.com/voxserv/test_fs_clock.git
cp /opt/test_fs_clock/999_test_fs_clock.xml /etc/freeswitch/dialplan/public/
fs_cli -x 'reloadxml'
```

The package `libmath-vector-real-xs-perl` is not available, but the
script runs without it too.

Running the test
----------------

```
/opt/test_fs_clock/run_dialer
/opt/test_fs_clock/compare_spectrums /var/tmp/test_fs_clock_*.wav
```

The compare_spectrums script takes the frequency histogram of the first
WAV file and compares it as a vector against histograms of all other WAV
files.

If you see all zeros in Distance output, your clock is perfectly
fine. If you see varying values above zero, it means that FreeSWITCH
does not get a precise clock, and some applications, such as conference,
would suffer from distortions.

After the test is finished, it makes sense to remove the XML from
FreeSWITCH configuration:

```
rm /etc/freeswitch/dialplan/public/999_test_fs_clock.xml
fs_cli -x 'reloadxml'
```

Bad test results
----------------

* Debian Jessie, kernel 3.16.0-4-amd64, in a KVM virtual machine at
digitalocean.com.

* Debian Jessie, kernel 3.16.0-4-amd64, in a VmWare VM at arubacloud.com.

* Debian Wheezy, kernel 3.2.0-4-amd64. VM under Xen version 4.1.2


Good test results
-----------------

* Any modern baremetal host should work fine.

* Debian Jessie, VM under Xen hypervisor version 4.4.2-rc1 (at linode.com).

* Debian Jessie, kernel 4.1.0-x86_64-linode59, VM under KVM hypervisor
at linode.com.



Author
------

Stanislav Sinyagin
ssinyagin@k-open.com


