{%- from "opencontrail/map.jinja" import client with context %}
{%- if client.enabled %}

opencontrail_client_packages:
  pkg.installed:
  - names: {{ client.pkgs }}

/etc/contrail/vnc_api_lib.ini:
  file.managed:
  - source: salt://opencontrail/files/client_vnc_api_lib.ini
  - template: jinja
  - require:
    - pkg: opencontrail_client_packages

{%- endif %}