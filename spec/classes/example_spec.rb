require 'spec_helper'

describe 'factcache' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "factcache class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('factcache::params') }
          it { is_expected.to contain_class('factcache::install').that_comes_before('factcache') }

          it { is_expected.to contain_class('factcache') }
        end
      end
    end
  end

end
