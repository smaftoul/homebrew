require 'formula'

class Seeks < Formula
  homepage 'http://www.seeks-project.info/site/'
  head 'git://seeks.git.sourceforge.net/gitroot/seeks/seeks', :branch => 'experimental'
  md5 ''

  depends_on 'autoconf' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'libevent' => :build
  depends_on 'pcre' => :build
  depends_on 'protobuf' => :build
  depends_on 'tokyo-cabinet' => :build

  def patches
    {:p1 => "http://www.seeks-project.info/seeks/patches/osx/osx_iconv.patch"}
  end

  def install
    system "./autogen.sh"
    system "./configure", "--enable-httpserv-plugin", "--disable-opencv",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
    system "sed -i -e 's/^#\(activated-plugin httpserv\)$/\1/' #{prefix}/etc/config"

    plist_path.write startup_plist
    plist_path.chmod 0644
  end

  def startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>#{plist_name}</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <key>ProgramArguments</key>
    <array>
        <string>#{HOMEBREW_PREFIX}/bin/seeks</string>
    </array>
    <key>WorkingDirectory</key>
    <string>#{HOMEBREW_PREFIX}</string>
  </dict>
</plist>
    EOPLIST
  end

  def test
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test seeks`.
    system "false"
  end
end
