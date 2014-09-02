# Class: jenkins_config::load
#
# This module imports and backs up jenkins XML configuration files
#
# Parameters:
#
#  import_source - the xml configuration file to load
#  jenkins_url   - url of the jenkins instance
#
# Requires:
#  jenkins - https://github.com/jenkinsci/puppet-jenkins
#
# Sample Usage:
#
# jenkins_config::load { "sampleapp":
#   import_source => 'modules/sampleapp/sampleapp_jenkins_config.xml',
#   jenkins_url => 'http://127.0.0.1:8080/jenkins',
# }
define jenkins_config::load (
  $import_source,
  $jenkins_url = 'http://127.0.0.1:8080',
) {

  include jenkins_config

  $home = $jenkins_config::jenkins_config_home
  $cli_bin = $jenkins_config::jenkins_cli_bin

  $timestamp = generate('/bin/date', '+%Y%d%m_%H:%M:%S')
  $import_file_absolute = "${home}/${title}"

  file { "${import_file_absolute}":
    ensure => file,
    owner => 'vagrant',
    group => 'vagrant',
    source => "puppet:///${import_source}",
  }

  exec { "import file":
    command => "/usr/bin/java -jar ${cli_bin} -s ${jenkins_url} create-job ${title} < ${import_file_absolute}",
    unless => "/usr/bin/java -jar ${cli_bin} -s ${jenkins_url} list-jobs | grep '^${title}$' 2>/dev/null",
    user => vagrant,
    require => [File["${import_file_absolute}"],
                File["jenkins-cli"],
                Class["jenkins::package"]],
    notify => Service["jenkins"],
  }

  exec { "archive job":
    command => "/usr/bin/java -jar ${cli_bin} -s ${jenkins_url} get-job ${title} > ${import_file_absolute}-${timestamp}",
    user => vagrant,
    require => Exec["import file"],
    notify => Service["jenkins"],
  }

}
