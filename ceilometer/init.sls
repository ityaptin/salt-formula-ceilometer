
include:
{% if pillar.ceilometer.agent is defined %}
- ceilometer.agent_mitaka
{% endif %}
{% if pillar.ceilometer.server is defined %}
- ceilometer.server_mitaka
{% endif %}
