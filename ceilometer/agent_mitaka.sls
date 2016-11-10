{%- from "ceilometer/map.jinja" import agent with context %}
{%- if agent.enabled %}

ceilometer_agent_packages:
  pkg.installed:
  - names: {{ agent.basic_pkgs }}

/etc/ceilometer/ceilometer.conf:
  file.managed:
  - source: salt://ceilometer/files/{{ agent.version }}/ceilometer-agent.conf.{{ grains.os_family }}
  - template: jinja
  - require:
    - pkg: ceilometer_agent_packages

/etc/ceilometer/pipeline.yaml:
  file.managed:
  - source: salt://ceilometer/files/{{ agent.version }}/compute_pipeline.yaml
  - template: jinja
  - require:
    - pkg: ceilometer_agent_packages

/etc/ceilometer/event_pipeline.yaml:
  file.managed:
  - source: salt://ceilometer/files/{{ agent.version }}/event_pipeline.yaml
  - template: jinja
  - require:
    - pkg: ceilometer_agent_packages
  - watch_in:
    - service: ceilometer_agent_services

ceilometer_agent_services:
  service.running:
  - names: {{ agent.basic_services }}
  - enable: true
  - watch:
    - file: /etc/ceilometer/ceilometer.conf
    - file: /etc/ceilometer/pipeline.yaml

{%- endif %}
