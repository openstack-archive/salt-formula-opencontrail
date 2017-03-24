{%- from "opencontrail/map.jinja" import database with context %}
{%- if database.enabled %}

include:
- opencontrail.common

{% if database.cassandra.version == 1 %}

{{ database.cassandra_config }}cassandra.yaml:
  file.managed:
  - source: salt://opencontrail/files/cassandra.yaml.1
  - template: jinja
  - makedirs: True
{% if grains.os_family == "RedHat" %}
  - require:
    - pkg: opencontrail_database_packages
{% endif %}

{{ database.cassandra_config }}cassandra-env.sh:
  file.managed:
  - source: salt://opencontrail/files/cassandra-env.sh.1
  - makedirs: True
{% if grains.os_family == "RedHat" %}
  - require:
    - pkg: opencontrail_database_packages
{% endif %}

{% else %}

{{ database.cassandra_config }}cassandra.yaml:
  file.managed:
  - source: salt://opencontrail/files/{{ database.version }}/cassandra.yaml
  - template: jinja
  - makedirs: True
{% if grains.os_family == "RedHat" %}
  - require:
    - pkg: opencontrail_database_packages
{% endif %}

{{ database.cassandra_config }}logback.xml:
  file.managed:
  - source: salt://opencontrail/files/{{ database.version }}/database/logback.xml
  - template: jinja
  - makedirs: True
{% if grains.os_family == "RedHat" %}
  - require:
    - pkg: opencontrail_database_packages
{% endif %}

{{ database.cassandra_config }}cassandra-env.sh:
  file.managed:
  - source: salt://opencontrail/files/{{ database.version }}/database/cassandra-env.sh
  - template: jinja
  - makedirs: True
{% if grains.os_family == "RedHat" %}
  - require:
    - pkg: opencontrail_database_packages
{% endif %}

{% endif %}

opencontrail_database_packages:
  pkg.installed:
  - names: {{ database.pkgs }}
  - force_yes: True
{% if grains.os_family == "Debian" %}
  - require:
    - file: {{ database.cassandra_config }}cassandra.yaml
    - file: {{ database.cassandra_config }}cassandra-env.sh
    - file: {{ database.cassandra_config }}logback.xml
{% endif %}

/etc/zookeeper/conf/log4j.properties:
  file.managed:
  - source: salt://opencontrail/files/{{ database.version }}/database/log4j.properties
  - require:
    - pkg: opencontrail_database_packages

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

{% if database.version == 3.0 %}

/usr/share/kafka/config/server.properties:
  file.managed:
  - source: salt://opencontrail/files/{{ database.version }}/server.properties
  - template: jinja
  - require:
    - pkg: opencontrail_database_packages
{%- if not grains.get('noservices', False) %}
  - require_in:
    - service: opencontrail_database_services
{%- endif %}

/etc/contrail/supervisord_database_files/contrail-database-nodemgr.ini:
  file.managed:
  - source: salt://opencontrail/files/{{ database.version }}/database/contrail-database-nodemgr.ini
  - require:
    - pkg: opencontrail_database_packages
{%- if not grains.get('noservices', False) %}
  - require_in:
    - service: opencontrail_database_services
{%- endif %}

{% endif %}

{% if grains.os_family == "Debian" %}
#Stop cassandra started by init script - replaced by contrail-database
disable-cassandra-service:
  service.dead:
    - name: cassandra
    - enable: None
{% endif %}

/var/lib/cassandra/data:
  file.directory:
  - user: cassandra
  - group: cassandra
  - makedirs: True
{%- if not grains.get('noservices', False) %}
  - require_in:
    - service: opencontrail_database_services
{%- endif %}

/var/lib/cassandra:
  file.directory:
  - user: cassandra
  - group: cassandra
  - require:
    - file: /var/lib/cassandra/data

{%- if not grains.get('noservices', False) %}

zookeeper_service:
  service.running:
  - enable: true
  - name: zookeeper
  - watch:
    - file: /etc/zookeeper/conf/zoo.cfg
    - file: /var/lib/zookeeper/myid
    - file: /etc/zookeeper/conf/log4j.properties

opencontrail_database_services:
  service.running:
  - enable: true
  - name: supervisor-database
  - watch:
    - file: {{ database.cassandra_config }}cassandra.yaml
    - file: {{ database.cassandra_config }}cassandra-env.sh
    - file: {{ database.cassandra_config }}logback.xml
    - file: /etc/zookeeper/conf/zoo.cfg
    - file: /etc/contrail/contrail-database-nodemgr.conf
    - file: /var/lib/zookeeper/myid
    - file: /etc/zookeeper/conf/log4j.properties

{%- endif %}

{%- if grains.get('virtual_subtype', None) == "Docker" %}

opencontrail_database_entrypoint:
  file.managed:
  - name: /entrypoint.sh
  - template: jinja
  - source: salt://opencontrail/files/entrypoint.sh.database
  - mode: 755

{%- endif %}

{%- endif %}
