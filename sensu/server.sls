include:
  - sensu
  - redis.server
  - rabbitmq

{% set sensu_server = salt['publish.publish']('*','grains.setval', [ 'sensu_server', salt['network.ip_addrs']('eth0')[0] ], 'glob') %}

pyOpenSSL:
  pkg: 
    - installed

rabbitmq_config:
  file:
    - name: /etc/rabbitmq/rabbitmq.config
    - managed
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://sensu/templates/rabbitmq.config.jinja

sensu_ssl_certs:
  file:
    - name: /etc/sensu/ssl
    - recurse
    - user: root
    - group: root
    - source: salt://sensu/files/ssl
    - clean: True

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
      - file: sensu_ssl_certs

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


