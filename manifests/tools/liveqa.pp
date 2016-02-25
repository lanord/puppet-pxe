# Class: pxe::tools::liveqa
#
# Adds the liveqa image to the menu
#
class pxe::tools::liveqa (
  $url = 'http://linux.ne.deployment.iweb.com/tools/liveqa.tar.bz2'
){

  $tftp_root = $::pxe::tftp_root

  exec { 'retrieve liveqa image':
    path    => ['/usr/bin', '/usr/local/bin', '/bin'],
    command => "wget -q -O - ${url} | tar -x -j",
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
