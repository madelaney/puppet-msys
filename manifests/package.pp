define msys::package(
  $ensure = 'present'
) {
  package {
    $name:
      ensure   => $ensure,
      provider => 'msys';
  }
}
