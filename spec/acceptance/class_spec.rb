require 'spec_helper_acceptance'

describe 'factcache class' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work idempotently with no errors' do
      pp = <<-EOS
      class { 'factcache': }
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end
    describe cron("factcache yaml file") do
      it { is_expected.to be_installed }
    end
    describe file('/var/cache/facts') do
      it { is_expected.to be_installed }
    end
  end
end
