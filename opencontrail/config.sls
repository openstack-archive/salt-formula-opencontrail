{%- from "opencontrail/map.jinja" import config with context %}
{%- if config.enabled %}

include:
- opencontrail.common

opencontrail_config_packages:
  pkg.installed:
  - names: {{ config.pkgs }}

/etc/ifmap-server/authorization.properties:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/config/authorization.properties
  - require:
    - pkg: opencontrail_config_packages

/etc/ifmap-server/publisher.properties:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/config/publisher.properties
  - unless: test -e /etc/ifmap-server/deployed
  - require:
    - pkg: opencontrail_config_packages

publisher_init:
  cmd.run:
  - name: touch /etc/ifmap-server/deployed
  - unless: test -e /etc/ifmap-server/deployed
  - require:
    - pkg: opencontrail_config_packages

/etc/ifmap-server/log4j.properties:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/config/log4j.properties
  - require:
    - pkg: opencontrail_config_packages

/etc/ifmap-server/basicauthusers.properties:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/basicauthusers.properties
  - template: jinja
  - require:
    - pkg: opencontrail_config_packages

/etc/contrail/supervisord_config_files/contrail-api.ini:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/config/contrail-api.ini
  - require:
    - pkg: opencontrail_config_packages

/etc/contrail/supervisord_config_files/contrail-discovery.ini:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/config/contrail-discovery.ini
  - require:
    - pkg: opencontrail_config_packages

/etc/init.d/contrail-api:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/config/contrail-api
  - require:
    - pkg: opencontrail_config_packages

/etc/init.d/contrail-discovery:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/config/contrail-discovery
  - require:
    - pkg: opencontrail_config_packages

/etc/contrail/contrail-api.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/contrail-api.conf
  - template: jinja
  - require:
    - pkg: opencontrail_config_packages

/etc/contrail/contrail-discovery.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/contrail-discovery.conf
  - template: jinja
  - require:
    - pkg: opencontrail_config_packages

/etc/contrail/vnc_api_lib.ini:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/vnc_api_lib.ini
  - template: jinja
  - require:
    - pkg: opencontrail_config_packages

/etc/contrail/contrail-device-manager.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/contrail-device-manager.conf
  - template: jinja
  - require:
    - pkg: opencontrail_config_packages
  - watch_in:
    - service: opencontrail_config_services

/etc/contrail/contrail-config-nodemgr.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/contrail-config-nodemgr.conf
  - template: jinja
  - require:
    - pkg: opencontrail_config_packages
  - watch_in:
    - service: opencontrail_config_services

/etc/sudoers.d/contrail_sudoers:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/config/contrail_sudoers
  - template: jinja
  - require:
    - pkg: opencontrail_config_packages

/etc/contrail/contrail-keystone-auth.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/contrail-keystone-auth.conf
  - template: jinja
  - require:
    - pkg: opencontrail_config_packages

/etc/contrail/contrail-schema.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/contrail-schema.conf
  - template: jinja
  - require:
    - pkg: opencontrail_config_packages

/etc/contrail/contrail-svc-monitor.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ config.version }}/contrail-svc-monitor.conf
  - template: jinja
  - require:
    - pkg: opencontrail_config_packages

opencontrail_config_services:
  service.running:
  - enable: true
  - names: {{ config.services }}
  - watch: 
    - file: /etc/contrail/contrail-discovery.conf
    - file: /etc/contrail/contrail-svc-monitor.conf
    - file: /etc/contrail/contrail-schema.conf
    - file: /etc/contrail/contrail-api.conf
    - file: /etc/contrail/vnc_api_lib.ini
    - file: /etc/ifmap-server/basicauthusers.properties
    - file: /etc/contrail/contrail-keystone-auth.conf
    - file: /etc/sudoers.d/contrail_sudoers


{%- endif %}