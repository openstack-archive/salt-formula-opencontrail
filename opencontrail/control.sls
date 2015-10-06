{%- from "opencontrail/map.jinja" import control with context %}
{%- if control.enabled %}

include:
- opencontrail.common

opencontrail_control_packages:
  pkg.installed:
  - names: {{ control.pkgs }}

{% if control.version == 2.2 %}

/etc/contrail/contrail-control-nodemgr.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ control.version }}/contrail-control-nodemgr.conf
  - template: jinja
  - require:
    - pkg: opencontrail_control_packages
  - watch_in:
    - service: opencontrail_control_services

{% endif %}

/etc/contrail/contrail-control.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ control.version }}/contrail-control.conf
  - template: jinja
  - require:
    - pkg: opencontrail_control_packages

/etc/contrail/contrail-dns.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ control.version }}/contrail-dns.conf
  - template: jinja
  - require:
    - pkg: opencontrail_control_packages

/etc/contrail/dns:
  file.directory:
  - user: contrail
  - group: contrail
  - require:
    - pkg: opencontrail_control_packages

/etc/contrail/dns/contrail-rndc.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ control.version }}/control/contrail-rndc.conf
  - require:
    - pkg: opencontrail_control_packages

opencontrail_control_services:
  service.running:
  - enable: true
  - names: {{ control.services }}
  - watch:
    - file: /etc/contrail/dns/contrail-rndc.conf
    - file: /etc/contrail/contrail-dns.conf
    - file: /etc/contrail/contrail-control.conf

{%- endif %}