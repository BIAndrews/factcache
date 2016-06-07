require 'spec_helper'

describe 'factcache' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        # this should fail
        context 'with json => string' do
          let(:params) { {:json => 'string test'} }

          it { is_expected.to raise_error(Puppet::Error, /is not a boolean.  It looks to be a String at/) }
        end

        # this should fail
        context 'with yaml => string' do
          let(:params) { {:yaml => 'string test'} }

          it { is_expected.to raise_error(Puppet::Error, /is not a boolean.  It looks to be a String at/) }
        end

        # create both JSON and YAML files and cron jobs
        context "factcache class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('factcache::params') }
          it { is_expected.to contain_class('factcache::install').that_comes_before('factcache') }

          it { is_expected.to contain_class('factcache') }
          it { is_expected.to contain_cron('factcache JSON file') }
          it { is_expected.to contain_cron('factcache YAML file') }
          it { is_expected.to contain_file('/var/cache/facts').with({'ensure' => 'directory','owner' => 'root','group' => 'root','mode' => '0664'}) }
          it { is_expected.to contain_exec('factcache update JSON now') }
          it { is_expected.to contain_exec('factcache update YAML now') }
        end

        # disable YAML file and cron job
        context 'with yaml => false' do
          let(:params) { {:yaml => false} }
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('factcache::params') }
          it { is_expected.to contain_class('factcache::install').that_comes_before('factcache') }

          it { is_expected.to contain_class('factcache') }
          it { is_expected.to contain_cron('factcache JSON file') }
          it { is_expected.to contain_file('/var/cache/facts').with({'ensure' => 'directory','owner' => 'root','group' => 'root','mode' => '0664'}) }
          it { is_expected.to contain_exec('factcache update JSON now') }
        end

        # disable JSON file and cron job
        context 'with json => false' do
          let(:params) { {:json => false} }
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('factcache::params') }
          it { is_expected.to contain_class('factcache::install').that_comes_before('factcache') }

          it { is_expected.to contain_class('factcache') }
          it { is_expected.to contain_cron('factcache YAML file') }
          it { is_expected.to contain_file('/var/cache/facts').with({'ensure' => 'directory','owner' => 'root','group' => 'root','mode' => '0664'}) }
          it { is_expected.to contain_exec('factcache update YAML now') }
        end
      end
    end
  end
end
