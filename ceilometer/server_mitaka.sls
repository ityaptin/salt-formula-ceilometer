{%- from "ceilometer/map.jinja" import server with context %}
{%- if server.enabled %}

ceilometer_server_packages:
  pkg.installed:
  - names: {{ server.basic_pkgs }}

/etc/ceilometer/ceilometer.conf:
  file.managed:
    - source: salt://ceilometer/files/{{ server.version }}/ceilometer-server.conf.{{ grains.os_family }}
    - template: jinja
    - require:
      - pkg: ceilometer_server_packages

/etc/ceilometer/event_pipeline.yaml:
  file.managed:
  - source: salt://ceilometer/files/{{ server.version }}/event_pipeline.yaml
  - template: jinja
  - require:
    - pkg: ceilometer_server_packages
  - watch_in:
    - service: ceilometer_server_services

/etc/ceilometer/event_definitions.yaml:
  file.managed:
  - source: salt://ceilometer/files/{{ server.version }}/event_definitions.yaml
  - template: jinja
  - require:
    - pkg: ceilometer_server_packages
  - watch_in:
    - service: ceilometer_server_services

/etc/ceilometer/gabbi_pipeline.yaml:
  file.managed:
  - source: salt://ceilometer/files/{{ server.version }}/gabbi_pipeline.yaml
  - template: jinja
  - require:
    - pkg: ceilometer_server_packages
  - watch_in:
    - service: ceilometer_server_services

ceilometer_server_services:
  service.running:
  - names: {{ server.basic_services }}
  - enable: true
  - watch:
    - file: /etc/ceilometer/ceilometer.conf

{%- endif %}