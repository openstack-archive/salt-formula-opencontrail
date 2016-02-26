opencontrail:
  common:
    version: 2.2
    source:
      engine: pkg
      address: http://mirror.robotice.cz/contrail-havana/
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
  config:
    version: 2.2
    enabled: true
    network:
      engine: neutron
      host: 127.0.0.1
      port: 9696
    discovery:
      host: 127.0.0.1
    analytics:
      host: 127.0.0.1
    bind:
      address: 127.0.0.1
    message_queue:
      engine: rabbitmq
      host: 127.0.0.1
      port: 5672
    database:
      members:
      - host: 127.0.0.1
        port: 9160
      - host: 127.0.0.1
        port: 9160
      - host: 127.0.0.1
        port: 9160
    cache:
      host: 127.0.0.1
    identity:
      engine: keystone
      version: v2.0
      region: RegionOne
      host: 127.0.0.1
      port: 35357
      user: admin
      password: password
      token: token
      tenant: admin
    members:
    - host: 127.0.0.1
      id: 1
    - host: 127.0.0.1
      id: 2
    - host: 127.0.0.1
      id: 3
  control:
    version: 2.2
    enabled: true
    bind:
      address: 127.0.0.1
    discovery:
      host: 127.0.0.1
    master:
      host: 127.0.0.1
    members:
    - host: 127.0.0.1
      id: 1
    - host: 127.0.0.1
      id: 2
    - host: 127.0.0.1
      id: 3
  collector:
    version: 2.2
    enabled: true
    bind:
      address: 127.0.0.1
    master:
      host: 127.0.0.1
    discovery:
      host: 127.0.0.1
    data_ttl: 1
    database:
      members:
      - host: 127.0.0.1
        port: 9160
      - host: 127.0.0.1
        port: 9160
      - host: 127.0.0.1
        port: 9160
  database:
    version: 2.2
    cassandra:
      version: 2
    enabled: true
    name: 'Contrail'
    minimum_disk: 10
    original_token: 0
    data_dirs:
    - /var/lib/cassandra
    id: 1
    discovery:
      host: 127.0.0.1
    bind:
      host: 127.0.0.1
      port: 9042
      rpc_port: 9160
    members:
    - host: 127.0.0.1
      id: 1
    - host: 127.0.0.1
      id: 2
    - host: 127.0.0.1
      id: 3
  web:
    version: 2.2
    enabled: True
    bind:
      address: 127.0.0.1
    master:
      host: 127.0.0.1
    analytics:
      host: 127.0.0.1
    cache:
      engine: redis
      host: 127.0.0.1
      port: 6379
    members:
    - host: 127.0.0.1
      id: 1
    - host: 127.0.0.1
      id: 2
    - host: 127.0.0.1
      id: 3
    identity:
      engine: keystone
      version: v2.0
      host: 127.0.0.1
      port: 35357
      user: admin
      password: password
      token: token
      tenant: admin