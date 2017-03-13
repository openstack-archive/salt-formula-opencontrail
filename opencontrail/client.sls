{%- from "opencontrail/map.jinja" import client with context %}
{%- if client.get('enabled', False) %}

opencontrail_client_packages:
  pkg.installed:
  - names: {{ client.pkgs }}

{%- if client.identity.engine == "keystone" %}
/etc/contrail/vnc_api_lib.ini:
  file.managed:
  - source: salt://opencontrail/files/{{ client.version }}/client_vnc_api_lib.ini
  - template: jinja
  - require:
    - pkg: opencontrail_client_packages
{%- endif %}

{%- for virtual_router_name, virtual_router in client.get('virtual_router', {}).items() %}

opencontrail_client_virtual_router_{{ virtual_router_name }}:
  contrail.virtual_router_present:
  - name: {{ virtual_router.get('name', virtual_router_name) }}
  - ip_address: {{ virtual_router.ip_address }}
  - dpdk_enabled: {{ virtual_router.get('dpdk_enabled', False) }}
  - user: {{ client.identity.user }}
  - password: {{ client.identity.password }}
  - project: {{ client.identity.tenant }}
  - auth_host_ip: {{ client.identity.host }}
  - api_server_ip: {{ client.api.host }}
  - api_server_port: {{ client.api.port }}
  - api_base_url: '/'

{%- endfor %}

{%- for config_node_name, config_node in client.get('config_node', {}).items() %}

opencontrail_client_config_node_{{ config_node_name }}:
  contrail.config_node_present:
  - name: {{ config_node.get('name', config_node_name) }}
  - ip_address: {{ config_node.ip_address }}
  - user: {{ client.identity.user }}
  - password: {{ client.identity.password }}
  - project: {{ client.identity.tenant }}
  - auth_host_ip: {{ client.identity.host }}
  - api_server_ip: {{ client.api.host }}
  - api_server_port: {{ client.api.port }}
  - api_base_url: '/'

{%- endfor %}

{%- for bgp_router_name, bgp_router in client.get('bgp_router', {}).items() %}

opencontrail_client_bgp_router_{{ bgp_router_name }}:
  contrail.bgp_router_present:
  - name: {{ bgp_router.get('name', bgp_router_name) }}
  - ip_address: {{ bgp_router.ip_address }}
  - type: {{ bgp_router.type }}
  - asn: {{ bgp_router.get('asn', 64512) }}
  - user: {{ client.identity.user }}
  - password: {{ client.identity.password }}
  - project: {{ client.identity.tenant }}
  - auth_host_ip: {{ client.identity.host }}
  - api_server_ip: {{ client.api.host }}
  - api_server_port: {{ client.api.port }}
  - api_base_url: '/'

{%- endfor %}

{%- for analytics_node_name, analytics_node in client.get('analytics_node', {}).items() %}

opencontrail_client_analytics_node_{{ analytics_node_name }}:
  contrail.analytics_node_present:
  - name: {{ analytics_node.get('name', analytics_node_name) }}
  - ip_address: {{ analytics_node.ip_address }}
  - user: {{ client.identity.user }}
  - password: {{ client.identity.password }}
  - project: {{ client.identity.tenant }}
  - auth_host_ip: {{ client.identity.host }}
  - api_server_ip: {{ client.api.host }}
  - api_server_port: {{ client.api.port }}
  - api_base_url: '/'

{%- endfor %}

{%- for database_node_name, database_node in client.get('database_node', {}).items() %}

opencontrail_client_database_node_{{ database_node_name }}:
  contrail.database_node_present:
  - name: {{ database_node.get('name', database_node_name) }}
  - ip_address: {{ database_node.ip_address }}
  - user: {{ client.identity.user }}
  - password: {{ client.identity.password }}
  - project: {{ client.identity.tenant }}
  - auth_host_ip: {{ client.identity.host }}
  - api_server_ip: {{ client.api.host }}
  - api_server_port: {{ client.api.port }}
  - api_base_url: '/'

{%- endfor %}

{%- endif %}
