{%- from "opencontrail/map.jinja" import collector with context %}
{%- if collector.enabled %}

include:
- opencontrail.common

opencontrail_collector_packages:
  pkg.installed:
  - names: {{ collector.pkgs }}

/etc/contrail/contrail-analytics-nodemgr.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ collector.version }}/contrail-analytics-nodemgr.conf
  - template: jinja
  - require:
    - pkg: opencontrail_collector_packages

/etc/contrail/contrail-alarm-gen.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ collector.version }}/contrail-alarm-gen.conf
  - template: jinja
  - require:
    - pkg: opencontrail_collector_packages

/etc/contrail/contrail-snmp-collector.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ collector.version }}/contrail-snmp-collector.conf
  - template: jinja
  - require:
    - pkg: opencontrail_collector_packages

/etc/contrail/contrail-topology.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ collector.version }}/contrail-topology.conf
  - template: jinja
  - require:
    - pkg: opencontrail_collector_packages

{{ collector.redis_config }}:
  file.managed:
  - source: salt://opencontrail/files/{{ collector.version }}/collector/redis.conf
  - require:
    - pkg: opencontrail_collector_packages

/etc/contrail/contrail-collector.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ collector.version }}/contrail-collector.conf
  - template: jinja
  - require:
    - pkg: opencontrail_collector_packages

/etc/contrail/contrail-query-engine.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ collector.version }}/contrail-query-engine.conf
  - template: jinja
  - require:
    - pkg: opencontrail_collector_packages

/etc/contrail/contrail-analytics-api.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ collector.version }}/contrail-analytics-api.conf
  - template: jinja
  - require:
    - pkg: opencontrail_collector_packages

{% if collector.version == 3.0 %}

/etc/contrail/supervisord_analytics_files/contrail-analytics-nodemgr.ini:
  file.managed:
  - source: salt://opencontrail/files/{{ collector.version }}/collector/contrail-analytics-nodemgr.ini
  - require:
    - pkg: opencontrail_collector_packages
{%- if not grains.get('noservices', False) %}
  - require_in:
    - service: opencontrail_collector_services
{%- endif %}

/etc/contrail/supervisord_analytics.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ collector.version }}/collector/supervisord_analytics.conf
  - require:
    - pkg: opencontrail_collector_packages
{%- if not grains.get('noservices', False) %}
  - require_in:
    - service: opencontrail_collector_services
{%- endif %}

{% endif %}

{%- if not grains.get('noservices', False) %}

opencontrail_collector_services:
  service.running:
  - enable: true
  - names: {{ collector.services }}
  - watch:
    - file: /etc/contrail/contrail-analytics-api.conf
    - file: /etc/contrail/contrail-query-engine.conf
    - file: /etc/contrail/contrail-collector.conf
    - file: {{ collector.redis_config }}
    - file: /etc/contrail/contrail-topology.conf
    - file: /etc/contrail/contrail-snmp-collector.conf
    - file: /etc/contrail/contrail-analytics-nodemgr.conf
    - file: /etc/contrail/contrail-alarm-gen.conf

{%- endif %}

{%- if grains.get('virtual_subtype', None) == "Docker" %}

opencontrail_collector_entrypoint:
  file.managed:
  - name: /entrypoint.sh
  - template: jinja
  - source: salt://opencontrail/files/entrypoint.sh.collector
  - mode: 755

{%- endif %}

{%- endif %}
