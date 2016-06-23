require 'spec_helper'

describe 'msys', :type => :class do
  context "on Any OS" do
    let :facts do
      {
        :id       => 'root',
        :kernel   => 'Windows',
        :osfamily => 'Windows'
      }
    end

    it { is_expected.to contain_class('msys') }
    it { is_expected.to contain_class('msys::params') }
  end

end
