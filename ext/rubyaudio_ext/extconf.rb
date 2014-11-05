require 'mkmf'

$CFLAGS.gsub!("-arch i386", "")
$LDFLAGS.gsub!("-arch i386", "")

dir_config('sndfile')

# Mega-Nerd windows installer installs as libsndfile-1.dll
if RUBY_PLATFORM =~ /(mswin|mingw|cygwin)/
  sndfile_lib = 'sndfile-1'
else
  sndfile_lib = 'sndfile'
end

INCLUDE_DIRS = ['vendor/libsndfile/include', '/app/local/include', '/opt/local/include', '/usr/local/include']
LIB_DIRS = ['vendor/libsndfile/lib', '/app/local/lib', '/opt/local/lib', '/usr/local/lib']

# libsndfile requirements
find_header 'sndfile.h', *INCLUDE_DIRS
unless ['sndfile-1', 'sndfile'].any? {|lib| find_library lib, 'sf_open', *LIB_DIRS}
  fail <<-EOM
  Can't find libsndfile (http://www.mega-nerd.com/libsndfile/)

  Try passing --with-sndfile-dir or --with-sndfile-lib and --with-sndfile-include
  options to extconf. If there are spaces in the path on windows, it may not work.
  EOM
end

# Check for format support
have_const('SF_FORMAT_OGG', 'sndfile.h')

create_makefile 'rubyaudio_ext'
