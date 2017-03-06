{%- macro set_param(param_name, param_dict) -%}
{%- if param_dict.get(param_name, False) -%}
- {{ param_name }}: {{ param_dict[param_name] }}
{%- endif -%}
{%- endmacro -%}
{%- from "opencontrail/map.jinja" import compute with context %}
{%- from "linux/map.jinja" import network with context %}
{%- if compute.enabled %}

include:
- opencontrail.common

opencontrail_compute_packages:
  pkg.installed:
  - names: {{ compute.pkgs }}

net.ipv4.ip_local_reserved_ports:
  sysctl.present:
    - value: 8085,9090
    - require:
      - pkg: opencontrail_compute_packages
    - require_in:
      - service: opencontrail_compute_services

/etc/contrail/contrail-vrouter-nodemgr.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ compute.version }}/contrail-vrouter-nodemgr.conf
  - template: jinja
  - require:
    - pkg: opencontrail_compute_packages
  - watch_in:
    - service: opencontrail_compute_services

/etc/contrail/vrouter_nodemgr_param:
  file.managed:
  - source: salt://opencontrail/files/{{ compute.version }}/vrouter_nodemgr_param
  - template: jinja
  - require:
    - pkg: opencontrail_compute_packages

/etc/contrail/agent_param:
  file.managed:
  - source: salt://opencontrail/files/{{ compute.version }}/agent_param
  - template: jinja
  - require:
    - pkg: opencontrail_compute_packages

/etc/contrail/contrail-vrouter-agent.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ compute.version }}/contrail-vrouter-agent.conf
  - template: jinja
  - require:
    - pkg: opencontrail_compute_packages
  - watch_in:
    - service: opencontrail_compute_services

/usr/local/bin/findns:
  file.managed:
  - source: salt://opencontrail/files/findns
  - mode: 755

{% if compute.version == 3.0 %}

/etc/contrail/supervisord_vrouter_files/contrail-vrouter-nodemgr.ini:
  file.managed:
  - source: salt://opencontrail/files/{{ compute.version }}/contrail-vrouter-nodemgr.ini
  - require:
    - pkg: opencontrail_compute_packages
  - require_in:
    - service: opencontrail_compute_services

/etc/udev/rules.d/vhost-net.rules:
  file.managed:
  - contents: 'KERNEL=="vhost-net", GROUP="kvm", MODE="0660"'

/etc/modules:
  file.append:
  - text: "vhost-net"
  - require:
    - file: /etc/udev/rules.d/vhost-net.rules

{% endif %}

{%- if compute.dpdk.enabled %}

opencontrail_vrouter_package:
  pkg.installed:
  - names:
    - contrail-vrouter-dpdk
    - contrail-vrouter-dpdk-init
    - contrail-vrouter-agent
  - require_in:
    - pkg: opencontrail_compute_packages

/etc/contrail/supervisord_vrouter_files/contrail-vrouter-dpdk.ini:
  file.managed:
  - source: salt://opencontrail/files/{{ compute.version }}/contrail-vrouter-dpdk.ini
  - template: jinja
  - require:
    - pkg: opencontrail_compute_packages
    - pkg: opencontrail_vrouter_package
  - require_in:
    - service: opencontrail_compute_services

modules_dpdk:
  file.append:
  - name: /etc/modules
  - text: uio
  - require:
    - pkg: opencontrail_vrouter_package

/usr/lib/contrail/if-vhost0:
  file.managed:
  - contents: "# Phony script as nothing to do in DPDK vRouter case."

{%- else %}

opencontrail_vrouter_package:
  pkg.installed:
  - names:
    - contrail-vrouter-dkms
    - contrail-vrouter-agent
  - require_in:
    - pkg: opencontrail_compute_packages

/etc/modprobe.d/vrouter.conf:
  file.managed:
  - contents: "options vrouter vr_flow_entries=2097152"

{%- if network.interface.get('vhost0', {}).get('enabled', False) %}

contrail_load_vrouter_kernel_module:
  cmd.run:
  - name: modprobe vrouter
  - unless: "lsmod | grep vrouter"
  - cwd: /root
  - require:
    - pkg: opencontrail_compute_packages

{%- endif %}

{%- endif %}

opencontrail_compute_services:
  service.enabled:
  - names: {{ compute.services }}

{%- if compute.get('engine', 'openstack') == 'kubernetes' %}

kubernetes_packages:
  pkg.installed:
    - names:
      - bridge-utils
      - ethtool
      - opencontrail-kubelet

/usr/libexec/kubernetes/kubelet-plugins/net/exec/opencontrail/opencontrail:
  file.symlink:
    - target: /usr/bin/opencontrail-kubelet-plugin
    - makedirs: true

{%- endif %}

{%- endif %}
