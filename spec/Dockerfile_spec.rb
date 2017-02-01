require 'docker'
require 'serverspec'

describe 'Dockerfile' do
  before(:all) do
    @image = Docker::Image.build_from_dir('.')

    set :os, family: :ubuntu
    set :backend, :docker
    set :docker_image, @image.id
  end

  describe 'Port "53/udp"' do
    it 'should be exposed' do
      expect(@image.json['ContainerConfig']['ExposedPorts']).to include('53/udp')
    end
  end

  describe 'Port "53/tcp"' do
    it 'should be exposed' do
      expect(@image.json['ContainerConfig']['ExposedPorts']).to include('53/tcp')
    end
  end

  describe package('daemontools') do
    it { is_expected.to be_installed }
  end

  describe package('daemontools-run') do
    it { is_expected.to be_installed }
  end

  describe package('djbdns') do
    it { is_expected.to be_installed }
  end

  describe package('ucspi-tcp') do
    it { is_expected.to be_installed }
  end

  describe user('dnscache') do
    it { should exist }
  end

  describe user('dnslog') do
    it { should exist }
  end

  describe file('/etc/dnsroots.global') do
    it { should be_file }
  end

  describe file('/etc/dnscache') do
    it { should be_directory }
  end

  describe file('/etc/service/dnscache') do
    it { should be_symlink }
  end
end
