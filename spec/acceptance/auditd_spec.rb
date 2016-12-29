require 'spec_helper_acceptance'

describe 'auditd' do
  let(:manifest) {
    <<-EOS
      class { 'auditd': }
    EOS
  }

  it 'should run without errors' do
    result = apply_manifest(manifest, :catch_failures => true)
    expect(@result.exit_code).to eq 2
  end
end
