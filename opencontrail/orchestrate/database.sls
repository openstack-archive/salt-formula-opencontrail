{%- if grains['saltversion'] >= "2016.3.0" %}

{# Batch execution is necessary - usable after 2016.3.0 release #}
opencontrail.database:
  salt.state:
    - tgt: 'opencontrail:database'
    - tgt_type: pillar
    - batch: 1
    - sls: opencontrail.database
    - require:
      - salt: keystone.server
      - salt: neutron.server

{%- else %}

{# Workaround for cluster with up to 3 members #}
opencontrail.database:
  salt.state:
    - tgt: '*01* and I@opencontrail:database'
    - tgt_type: compound
    - sls: opencontrail.database
    - require:
      - salt: keystone.server
      - salt: neutron.server

opencontrail.database.02:
  salt.state:
    - tgt: '*02* and I@opencontrail:database'
    - tgt_type: compound
    - sls: opencontrail.database
    - require:
      - salt: keystone.server
      - salt: neutron.server

opencontrail.database.03:
  salt.state:
    - tgt: '*03* and I@opencontrail:database'
    - tgt_type: compound
    - sls: opencontrail.database
    - require:
      - salt: keystone.server
      - salt: neutron.server

{%- endif %}

