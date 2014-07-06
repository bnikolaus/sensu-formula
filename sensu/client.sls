include:
  - sensu

sensu_ssl_certs_to_rabbitmq:
  file:
    - name: /etc/sensu/ssl
    - recurse
    - user: root
    - group: root
    - source: salt://sensu/files/ssl
    - clean: True

sensu_main_config:
  file:
    - name: /etc/sensu/config.json
    - managed
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://sensu/templates/config.json.jinja

sensu_client_config:
  file:
    - name: /etc/sensu/conf.d/client.json
    - managed
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - source: salt://sensu/templates/client.json.jinja

sensu_client_service:
  service:
    - name: sensu-client
    - enable: True
    - running
    - watch:
      - file: /etc/sensu/config.json
      - file: /etc/sensu/conf.d/client.json
    - require:
      - pkg: sensu
      - file: sensu_main_config
      - file: sensu_client_config
      - file: sensu_ssl_certs_to_rabbitmq

