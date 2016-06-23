# Mike Delaney <mike@mldelaney.io>
#
require 'puppet/provider/package'
require 'puppet/util/package'

Puppet::Type.type(:package).provide(:msys, :parent => Puppet::Provider::Package) do
  desc 'Install a package via Pacman (msys2/mingw)'
  confine :operatingsystem => :windows

  has_feature :versionable
  has_feature :uninstallable
  has_feature :installable
  has_feature :install_options
  has_feature :source

  attr_reader :install_dir

  self::REGEX = /^([\S]+)\s+(.*)$/
  self::FIELDS = [:name, :version].freeze

  # install_dir
  #
  # This is a bit rough because msys can really be installed anywhere
  # on the file system and there's no matching registry entry to help
  # us detect where it is.
  #
  def self.install_dir
    begin
      ['C:\\msys32', 'C:\\msys64'].each do |loc|
        @install_dir = loc if File.exist? loc
      end

    rescue StandardError => e
      Puppet.debug e

    end

    @install_dir
  end

  # pacman
  #
  # Executes a command against pacman and returns
  # the output
  #
  def self.pacman(*args)
    pacman_cmd = File.join install_dir, 'bin', 'pacman.exe'
    cmd = [pacman_cmd] + args
    Puppet::Util::Execution.execute(cmd)
  end

  # parse_pacman_list
  #
  # Shortcut method to parse a line from pacman -Q
  #
  def self.parse_pacman_list(line)
    hash_from_line(line, self::REGEX, self::FIELDS)
  end

  # hash_from_line
  #
  # Takes a line from stdout and using the regular expression,
  # try to extract the fields from the output.
  #
  def self.hash_from_line(line, regex, fields)
    line.strip!
    hash = {}

    begin
      if match = regex.match(line)
        fields.zip(match.captures) { |f, v| hash[f] = v }
        hash[:provider] = name
        hash[:ensure] = hash[:version]
      end

    rescue StandardError => e
      Puppet.debug "Failed to parse line: #{line}"
      Puppet.debug e
    end

    hash
  end

  # instances
  #
  # Returns all instances of packages, due to Cygwin, this only actually
  # returns the installed packages.
  #
  def self.instances
    packages = []
    packman('-Q').each_line do |line|
      if hash = parse_pacman_list(line)
        packages << new(hash) unless hash.empty?
      end
    end
    packages
  end

  # query
  #
  # Get the current status of a package, if the package is not found
  # we'll return a simple hash that just has 'ensure' set to ':absent'
  #
  def query
    @property_hash = { :ensure => :absent }

    begin
      self.class.pacman('-Q', self.name).each_line do |line|
        line.strip!
        hash = self.class.parse_pacman_list(line)
        @property_hash = hash unless hash.empty?
      end

    rescue StandardError => e
      Puppet.debug e

    end

    @property_hash
  end

  def uninstall
    status = query
    return if status[:ensure] == :absent

    flags = ['-R', get(:name)]
    self.class.pacman(flags)
  end

  def install
    raise 'You must provide the name of the package to install' if
      @resource[:name].nil?

    flags = ['-S', name]
    unless @resource[:install_options].nil?
      flags << @resource[:install_options]
    end

    unless source = @resource[:source]
      flags = flags.concat ['-s', source]
    end

    self.class.pacman(flags)
  end
end
