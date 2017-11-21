require 'spec_helper_acceptance'

describe 'xdmod class:' do
  context 'supremm enabled' do
    it 'should run successfully' do
      pp =<<-EOS
      host { 'xdmod.localdomain': ip => '127.0.0.1' }
      class { 'xdmod':
        supremm             => true,
        enable_supremm      => true,
        apache_vhost_name   => 'xdmod.localdomain',
        supremm_database    => true,
        resources           => [{
          'resource' => 'example',
          'name' => 'Example',
          'resource_id' => 1,
          'pcp_log_dir' => '/data/pcp-data/example',
        }],
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      # MongoDB password constantly changes on EL6
      if fact('operatingsystemmajrelease') != '6'
        apply_manifest(pp, :catch_changes => true)
      end
    end

    it_behaves_like 'xdmod-supremm', default
  end
end
