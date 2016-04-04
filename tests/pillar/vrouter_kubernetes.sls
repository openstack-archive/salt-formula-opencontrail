opencontrail:
  common:
    version: 2.2
    identity:
      engine: kubernetes
  compute:
    engine: kubernetes
    version: 2.2
    enabled: True
    discovery:
      host: 127.0.0.1
    interface:
      address: 127.0.0.1
      dev: eth0
      gateway: 127.0.0.1
      mask: /24
      dns: 127.0.0.1
      mtu: 9000