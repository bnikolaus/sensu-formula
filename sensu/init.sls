include:
  - epel

sensu_repo:
  file:
    - managed
    - source: salt://sensu/files/sensu.repo
    - name: /etc/yum.repos.d/sensu.repo
    - user: root
    - group: root
    - mode: 644

sensu:
  pkg:
    - installed
  require:
    - file: sensu_repo

