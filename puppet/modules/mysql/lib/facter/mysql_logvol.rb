Facter.add(:mysql_logvol) do
  confine :kernel => :linux
  setcode do
    result = :false
    File.readlines('/proc/mounts').each do |line|
      if line =~ %r{^(/dev/\S+) /var/lib/mysql }
        # lvdisplay will exit with zero status iff $1 is an LV
        result = system 'lvdisplay -c $1 >/dev/null 2>/dev/null'
        break
      end
    end
    result
  end
end
