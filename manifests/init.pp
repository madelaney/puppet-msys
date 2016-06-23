class msys(
  $ensure           = 'present',
  $proxy            = undef,
  $packages         = {},
  $target           = $::msys::target,
  $version          = $::msys::version,
  $proxy            = nil,
  $installer_arch   = $::msys::installer_arch,
  $installer_source = $::msys::source_url
) inherits ::msys::params {

  # NOTE: (mdelaney)
  # Even though the Qt Install can be automated, because this is happening within
  # a service session, in Windows, we do not have access to a UI so the installer
  # and the aforemention automation does not work.
  #
  # To make this work, I had to:
  # * download the LZMA version of the release.
  # * decomress from LZMA
  # * repackage as a zip
  #
  # We should try to get LZMA support within Puppet so we can download straight
  # from SourceForge
  #
  validate_re($installer_arch, ['i686', 'x64'])

  $package_name = "msys2-base-${installer_arch}-${version}.zip"
  staging::deploy {
    $package_name:
      source  => "${installer_source}/${package_name}",
      creates => "C:\\${target}",
      target  => 'C:\\',
      notify  => Exec["Bootstrap ${package_name}"];
  }

  exec {
    "Bootstrap ${package_name}":
      command     => "C:\\${target}\\msys2.exe",
      cwd         => "C:\\${target}",
      refreshonly => true;
  }

  if $packages != {} {
    create_resources('msys::package', $packages)
  }
}