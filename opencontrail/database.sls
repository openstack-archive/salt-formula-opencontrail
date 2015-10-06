{%- from "opencontrail/map.jinja" import database with context %}
{%- if database.enabled %}

include:
- opencontrail.common

opencontrail_database_packages:
  pkg.installed:
  - names: {{ database.pkgs }}

{% if database.cassandra.version == 1 %}

/etc/cassandra/cassandra.yaml:
  file.managed:
  - source: salt://opencontrail/files/cassandra.yaml.1
  - template: jinja
  - require:
    - pkg: opencontrail_database_packages

/etc/cassandra/cassandra-env.sh:
  file.managed:
  - source: salt://opencontrail/files/cassandra-env.sh.1
  - require:
    - pkg: opencontrail_database_packages

{% else %}

/etc/cassandra/cassandra.yaml:
  file.managed:
  - source: salt://opencontrail/files/{{ database.version }}/cassandra.yaml
  - template: jinja
  - require:
    - pkg: opencontrail_database_packages

/etc/cassandra/cassandra-env.sh:
  file.managed:
  - source: salt://opencontrail/files/{{ database.version }}/database/cassandra-env.sh
  - template: jinja
  - require:
    - pkg: opencontrail_database_packages

{% endif %}

/etc/zookeeper/conf/log4j.properties:
  file.managed:
  - source: salt://opencontrail/files/{{ database.version }}/database/log4j.properties
  - require:
    - pkg: opencontrail_database_packages

{% if database.version != 2.2 %}

/etc/contrail/database_nodemgr_param:
  file.managed:
  - source: salt://opencontrail/files/{{ database.version }}/database_nodemgr_param
  - template: jinja
  - require:
    - pkg: opencontrail_database_packages

{% endif %}

/etc/contrail/contrail-database-nodemgr.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ database.version }}/contrail-database-nodemgr.conf
  - template: jinja
  - require:
    - pkg: opencontrail_database_packages

/etc/zookeeper/conf/zoo.cfg:
  file.managed:
  - source: salt://opencontrail/files/{{ database.version }}/zoo.cfg
  - template: jinja
  - require:
    - pkg: opencontrail_database_packages

/var/lib/zookeeper/myid:
  file.managed:
  - contents: '{{ database.id }}'

{% if database.cassandra.version != 1 %}

{%- if salt['cmd.run']('test -e /var/lib/cassandra/.cassandra_bootstrap; echo $?') != '0'  %}

cleanup_directory_before_first_run:
  cmd.run:
  - name: 'rm -rf /var/lib/cassandra/*'
  - require_in:
    - service: opencontrail_database_services

cassandra_bootstrap_finish_flag:
  file.touch:
  - name: /var/lib/cassandra/.cassandra_bootstrap
  - require:
    - cmd: cleanup_directory_before_first_run
  - require_in:
    - service: opencontrail_database_services

{%- endif %}

{% endif %}

opencontrail_database_services:
  service.running:
  - enable: true
  - name: supervisor-database
  - watch: 
    - file: /etc/cassandra/cassandra.yaml
    - file: /etc/cassandra/cassandra-env.sh
    - file: /etc/zookeeper/conf/zoo.cfg
    - file: /etc/contrail/contrail-database-nodemgr.conf
    - file: /var/lib/zookeeper/myid
    - file: /etc/zookeeper/conf/log4j.properties

{%- endif %}
