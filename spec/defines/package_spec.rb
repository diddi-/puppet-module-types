require 'spec_helper'
describe 'types::package' do

  context 'package with bare minimum specified' do
    let(:title) { 'pkg1' }
    it {
      should contain_package('pkg1').with({
        'ensure'  => 'present',
      })
    }
  end

  context 'package with all options specified' do
    let(:title) { 'pkg1' }
    let(:params) do
      {
        :ensure            => 'installed',
        :adminfile         => '/path/to/adminfile',
        :configfiles       => 'keep',
        :install_options   => '--installoption',
        :provider          => 'yum',
        :responsefile      => '/path/to/responsefile',
        :source            => 'http://source/URL/',
        :uninstall_options => '--uninstall_option',
      }
    end
    let(:facts) { { :osfamily => 'RedHat' } }

    it {
      should contain_package('pkg1').with({
        'ensure'            => 'installed',
        'adminfile'         => '/path/to/adminfile',
        'configfiles'       => 'keep',
        'install_options'   => '--installoption',
        'provider'          => 'yum',
        'responsefile'      => '/path/to/responsefile',
        'source'            => 'http://source/URL/',
        'uninstall_options' => '--uninstall_option',
      })
    }
  end

  context 'package with invalid configfiles' do
    let(:title) { 'pkg1' }
    let(:params) do
      {
        :configfiles       => 'invalid',
      }
    end
    let(:facts) { { :osfamily => 'RedHat' } }

    it 'should fail' do
      expect {
        should contain_class('types')
      }.to raise_error(Puppet::Error,/types::package::pkg1::configfiles is invalid and does not match the regex./)
    end
  end

  context 'package with invalid responsefile' do
    let(:title) { 'pkg1' }
    let(:params) do
      { :responsefile => 'invalid/path' }
    end
    let(:facts) { { :osfamily => 'RedHat' } }

    it 'should fail' do
      expect {
        should contain_class('types')
      }.to raise_error(Puppet::Error,/"invalid\/path" is not an absolute path./)
    end
  end
end
