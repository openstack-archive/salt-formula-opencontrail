{%- from "opencontrail/map.jinja" import tor with context %}
{%- if tor.enabled %}

include:
- opencontrail.common

{% for number in range(tor.agents) %}

/etc/contrail/contrail-tor-agent-{{ number }}.conf:
  file.managed:
  - source: salt://opencontrail/files/{{ tor.version }}/contrail-tor-agent.conf
  - template: jinja
  - defaults:
    number: {{ number }}

/etc/contrail/supervisord_vrouter_files/contrail-tor-agent-{{ number }}.ini:
  file.managed:
  - source: salt://opencontrail/files/{{ tor.version }}/tor/contrail-tor-agent.ini
  - template: jinja
  - defaults:
    number: {{ number }}

{%- endfor %}
{%- endif %}