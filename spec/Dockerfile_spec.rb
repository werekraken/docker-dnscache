require 'docker'
require 'serverspec'

describe 'dnscache' do
  before(:all) do
    @image = Docker::Image.build_from_dir('.')

    set :os, family: :ubuntu
    set :backend, :docker
    set :docker_image, @image.id
  end

  describe 'Docker image' do
    it 'should exist' do
      expect(@image).not_to be_nil
    end
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

  describe 'Command "svscan"' do
    it 'should be configured' do
      expect(@image.json['ContainerConfig']['Cmd']).to include(/svscan/)
    end
  end

  describe 'Volume "/dnscache"' do
    it 'should be configured' do
      expect(@image.json['ContainerConfig']['Volumes']).to include('/dnscache')
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

  describe file('/dnscache') do
    it { should be_directory }
  end

  describe file('/dnscache/ip') do
    it { should be_directory }
  end

  describe file('/dnscache/ip/127.0.0.1') do
    it { should be_file }
  end

  describe file('/dnscache/servers') do
    it { should be_directory }
  end

  describe file('/dnscache/servers/@') do
    it { should be_file }
  end

  describe file('/etc/dnscache/root/ip') do
    it { should be_symlink }
  end

  describe file('/etc/dnscache/root/servers') do
    it { should be_symlink }
  end

  describe process('svscan') do
    it { should be_running }
  end

  describe process('dnscache') do
    it { should be_running }
  end
end
