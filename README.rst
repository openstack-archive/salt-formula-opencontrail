============
OpenContrail
============

Contrail Controller is an open, standards-based software solution that
delivers network virtualization and service automation for federated cloud
networks. It provides self-service provisioning, improves network
troubleshooting and diagnostics, and enables service chaining for dynamic
application environments across enterprise virtual private cloud (VPC),
managed Infrastructure as a Service (IaaS), and Networks Functions
Virtualization (NFV) use cases.


Package source
==============
Formula support OpenContrail as well as Juniper Contrail package repository in the backend.

Differences withing the configuration and state run are controlled by
``opencontrail.common.distribution: [opencontrail|juniper]`` pillar attribute.

Default value is set to ``opencontrail``.

Juniper releases tested with this formula:
 - 3.0.2.0-51

To use Juniper Contrail repository as a source of packages override pillar as in this example:

.. code-block:: yaml

    opencontrail:
      common:
        distribution: juniper


Sample pillars
==============

Controller nodes
----------------

There are several scenarios for OpenContrail control plane.

All-in-one single
~~~~~~~~~~~~~~~~~

Config, control, analytics, database, web -- altogether on one node.

.. code-block:: yaml

    opencontrail:
      common:
        version: 2.2
        source:
          engine: pkg
          address: http://mirror.robotice.cz/contrail-havana/
        identity:
          engine: keystone
          host: 127.0.0.1
          port: 35357
          token: token
          password: password
        network:
          engine: neutron
          host: 127.0.0.1
          port: 9696
      config:
        version: 2.2
        enabled: true
        network:
          engine: neutron
          host: 127.0.0.1
          port: 9696
        discovery:
          host: 127.0.0.1
        analytics:
          host: 127.0.0.1
        bind:
          address: 127.0.0.1
        message_queue:
          engine: rabbitmq
          host: 127.0.0.1
          port: 5672
        database:
          members:
          - host: 127.0.0.1
            port: 9160
        cache:
          members:
          - host: 127.0.0.1
            port: 11211
        identity:
          engine: keystone
          version: '2.0'
          region: RegionOne
          host: 127.0.0.1
          port: 35357
          user: admin
          password: password
          token: token
          tenant: admin
        members:
        - host: 127.0.0.1
          id: 1
      control:
        version: 2.2
        enabled: true
        bind:
          address: 127.0.0.1
        discovery:
          host: 127.0.0.1
        master:
          host: 127.0.0.1
        members:
        - host: 127.0.0.1
          id: 1
      collector:
        version: 2.2
        enabled: true
        bind:
          address: 127.0.0.1
        master:
          host: 127.0.0.1
        discovery:
          host: 127.0.0.1
        data_ttl: 2
        database:
          members:
          - host: 127.0.0.1
            port: 9160
      database:
        version: 2.2
        cassandra:
          version: 2
        enabled: true
        minimum_disk: 10
        name: 'Contrail'
        original_token: 0
        data_dirs:
        - /var/lib/cassandra
        id: 1
        discovery:
          host: 127.0.0.1
        bind:
          host: 127.0.0.1
          port: 9042
          rpc_port: 9160
        members:
        - host: 127.0.0.1
          id: 1
      web:
        version: 2.2
        enabled: True
        bind:
          address: 127.0.0.1
        analytics:
          host: 127.0.0.1
        master:
          host: 127.0.0.1
        cache:
          engine: redis
          host: 127.0.0.1
          port: 6379
        members:
        - host: 127.0.0.1
          id: 1
        identity:
          engine: keystone
          version: '2.0'
          host: 127.0.0.1
          port: 35357
          user: admin
          password: password
          token: token
          tenant: admin


All-in-one cluster
~~~~~~~~~~~~~~~~~~

Config, control, analytics, database, web -- altogether, clustered on multiple
nodes.

.. code-block:: yaml

    opencontrail:
      common:
        version: 2.2
        source:
          engine: pkg
          address: http://mirror.robotice.cz/contrail-havana/
        identity:
          engine: keystone
          host: 127.0.0.1
          port: 35357
          token: token
          password: password
        network:
          engine: neutron
          host: 127.0.0.1
          port: 9696
      config:
        version: 2.2
        enabled: true
        network:
          engine: neutron
          host: 127.0.0.1
          port: 9696
        discovery:
          host: 127.0.0.1
        analytics:
          host: 127.0.0.1
        bind:
          address: 127.0.0.1
        message_queue:
          engine: rabbitmq
          host: 127.0.0.1
          port: 5672
        database:
          members:
          - host: 127.0.0.1
            port: 9160
          - host: 127.0.0.1
            port: 9160
          - host: 127.0.0.1
            port: 9160
        cache:
          members:
          - host: 127.0.0.1
            port: 11211
          - host: 127.0.0.1
            port: 11211
          - host: 127.0.0.1
            port: 11211
        identity:
          engine: keystone
          version: '2.0'
          region: RegionOne
          host: 127.0.0.1
          port: 35357
          user: admin
          password: password
          token: token
          tenant: admin
        members:
        - host: 127.0.0.1
          id: 1
        - host: 127.0.0.1
          id: 2
        - host: 127.0.0.1
          id: 3
      control:
        version: 2.2
        enabled: true
        bind:
          address: 127.0.0.1
        discovery:
          host: 127.0.0.1
        master:
          host: 127.0.0.1
        members:
        - host: 127.0.0.1
          id: 1
        - host: 127.0.0.1
          id: 2
        - host: 127.0.0.1
          id: 3
      collector:
        version: 2.2
        enabled: true
        bind:
          address: 127.0.0.1
        master:
          host: 127.0.0.1
        discovery:
          host: 127.0.0.1
        data_ttl: 1
        database:
          members:
          - host: 127.0.0.1
            port: 9160
          - host: 127.0.0.1
            port: 9160
          - host: 127.0.0.1
            port: 9160
      database:
        version: 2.2
        cassandra:
          version: 2
        enabled: true
        name: 'Contrail'
        minimum_disk: 10
        original_token: 0
        data_dirs:
        - /var/lib/cassandra
        id: 1
        discovery:
          host: 127.0.0.1
        bind:
          host: 127.0.0.1
          port: 9042
          rpc_port: 9160
        members:
        - host: 127.0.0.1
          id: 1
        - host: 127.0.0.1
          id: 2
        - host: 127.0.0.1
          id: 3
      web:
        version: 2.2
        enabled: True
        bind:
          address: 127.0.0.1
        master:
          host: 127.0.0.1
        analytics:
          host: 127.0.0.1
        cache:
          engine: redis
          host: 127.0.0.1
          port: 6379
        members:
        - host: 127.0.0.1
          id: 1
        - host: 127.0.0.1
          id: 2
        - host: 127.0.0.1
          id: 3
        identity:
          engine: keystone
          version: '2.0'
          host: 127.0.0.1
          port: 35357
          user: admin
          password: password
          token: token
          tenant: admin


Separated analytics from control and config
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Config, control, database, web.

.. code-block:: yaml

    opencontrail:
      common:
        version: 2.2
        identity:
          engine: keystone
          host: 127.0.0.1
          port: 35357
          token: token
          password: password
        network:
          engine: neutron
          host: 127.0.0.1
          port: 9696
      config:
        version: 2.2
        enabled: true
        network:
          engine: neutron
          host: 127.0.0.1
          port: 9696
        discovery:
          host: 127.0.0.1
        analytics:
          host: 127.0.0.1
        bind:
          address: 127.0.0.1
        message_queue:
          engine: rabbitmq
          host: 127.0.0.1
          port: 5672
        database:
          members:
          - host: 127.0.0.1
            port: 9160
          - host: 127.0.0.1
            port: 9160
          - host: 127.0.0.1
            port: 9160
        cache:
          members:
          - host: 127.0.0.1
            port: 11211
          - host: 127.0.0.1
            port: 11211
          - host: 127.0.0.1
            port: 11211
        identity:
          engine: keystone
          version: '2.0'
          region: RegionOne
          host: 127.0.0.1
          port: 35357
          user: admin
          password: password
          token: token
          tenant: admin
        members:
        - host: 127.0.0.1
          id: 1
        - host: 127.0.0.1
          id: 2
        - host: 127.0.0.1
          id: 3
      control:
        version: 2.2
        enabled: true
        bind:
          address: 127.0.0.1
        discovery:
          host: 127.0.0.1
        master:
          host: 127.0.0.1
        members:
        - host: 127.0.0.1
          id: 1
        - host: 127.0.0.1
          id: 2
        - host: 127.0.0.1
          id: 3
      database:
        version: 127.0.0.1
        cassandra:
          version: 2
        enabled: true
        name: 'Contrail'
        minimum_disk: 10
        original_token: 0
        data_dirs:
        - /var/lib/cassandra
        id: 1
        discovery:
          host: 127.0.0.1
        bind:
          host: 127.0.0.1
          port: 9042
          rpc_port: 9160
        members:
        - host: 127.0.0.1
          id: 1
        - host: 127.0.0.1
          id: 2
        - host: 127.0.0.1
          id: 3
      web:
        version: 2.2
        enabled: True
        bind:
          address: 127.0.0.1
        analytics:
          host: 127.0.0.1
        master:
          host: 127.0.0.1
        cache:
          engine: redis
          host: 127.0.0.1
          port: 6379
        members:
        - host: 127.0.0.1
          id: 1
        - host: 127.0.0.1
          id: 2
        - host: 127.0.0.1
          id: 3
        identity:
          engine: keystone
          version: '2.0'
          host: 127.0.0.1
          port: 35357
          user: admin
          password: password
          token: token
          tenant: admin


Analytic nodes
----------------

Analytics and database on an analytic node(s)

.. code-block:: yaml

    opencontrail:
      common:
        version: 2.2
        identity:
          engine: keystone
          host: 127.0.0.1
          port: 35357
          token: token
          password: password
        network:
          engine: neutron
          host: 127.0.0.1
          port: 9696
      collector:
        version: 2.2
        enabled: true
        bind:
          address: 127.0.0.1
        master:
          host: 127.0.0.1
        discovery:
          host: 127.0.0.1
        data_ttl: 1
        database:
          members:
          - host: 127.0.0.1
            port: 9160
          - host: 127.0.0.1
            port: 9160
          - host: 127.0.0.1
            port: 9160
      database:
        version: 2.2
        cassandra:
          version: 2
        enabled: true
        name: 'Contrail'
        minimum_disk: 10
        original_token: 0
        data_dirs:
        - /var/lib/cassandra
        id: 1
        discovery:
          host: 127.0.0.1
        bind:
          host: 127.0.0.1
          port: 9042
          rpc_port: 9160
        members:
        - host: 127.0.0.1
          id: 1
        - host: 127.0.0.1
          id: 2
        - host: 127.0.0.1
          id: 3


Compute nodes
----------------

Vrouter configuration on a compute node(s)

.. code-block:: yaml

    opencontrail:
      common:
        version: 2.2
        identity:
          engine: keystone
          host: 127.0.0.1
          port: 35357
          token: token
          password: password
        network:
          engine: neutron
          host: 127.0.0.1
          port: 9696
      compute:
        version: 2.2
        enabled: True
        discovery:
          host: 127.0.0.1
        interface:
          address: 127.0.0.1
          dev: eth0
          gateway: 127.0.0.1
          mask: /24
          dns: 127.0.0.1
          mtu: 9000

Keystone v3
-------------

To enable support for keystone v3 in opencontrail, there must be defined
version for config and web role.

.. code-block:: yaml

    opencontrail:
      config:
        version: 2.2
        enabled: true
        ...
        identity:
          engine: keystone
          version: '3'
        ...

    opencontrail:
      web:
        version: 2.2
        enabled: true
        ...
        identity:
          engine: keystone
          version: '3'
        ...

Without Keystone
----------------

.. code-block:: yaml

    opencontrail:
      ...
      common:
        ...
        identity:
          engine: none
          token: none
          password: none
        ...
      config:
        ...
        identity:
          engine: none
          password: none
          token: none
        ...
      web:
        ...
        identity:
          engine: none
          password: none
          token: none
        ...

Kubernetes vrouter nodes
------------------------

Vrouter configuration on a kubernetes node(s)

.. code-block:: yaml

    opencontrail:
      ...
      compute:
        engine: kubernetes
      ...

vRouter with separated control plane
------------------------------------

Separate XMPP traffic from dataplane interface.

.. code-block:: yaml

    opencontrail:
      compute:
        bind:
          address: 172.16.0.50
      ...

Disable Contrail API authentication
-----------------------------------

Contrail version must >=3.0. It is useful especially for Keystone v3.

.. code-block:: yaml

    opencontrail:
      ...
      config:
        multi_tenancy: false
      ...

Cassandra listen interface
------------------------------

.. code-block:: yaml
  
    database:
      ....
      bind:
        interface: eth0
        port: 9042
        rpc_port: 9160
      ....

RabbitMQ HA hosts
------------------

.. code-block:: yaml

    opencontrail:
      config:
        message_queue:
          engine: rabbitmq
          members:
            - host: 10.0.16.1
            - host: 10.0.16.2
            - host: 10.0.16.3
          port: 5672

.. code-block:: yaml

    database:
      ....
      bind:
        interface: eth0
        port: 9042
        rpc_port: 9160
      ....

Usage
=====

Basic installation
==================

Add control BGP
===============

    python /etc/contrail/provision_control.py --api_server_ip 192.168.1.11 --api_server_port 8082 --host_name network1.contrail.domain.com --host_ip 192.168.1.11 --router_asn 64512

Compute node installation
=========================

.. code-block:: yaml

    yum install contrail-vrouter contrail-openstack-vrouter

    salt-call state.sls nova,opencontrail

Add virtual router
==================

.. code-block:: yaml

    python /etc/contrail/provision_vrouter.py --host_name hostnode1.intra.domain.com --host_ip 10.0.100.101 --api_server_ip 10.0.100.30 --oper add --admin_user admin --admin_password cloudlab --admin_tenant_name admin

    /etc/sysconfig/network-scripts/ifcfg-bond0 -- comment GATEWAY,NETMASK,IPADDR

    reboot

Service debugging
=================

Display vhost XMPP connection status

You should see the correct controller_ip and state should be established.

    http://<compute-node>:8085/Snh_AgentXmppConnectionStatusReq?

Display vrouter interface status

When vrf_name = ---ERROR--- then something goes wrong

    http://<compute-node>:8085/Snh_ItfReq?name=

Display IF MAP table

Look for neighbours, if VM has 2, it's ok 

	http://<control-node>:8083/Snh_IFMapTableShowReq?table_name=

Trace XMPP requests

	http://<compute-node>:8085/Snh_SandeshTraceRequest?x=XmppMessageTrace

Documentation and Bugs
============================

To learn how to deploy OpenStack Salt, consult the documentation available
online at:

    https://wiki.openstack.org/wiki/OpenStackSalt

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate bug tracker. If you obtained the software from a 3rd party
operating system vendor, it is often wise to use their own bug tracker for
reporting problems. In all other cases use the master OpenStack bug tracker,
available at:

    http://bugs.launchpad.net/openstack-salt

Developers wishing to work on the OpenStack Salt project should always base
their work on the latest formulas code, available from the master GIT
repository at:

    https://git.openstack.org/cgit/openstack/salt-formula-opencontrail

Developers should also join the discussion on the IRC list, at:

    https://wiki.openstack.org/wiki/Meetings/openstack-salt

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-opencontrail/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-opencontrail

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
