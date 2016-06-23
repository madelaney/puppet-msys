require 'spec_helper'

provider_class = Puppet::Type.type(:package).provider(:msys)

PACMAN_QUERY_OUTPUT = %Q{
libp11-kit 0.23.2-1
libpcre 8.38-1
libpcre16 8.38-1
libpcre32 8.38-1
libpcrecpp 8.38-1
libpcreposix 8.38-1
libreadline 6.3.008-7
libsqlite 3.10.0.0-1
libssh2 1.6.0-1
libtasn1 4.7-1
libutil-linux 2.26.2-1
libxml2 2.9.2-2
lndir 1.0.3-1
m4 1.4.17-4
mintty 1~2.2.2-1
mpfr 3.1.3.p0-1
msys2-keyring r9.397a52e-1
msys2-launcher-git 0.3.19.f91905f-1
msys2-runtime 2.4.1.16860.40c26fc-1
ncurses 6.0.20151121-1
openssl 1.0.2.d-1
p11-kit 0.23.2-1
pacman 5.0.0.6348.cc5a8f1-1
pacman-mirrors 20160112-1
pax-git 20140703.2.1.g469552a-1
pcre 8.38-1
pkgfile 15-1
rebase 4.4.1-6
repman-git r23.87bf865-1
sed 4.2.2-2
tftp-hpa 5.2-1
time 1.7-1
tzcode 2015.e-1
util-linux 2.26.2-1
which 2.21-2
xz 5.2.1-1
zlib 1.2.8-3
}

describe provider_class do
  let(:resource) do
    Puppet::Type.type(:package).new(
      :name   => 'myresource',
      :ensure => :installed
    )
  end

  let(:provider) do
    provider = provider_class.new
    provider.resource = resource
    provider
  end

  before :each do
    provider.expects(:execute).never
    resource.provider = provider
  end

  def expect_execute(command, status)
    provider.expects(:execute).with(command, execute_options).returns(Puppet::Util::Execution::ProcessOutput.new('',status))
  end

  describe 'provider features' do
    it { should be_versionable }
    it { should be_uninstallable }
    it { should be_installable }
    it { should be_install_options }
  end

  [:pacman, :parse_pacman_list, :hash_from_line].each do |method|
    it "should respond to the class method #{method}" do
      expect(provider_class).to respond_to(method)
    end
  end

  context '::pacman' do
    it 'should parse a version with patch' do
      pkg = {
        :name => 'tftp-hpa',
        :version => '5.2-1',
        :provider => :msys,
        :ensure => '5.2-1'
      }
      parsed = provider_class.parse_pacman_list(%Q{tftp-hpa 5.2-1})
      expect(parsed).to eq(pkg)
    end

    it 'should parse a version with characters' do
      pkg = {
        :name => 'mintty',
        :version => '1~2.2.2-1',
        :provider => :msys,
        :ensure => '1~2.2.2-1'
      }
      parsed = provider_class.parse_pacman_list(%Q{mintty 1~2.2.2-1})
      expect(parsed).to eq(pkg)
    end

    it 'should parse a version with extended revision' do
      pkg = {
        :name => 'msys2-runtime',
        :version => '2.4.1.16860.40c26fc-1',
        :provider => :msys,
        :ensure => '2.4.1.16860.40c26fc-1'
      }
      parsed = provider_class.parse_pacman_list(%Q{msys2-runtime 2.4.1.16860.40c26fc-1})
      expect(parsed).to eq(pkg)
    end
  end
end
