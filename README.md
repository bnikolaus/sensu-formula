sensu-formula
=============

Salt Formula to install Sensu server and clients

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/topics/conventions/formulas.html>`_.

Notes
====

* ssl to rabbitmq has been removed for now to simplify the setup

Todo
====

* create map.jinja and update sls to conform with best practice from `Salt Formulas installation and usage instructionas <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`
  * update pillar.example
* some templates are still static

Dependencies
============

* epel : https://github.com/saltstack-formulas/epel-formula
* rabbitmq : https://github.com/alex-leonhardt/rabbitmq-formula
* redis : https://github.com/saltstack-formulas/redis-formula

Available states
================

.. contents::
    :local:


``sensu``
---------

Install pre-requisites and install sensu (like repo, epel, etc.)


``sensu.server``
----------------

Configures and starts sensu server, api, dashboard and client onto a host, will publish a custom grain "sensu_server" (the IP of the sensu server host) to all minions to configure client config


``sensu.client``
----------------

Installs sensu client and setups config to find its rabbitmq server (sensu_server) and basic client config. Default will subscribe to the list "all". Pillar data can be used to add 1 custom list to subscribe to, examples will be provided.


``Example configuration``
-------------------------

pillar/top.sls:
```yaml
base:
  '*':
    - epel
    - sensu.client
  'sensu.local':
    - redis
    - sensu.server
```

pillar/sensu/client.sls:
```yaml
sensu:
  client:
    rabbit_port: 5672
    rabbit_user: 'sensu'
    rabbit_password: 'sensu'
    rabbit_vhost: '/sensu'
```

pillar/redis/init.sls:
```yaml
redis:
  lookup:
    bind: '0.0.0.0'

monitoring:
  sensu_group: 'redis-server'
```

salt/top.sls:
```yaml
base:
  '*':
    - epel
  'vm*':
    - sensu.client
  'sensu.local':
    - sensu.server
```

