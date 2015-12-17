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

/etc/network/if-pre-up.d/if-vhost0:
  file.symlink:
    - target: /usr/lib/contrail/if-vhost0
    - require:
      - pkg: opencontrail_compute_packages

{% if compute.version == 2.2 %}

/etc/contrail/contrail-vrouter-nodemgr.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ compute.version }}/contrail-vrouter-nodemgr.conf
  - template: jinja
  - require:
    - pkg: opencontrail_compute_packages
  - watch_in:
    - service: opencontrail_compute_services

{% endif %}

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

{#

{% set interface_params = [
    'gateway',
    'mtu',
    'up_cmds',
    'pre_up_cmds',
    'post_up_cmds',
    'down_cmds',
    'pre_down_cmds',
    'post_down_cmds',
    'master',
    'slaves',
    'mode',
    'lacp_rate'
] %}

{%- for interface_name, interface in network.interface.iteritems() %}
{%- if interface_name in ['vhost0', 'bond0', 'p3p1', 'p3p2'] %}

contrail_interface_{{ interface_name }}:
  network.managed:
  - enabled: {{ interface.enabled }}
  - name: {{ interface_name }}
  - type: {{ interface.type }}
  - proto: {{ interface.get('proto', 'static') }}
  {%- if interface.address is defined %}
  - ipaddr: {{ interface.address }}
  - netmask: {{ interface.netmask }}
  {%- endif %}
  {%- if interface.name_servers is defined %}
  - dns: {{ interface.name_servers }}
  {%- endif %}
  {%- for param in interface_params %}
  {{ set_param(param, interface) }}
  {%- endfor %}
  {%- if interface.type == 'bridge' %}
  - bridge: {{ interface_name }}
  - delay: 0
  - bypassfirewall: True
  - use:
    {%- for network in interface.use_interfaces %}
    - network: {{ network }}
    {%- endfor %}
  - ports: {% for network in interface.use_interfaces %}{{ network }} {% endfor %}
  {%- endif %}
  - require:
    {%- for network in interface.get('use_interfaces', []) %}
    - network: linux_interface_{{ network }}
    {%- endfor %}
    - cmd: contrail_load_vrouter_kernel_module
  - watch_in:
    - service: opencontrail_compute_services

{%- endif %}
{%- endfor %}
#}

{%- endif %}

opencontrail_compute_services:
  service.enabled:
  - names: {{ compute.services }}

{%- endif %}