{%- if grains['saltversion'] >= "2016.3.0" %}

{# Batch execution is necessary - usable after 2016.3.0 release #}
opencontrail.control:
  salt.state:
    - tgt: 'opencontrail:control'
    - tgt_type: pillar
    - batch: 1
    - sls: opencontrail.control
    - require:
      - salt: opencontrail.database

{%- else %}

{# Workaround for cluster with up to 3 members #}
opencontrail.control:
  salt.state:
    - tgt: '*01* and I@opencontrail:control'
    - tgt_type: compound
    - sls: opencontrail.control
    - require:
      - salt: opencontrail.database

opencontrail.control.02:
  salt.state:
    - tgt: '*02* and I@opencontrail:control'
    - tgt_type: compound
    - sls: opencontrail.control
    - require:
      - salt: opencontrail.database

opencontrail.control.03:
  salt.state:
    - tgt: '*03* and I@opencontrail:control'
    - tgt_type: compound
    - sls: opencontrail.control
    - require:
      - salt: opencontrail.database

{%- endif %}

