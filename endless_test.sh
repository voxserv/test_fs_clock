while true; do
  /opt/test_fs_clock/run_dialer
  /opt/test_fs_clock/compare_spectrums /var/tmp/test_fs_clock_*.wav
done
