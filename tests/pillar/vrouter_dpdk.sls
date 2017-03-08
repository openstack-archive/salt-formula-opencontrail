opencontrail:
  common:
    version: 3.0
    identity:
      engine: keystone
      host: 127.0.0.1
      port: 35357
      token: token
      password: password
    network:
      engine: neutron
      host: 127.0.0.1
      port: 9696
  compute:
    version: 3.0
    enabled: True
    dpdk:
      enabled: True
      taskset: "0x0000003C00003C"
      socket_mem: "1024,1024"
    discovery:
      host: 127.0.0.1
    bind:
      address: 127.0.0.1
    interface:
      mac_address: 90:e2:ba:7c:22:e1
      pci: 0000:81:00.1
      address: 127.0.0.1
      dev: eth0
      gateway: 127.0.0.1
      mask: /24
      dns: 127.0.0.1
      mtu: 9000

