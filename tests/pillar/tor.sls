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
  tor:
    enabled: true
    version: 3.0
    agents: 1
    control:
      address: 127.0.0.1
    interface:
      address: 127.0.0.1
    device:
      host: 127.0.0.1
  compute:
    enabled: true
    version: 3.0
    discovery:
      host: 127.0.0.1
    interface:
      address: 127.0.0.1
      dev: eth0
      gateway: 127.0.0.1
      mask: /24
      dns: 127.0.0.1
      mtu: 9000
