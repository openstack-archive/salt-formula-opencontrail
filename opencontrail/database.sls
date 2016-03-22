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
{% if grains.os_family == "Debian" %}
  - require:
    - file: {{ database.cassandra_config }}cassandra.yaml
    - file: {{ database.cassandra_config }}cassandra-env.sh
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

opencontrail_database_services:
  service.running:
  - enable: true
  - name: supervisor-database
  - watch: 
    - file: {{ database.cassandra_config }}cassandra.yaml
    - file: {{ database.cassandra_config }}cassandra-env.sh
    - file: /etc/zookeeper/conf/zoo.cfg
    - file: /etc/contrail/contrail-database-nodemgr.conf
    - file: /var/lib/zookeeper/myid
    - file: /etc/zookeeper/conf/log4j.properties

{%- endif %}
