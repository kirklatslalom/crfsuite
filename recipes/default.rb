# Drop binary
cookbook_file '/tmp/crfsuite-0.12-x86_64.tar.gz' do
  source 'crfsuite-0.12-x86_64.tar.gz'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# rhsm_register 'myhost' do
#   satellite_host 'satellite.mycompany.com'
#   activation_key [ 'key1', 'key2' ]
# end if node[platform] == 'redhat'

rhsm_register 'myhost' do
  username 'username'
  password 'password'
  auto_attach true
  install_katello_agent false
  only_if { node['platform'] == 'redhat' }
end

rhsm_register 'myhost' do
  action :unregister
  install_katello_agent false
  only_if { node['platform'] == 'redhat' }
end

# Install packages
%w(libtool git).each do |pkg|
  package pkg do
    action :install
  end
end

# Install packages
if node['platform'] == 'ubuntu'
  %w(automake command-not-found).each do |pkg|
    package pkg do
      action :install
    end
  end
end

# Download source
git '/usr/src/crfsuite' do
  repository 'https://github.com/chokkan/crfsuite.git'
  reference 'master'
  action :checkout
end

# make test
execute 'crfsuite_make' do
  command './autogen.sh'
  cwd '/usr/src/crfsuite'
end
execute 'crfsuite_make' do
  command './configure'
  cwd '/usr/src/crfsuite'
end
