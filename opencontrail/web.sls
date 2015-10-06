{%- from "opencontrail/map.jinja" import web with context %}
{%- if web.enabled %}

include:
- opencontrail.common

opencontrail_web_packages:
  pkg.installed:
  - names: {{ web.pkgs }}

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
  - watch_in:
    - service: opencontrail_web_services

opencontrail_web_services:
  service.running:
  - enable: true
  - names: {{ web.services }}
  - watch: 
    - file: /etc/contrail/config.global.js

{%- endif %}
