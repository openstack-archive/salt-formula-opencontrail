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

{%- if grains.os_family == "Debian" %}

/etc/network/if-pre-up.d/if-vhost0:
  file.symlink:
    - target: /usr/lib/contrail/if-vhost0
    - require:
      - pkg: opencontrail_compute_packages

{%- endif %}

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

{%- if network.interface.get('vhost0', {}).get('enabled', False) %}

contrail_load_vrouter_kernel_module:
  cmd.run:
  - name: modprobe vrouter
  - unless: "lsmod | grep vrouter"
  - cwd: /root
  - require:
    - pkg: opencontrail_compute_packages

{%- endif %}

opencontrail_compute_services:
  service.enabled:
  - names: {{ compute.services }}

{%- endif %}
