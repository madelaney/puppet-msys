define msys::package(
  $ensure = 'present',
  $proxy  = $::msys::proxy
) {
  package {
    $name:
      ensure   => $ensure,
      provider => 'msys';
  }
}
