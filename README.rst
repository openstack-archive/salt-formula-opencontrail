============
OpenContrail
============

Contrail Controller is an open, standards-based software solution that delivers network virtualization and service automation for federated cloud networks. It provides self-service provisioning, improves network troubleshooting and diagnostics, and enables service chaining for dynamic application environments across enterprise virtual private cloud (VPC), managed Infrastructure as a Service (IaaS), and Networks Functions Virtualization (NFV) use cases. 

Sample pillars
==============

Keystone v3
-------------

To enable support for keystone v3 in opencontrail, there must be defined version for config and web role.

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

Read more
=========

* http://opencontrail.org
* http://juniper.github.io/contrail-vnc/README.html
* http://www.juniper.net/techpubs/en_US/contrail1.0/information-products/topic-collections/release-notes/index.html
* http://www.juniper.net/support/downloads/?p=contrail#sw
