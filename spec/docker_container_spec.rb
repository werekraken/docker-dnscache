require 'spec_helper'

describe 'docker container' do
  before(:all) do
    set :os, family: :ubuntu
    set :backend, :docker
    set :docker_image, image.id
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

  describe file('/etc/dnscache/root/ip') do
    it { should be_directory }
  end

  describe file('/etc/dnscache/root/ip/127.0.0.1') do
    it { should be_file }
  end

  describe file('/etc/dnscache/root/servers') do
    it { should be_directory }
  end

  describe file('/etc/dnscache/root/servers/@') do
    it { should be_file }
  end

  describe process('svscan') do
    it { should be_running }
  end

  describe process('dnscache') do
    it { should be_running }
  end

  describe port(53) do
    it { should be_listening.on('0.0.0.0').with('udp') }
    it { should be_listening.on('0.0.0.0').with('tcp') }
  end
end
