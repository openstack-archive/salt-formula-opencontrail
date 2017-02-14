linux:
  system:
    repo:
      mirantis_openstack:
        source: "deb http://mirror.fuel-infra.org/mos-repos/ubuntu/9.0/ mos9.0 main restricted"
        architectures: amd64
        key_url: "http://mirror.fuel-infra.org/mos-repos/ubuntu/9.0/archive-mos9.0.key"
      #mirantis_openstack_hotfix:
        #source: "deb http://mirror.fuel-infra.org/mos-repos/ubuntu/9.0/ mos9.0-hotfix main restricted"
        #architectures: amd64
        #key_url: "http://mirror.fuel-infra.org/mos-repos/ubuntu/9.0/archive-mos9.0.key"
      #mirantis_openstack_security:
        #source: "deb http://mirror.fuel-infra.org/mos-repos/ubuntu/9.0/ mos9.0-security main restricted"
        #architectures: amd64
        #key_url: "http://mirror.fuel-infra.org/mos-repos/ubuntu/9.0/archive-mos9.0.key"
      #mirantis_openstack_updates:
        #source: "deb http://mirror.fuel-infra.org/mos-repos/ubuntu/9.0/ mos9.0-updates main restricted"
        #architectures: amd64
        #key_url: "http://mirror.fuel-infra.org/mos-repos/ubuntu/9.0/archive-mos9.0.key"
