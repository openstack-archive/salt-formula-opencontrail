{%- from "opencontrail/map.jinja" import common with context %}

opencontrail_common_packages:
  pkg.installed:
  - names: {{ common.pkgs }}

iptables:
  service.dead:
  - enable: false
  - name: iptables

/var/crashes:
  file.directory

net.ipv4.ip_forward:
  sysctl.present:
  - value: 1

kernel.core_pattern:
  sysctl.present:
  - value: "/var/crashes/core.%e.%p.%h.%t"

net.netfilter.nf_conntrack_max:
  sysctl.present:
    - value: 256000

{% if not pillar.opencontrail.compute is defined %}

net.netfilter.nf_conntrack_tcp_timeout_time_wait:
  sysctl.present:
    - value: 30

{% endif %}

net.ipv4.tcp_syncookies:
  sysctl.present:
    - value: 1

net.ipv4.tcp_tw_recycle:
  sysctl.present:
    - value: 1

net.ipv4.tcp_tw_reuse:
  sysctl.present:
    - value: 1

net.ipv4.tcp_fin_timeout:
  sysctl.present:
    - value: 30

net.unix.max_dgram_qlen:
  sysctl.present:
    - value: 1000

net.ipv4.tcp_keepalive_time:
  sysctl.present:
    - value: 5

net.ipv4.tcp_keepalive_probes:
  sysctl.present:
    - value: 5

net.ipv4.tcp_keepalive_intvl:
  sysctl.present:
    - value: 1

fs.file-max:
  sysctl.present:
  - value: 65535

security_limits_conf:
  cmd.run:
  - names:
    - sed -i '/^root\s*soft\s*nproc\s*.*/d' /etc/security/limits.conf && printf printf "root soft nofile 65535\n" >> /etc/security/limits.conf
    - sed -i '/^*\s*hard\s*nofile\s*.*/d' /etc/security/limits.conf && printf "* hard nofile 65535\n" >> /etc/security/limits.conf
    - sed -i '/^*\s*soft\s*nofile\s*.*/d' /etc/security/limits.conf && printf "* soft nofile 65535\n" >> /etc/security/limits.conf
    - sed -i '/^*\s*hard\s*nproc\s*.*/d' /etc/security/limits.conf && printf "* hard nproc 65535\n" >> /etc/security/limits.conf
    - sed -i '/^*\s*soft\s*nproc\s*.*/d' /etc/security/limits.conf && printf "* soft nofile 65535\n" >> /etc/security/limits.conf
  - onlyif: test -e /etc/security/limits.conf

vm.overcommit_memory:
  sysctl.present:
    - value: 1

/etc/contrail:
  file.directory

/etc/contrail/service.token:
  file.managed:
  - contents: "{{ common.identity.token }}"
  - require:
    - file: /etc/contrail

/etc/contrail/ctrl-details:
  file.managed:
  - source: salt://opencontrail/files/{{ common.version }}/ctrl-details
  - template: jinja
  - require:
    - file: /etc/contrail

/etc/contrail/openstackrc:
  file.managed:
  - source: salt://opencontrail/files/{{ common.version }}/openstackrc
  - template: jinja
  - require:
    - file: /etc/contrail

/etc/contrail/keystonerc:
  file.managed:
  - source: salt://opencontrail/files/{{ common.version }}/keystonerc
  - template: jinja
  - require:
    - file: /etc/contrail
