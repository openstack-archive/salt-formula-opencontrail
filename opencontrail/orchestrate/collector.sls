{%- if grains['saltversion'] >= "2016.3.0" %}

{# Batch execution is necessary - usable after 2016.3.0 release #}
opencontrail.collector:
  salt.state:
    - tgt: 'opencontrail:collector'
    - tgt_type: pillar
    - batch: 1
    - sls: opencontrail.collector
    - require:
      - salt: opencontrail.database

{%- else %}

{# Workaround for cluster with up to 3 members #}
opencontrail.collector:
  salt.state:
    - tgt: '*01* and I@opencontrail:collector'
    - tgt_type: compound
    - sls: opencontrail.collector
    - require:
      - salt: opencontrail.database

opencontrail.collector.02:
  salt.state:
    - tgt: '*02* and I@opencontrail:collector'
    - tgt_type: compound
    - sls: opencontrail.collector
    - require:
      - salt: opencontrail.database

opencontrail.collector.03:
  salt.state:
    - tgt: '*03* and I@opencontrail:collector'
    - tgt_type: compound
    - sls: opencontrail.collector
    - require:
      - salt: opencontrail.database

{%- endif %}

