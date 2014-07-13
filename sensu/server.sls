include:
  - sensu
  - redis.server
  - rabbitmq

{% set sensu_server = salt['publish.publish']('*','grains.setval', [ 'sensu_server', salt['network.ip_addrs']('eth0')[0] ], 'glob') %}

pyOpenSSL:
  pkg: 
    - installed

sensu_srv_main_config:
  file:
    - name: /etc/sensu/config.json
    - managed
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://sensu/templates/config.server.json.jinja

sensu_srv_client_config:
  file:
    - name: /etc/sensu/conf.d/client.json
    - managed
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://sensu/templates/client.json.jinja

sensu-client:
  service:
    - enable: True
    - running
    - watch:
      - file: /etc/sensu/config.json
      - file: /etc/sensu/conf.d/client.json
    - require:
      - pkg: sensu
      - file: sensu_srv_main_config
      - file: sensu_srv_client_config

sensu-server:
  service:
    - enable: True
    - running
    - watch:
      - file: /etc/sensu/config.json
      - file: /etc/sensu/conf.d/*
    - require:
      - pkg: sensu
      - file: sensu_srv_main_config
      - file: sensu_srv_client_config

sensu-dashboard:
  service:
    - enable: True
    - running

sensu-api:
  service:
    - enable: True
    - running
    - watch:
      - file: /etc/sensu/config.json
      - file: /etc/sensu/conf.d/*
    - require:
      - pkg: sensu
      - file: sensu_srv_main_config
      - file: sensu_srv_client_config

sensu-link-handlers:
  file.symlink:
    - name: /etc/sensu/handlers
    - target: /etc/sensu/plugins-github/handlers
    - force: True
    - require:
      - git: sensu-plugins

sensu-link-mutators:
  file.symlink:
    - name: /etc/sensu/mutators
    - target: /etc/sensu/plugins-github/mutators
    - force: True
    - require:
      - git: sensu-plugins

sensu-local-handlers:
  file.recurse:
    - name: /etc/sensu/handlers-local
    - source: salt://sensu/files/handlers-local
    - user: root
    - group: root
    - clean: True

sensu-local-mutators:
  file.recurse:
    - name: /etc/sensu/mutators-local
    - source: salt://sensu/files/mutators-local
    - user: root
    - group: root
    - clean: True

