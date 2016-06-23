#Cygwin

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

This module installs Msys and adds msys as a package provider in Puppet.

##Module Description

This module will download the msys setup zip file and install it.

##Usage

If you want to use msys as a package provider, it must be installed first.

###Install Msys

```puppet
include '::msys'
```

##Reference

###Classes

####Public Classes

* msys: Main Class, includes all other classes.

####Private Classes

###Parameters

##Limitations

For obvious reasons, this module will only work on the Windows operating system.

##Development

Please see the Puppet guidelines for module contribution. http://projects.puppetlabs.com/projects/module-site/wiki/Module_contributing
