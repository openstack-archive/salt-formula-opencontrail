{%- from "opencontrail/map.jinja" import web with context %}
{%- if web.enabled %}

opencontrail_web_packages:
  pkg.installed:
  - names: {{ web.pkgs }}
  - force_yes: True

/etc/contrail/config.global.js:
  file.managed:
  - source: salt://opencontrail/files/{{ web.version }}/config.global.js
  - template: jinja
  - require:
    - pkg: opencontrail_web_packages

/etc/contrail/contrail-webui-userauth.js:
  file.managed:
  - source: salt://opencontrail/files/{{ web.version }}/contrail-webui-userauth.js
  - template: jinja
  - require:
    - pkg: opencontrail_web_packages
{%- if not grains.get('noservices', False) %}
  - watch_in:
    - service: opencontrail_web_services

opencontrail_web_services:
  service.running:
  - enable: true
  - names: {{ web.services }}
  - watch: 
    - file: /etc/contrail/config.global.js

{%- endif %}

{%- if grains.get('virtual_subtype', None) == "Docker" %}

opencontrail_web_entrypoint:
  file.managed:
  - name: /entrypoint.sh
  - template: jinja
  - source: salt://opencontrail/files/entrypoint.sh.web
  - mode: 755

{%- endif %}

{%- endif %}
