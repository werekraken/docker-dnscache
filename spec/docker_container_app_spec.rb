require 'spec_helper'

describe 'docker container app' do
  before(:all) do
    set :os, family: :ubuntu
    set :backend, :docker
    set :docker_image, image.id

    Specinfra::Runner.run_command('echo "nameserver 127.0.0.1" > /etc/resolv.conf')
  end

  describe file('/etc/resolv.conf') do
    it { should be_file }
    its(:content) { should eq "nameserver 127.0.0.1\n" }
  end

  describe command('dnsip google-public-dns-a.google.com') do
    its(:stdout)      { should match '8.8.8.8' }
    its(:exit_status) { should eq 0 }
  end
end
