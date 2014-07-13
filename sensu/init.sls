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

sensu-plugin-dependencies:
  pkg.installed:
    - pkgs:
      - rubygems
      - git

sensu-plugins:
  git.latest:
    - name: https://github.com/sensu/sensu-community-plugins.git
    - target: /etc/sensu/plugins-github
    - require:
      - pkg: sensu-plugin-dependencies

sensu-link-plugins:
  file.symlink:
    - name: /etc/sensu/plugins
    - target: /etc/sensu/plugins-github/plugins
    - force: True
    - require:
      - git: sensu-plugins

sensu-local-plugins:
  file.recurse:
    - name: /etc/sensu/plugins-local
    - source: salt://sensu/files/plugins-local
    - user: root
    - group: root
    - clean: True

