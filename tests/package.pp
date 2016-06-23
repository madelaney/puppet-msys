class { 'msys': }

msys::package {
  'vim':
    proxy => 'http://localproxy:8080'
}
