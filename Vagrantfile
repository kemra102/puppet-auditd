nodes = [
  { :hostname => 'centos70pe',   :ip => '192.168.72.2',  :box => 'puppetlabs/centos-7.0-64-puppet-enterprise' },
  { :hostname => 'centos70',     :ip => '192.168.72.3',  :box => 'puppetlabs/centos-7.0-64-puppet' },
  { :hostname => 'centos66',     :ip => '192.168.72.4',  :box => 'puppetlabs/centos-6.6-64-puppet' },
  { :hostname => 'centos511',    :ip => '192.168.72.5',  :box => 'puppetlabs/centos-5.11-64-puppet' },
  { :hostname => 'ubuntu1404pe', :ip => '192.168.72.6',  :box => 'puppetlabs/ubuntu-14.04-64-puppet-enterprise' },
  { :hostname => 'ubuntu1404',   :ip => '192.168.72.7',  :box => 'puppetlabs/ubuntu-14.04-64-puppet' },
  { :hostname => 'ubuntu1204',   :ip => '192.168.72.8',  :box => 'puppetlabs/ubuntu-12.04-64-puppet' },
  { :hostname => 'debian78pe',   :ip => '192.168.72.9',  :box => 'puppetlabs/debian-7.8-64-puppet-enterprise' },
  { :hostname => 'debian78',     :ip => '192.168.72.10',  :box => 'puppetlabs/debian-7.8-64-puppet' },
  { :hostname => 'debian6010',   :ip => '192.168.72.11', :box => 'puppetlabs/debian-6.0.10-64-puppet' },
]

Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = node[:box]
      nodeconfig.vm.hostname = node[:hostname] + ".box"
      nodeconfig.vm.network :private_network, ip: node[:ip]

      memory = node[:ram] ? node[:ram] : 256;
      nodeconfig.vm.provider :virtualbox do |vb|
        vb.customize [
          "modifyvm", :id,
          "--cpuexecutioncap", "50",
          "--memory", memory.to_s,
        ]
      end
    end
  end

  config.vm.provision :shell do |shell|
    script = "mkdir -p /etc/puppetlabs/code/environments/production/modules/auditd;" +
    "cp -r /vagrant/* /etc/puppetlabs/code/environments/production/modules/auditd/;" +
    "puppet module --modulepath=/etc/puppetlabs/code/environments/production/modules/ install puppetlabs/concat --version=1.2.4;" +
    'export PATH=$PATH:/opt/puppetlabs/puppet/bin;' +
    'export MODULEPATH=/etc/puppetlabs/code/environments/production/modules/;' +
    "puppet apply --pluginsync --modulepath=$MODULEPATH \"$MODULEPATH\"auditd/tests/init.pp;" +
    "puppet apply --pluginsync --modulepath=$MODULEPATH \"$MODULEPATH\"auditd/tests/audisp_syslog.pp;" +
    "puppet apply --pluginsync --modulepath=$MODULEPATH \"$MODULEPATH\"auditd/tests/audisp_af_unix.pp;" +
    "puppet apply --pluginsync --modulepath=$MODULEPATH \"$MODULEPATH\"auditd/tests/audisp_au_remote.pp;" +
    "puppet apply --pluginsync --modulepath=$MODULEPATH \"$MODULEPATH\"auditd/tests/audisp_audispd_zos_remote.pp"
    shell.inline = script
  end
end
