class msys::params {
  $version = 20160205

  $target = $::architecture ? {
    'x64'    => 'msys64',
    default  => 'msys32'
  }

  $installer_arch = $::architecture ? {
    'x64'   => 'x86_64',
    default => 'i686'
  }

  $installer_source = 'https://sourceforge.net/projects/msys2/files/Base/'
}
