require 'spec_helper'

describe 'msys::package', :type => :define do
  let :pre_condition do
    'class { "msys": } '
  end

  let :title do
    'msys.example.com'
  end

  let :default_params do
    {
      :proxy => 'http://corpproxy:8090'
    }
  end

  describe 'simple setup' do
    context 'has necessary requirements' do
      let :default_facts do
        {
          :caller_module_name => 'msys',
          :osfamily => 'Windows',
          :kernel   => 'Windows',
          :is_pe    => false
        }
      end

      let :params do default_params end
      let :facts do default_facts end

      it { is_expected.to contain_class('msys') }
    end
  end
end
