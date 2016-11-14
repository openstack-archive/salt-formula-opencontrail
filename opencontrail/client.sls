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

{%- endif %}