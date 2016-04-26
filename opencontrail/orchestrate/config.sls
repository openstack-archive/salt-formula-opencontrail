{%- if grains['saltversion'] >= "2016.3.0" %}

{# Batch execution is necessary - usable after 2016.3.0 release #}
opencontrail.config:
  salt.state:
    - tgt: 'opencontrail:config'
    - tgt_type: pillar
    - batch: 1
    - sls: opencontrail.config
    - require:
      - salt: opencontrail.database

{%- else %}

{# Workaround for cluster with up to 3 members #}
opencontrail.config:
  salt.state:
    - tgt: '*01* and I@opencontrail:config'
    - tgt_type: compound
    - sls: opencontrail.config
    - require:
      - salt: opencontrail.database

opencontrail.config.02:
  salt.state:
    - tgt: '*02* and I@opencontrail:config'
    - tgt_type: compound
    - sls: opencontrail.config
    - require:
      - salt: opencontrail.database

opencontrail.config.03:
  salt.state:
    - tgt: '*03* and I@opencontrail:config'
    - tgt_type: compound
    - sls: opencontrail.config
    - require:
      - salt: opencontrail.database

{%- endif %}

