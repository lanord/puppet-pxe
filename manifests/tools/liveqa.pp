# Class: pxe::tools::liveqa
#
# Adds the liveqa image to the menu
#
class pxe::tools::liveqa (
  $url = 'http://preseed.cloud.iweb.com/livecd/liveqa.tar.bz2'
){
  $tftp_root = $::pxe::tftp_root

  file { "${tftp_root}/tools/liveqa":
    ensure => directory,
    before => exec['retrieve liveqa image']
  }

  # Retreive and install liveQA
  exec { 'retrieve liveqa image':
    path    => ['/usr/bin', '/usr/local/bin', '/bin'],
    cwd     => $tftp_root,
    command => "wget -q -O - ${url} | tar xj",
    creates => "${tftp_root}/tools/liveqa/initrd0.img",
    require => File["${tftp_root}/tools"],
  }

  # Create the menu entry
  pxe::menu::entry { 'LiveQA':
    file   => 'menu_tools',
    kernel => 'tools/liveqa/vmlinuz0',
    append => 'tools/liveqa/initrd0.img',
  }
}