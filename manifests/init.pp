# Class: jenkins_config
#
# This module imports and backs up jenkins XML configuration files
#
# Parameters:
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
class jenkins_config {

  $jenkins_config_home = "/var/jenkins_config"
  $jenkins_cli_bin = "${jenkins_config_home}/jenkins-cli.jar"

  file { "jenkins_config":
    path => "${jenkins_config_home}",
    ensure => directory,
    owner => 'vagrant',
    group => 'vagrant',
  }

  file { "jenkins-cli":
    path => "${jenkins_cli_bin}",
    ensure => file,
    owner => 'vagrant',
    group => 'vagrant',
    source => 'https://ci.jenkins-ci.org/jnlpJars/jenkins-cli.jar',
  }

}
