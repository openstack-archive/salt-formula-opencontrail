
include:
{% if pillar.opencontrail.collector is defined %}
- opencontrail.collector
{% endif %}
{% if pillar.opencontrail.compute is defined %}
- opencontrail.compute
{% endif %}
{% if pillar.opencontrail.config is defined %}
- opencontrail.config
{% endif %}
{% if pillar.opencontrail.control is defined %}
- opencontrail.control
{% endif %}
{% if pillar.opencontrail.database is defined %}
- opencontrail.database
{% endif %}
{% if pillar.opencontrail.web is defined %}
- opencontrail.web
{% endif %}
{% if pillar.opencontrail.tor is defined %}
- opencontrail.tor
{% endif %}
{%- if pillar.opencontrail.client is defined %}
- opencontrail.client
{%- endif %}
{% if pillar.opencontrail.common is defined %}
- opencontrail.common
{% endif %}