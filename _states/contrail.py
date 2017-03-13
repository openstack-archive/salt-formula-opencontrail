#!/usr/bin/python
# Copyright 2017 Mirantis, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
'''
Management of Contrail resources
================================

:depends:   - vnc_api Python module


Enforce the virtual router existence
------------------------------------

.. code-block:: yaml

    virtual_router:
      contrail.virtual_router_present:
        name: cmp01
        ip_address: 10.0.0.23
        dpdk_enabled: False


Enforce the virtual router absence
----------------------------------

.. code-block:: yaml

    virtual_router_cmp01:
      contrail.virtual_router_absent:
        name: cmp01


Enforce the analytics node existence
------------------------------------

.. code-block:: yaml

    analytics_node01:
      contrail.analytics_node_present:
        name: nal01
        ip_address: 10.0.0.13


Enforce the config node existence
---------------------------------

.. code-block:: yaml

    config_node01:
      contrail.config_node_present:
        name: ntw01
        ip_address: 10.0.0.23


Enforce the database node existence
-----------------------------------

.. code-block:: yaml

    config_node01:
      contrail.database_node_present:
        name: ntw01
        ip_address: 10.0.0.33

'''

def __virtual__():
    '''
    Load Contrail module
    '''
    return 'contrail'


def virtual_router_present(name, ip_address, dpdk_enabled=False, **kwargs):
    '''
    Ensures that the Contrail virtual router exists.

    :param name:        Virtual router name
    :param ip_address:  Virtual router IP address
    '''
    ret = {'name': name,
           'changes': {},
           'result': True,
           'comment': 'Virtual router "{0}" already exists'.format(name)}
    virtual_router = __salt__['contrail.virtual_router_get'](name, **kwargs)
    if 'Error' not in virtual_router:
        pass
    else:
        __salt__['contrail.virtual_router_create'](name, ip_address, dpdk_enabled, **kwargs)
        ret['comment'] = 'Virtual router {0} has been created'.format(name)
        ret['changes']['VirtualRouter'] = 'Created'
    return ret


def virtual_router_absent(name, **kwargs):
    '''
    Ensure that the Contrail virtual router doesn't exist

    :param name: The name of the virtual router that should not exist
    '''
    ret = {'name': name,
           'changes': {},
           'result': True,
           'comment': 'Virtual router "{0}" is already absent'.format(name)}
    virtual_router = __salt__['contrail.virtual_router_get'](name, **kwargs)
    if 'Error' not in virtual_router:
        __salt__['contrail.virtual_router_delete'](name, **kwargs)
        ret['comment'] = 'Virtual router {0} has been deleted'.format(name)
        ret['changes']['VirtualRouter'] = 'Deleted'

    return ret


def analytics_node_present(name, ip_address, **kwargs):
    '''
    Ensures that the Contrail analytics node exists.

    :param name:        Analytics node name
    '''
    ret = {'name': name,
           'changes': {},
           'result': True,
           'comment': 'Analytics node {0} already exists'.format(name)}
    analytics_node = __salt__['contrail.analytics_node_get'](name, **kwargs)
    if 'Error' not in analytics_node:
        pass
    else:
        __salt__['contrail.analytics_node_create'](name, ip_address, **kwargs)
        ret['comment'] = 'Analytics node {0} has been created'.format(name)
        ret['changes']['AnalyticsNode'] = 'Created'
    return ret


def config_node_present(name, ip_address, **kwargs):
    '''
    Ensures that the Contrail config node exists.

    :param name:        Config node name
    '''
    ret = {'name': name,
           'changes': {},
           'result': True,
           'comment': 'Config node {0} already exists'.format(name)}
    config_node = __salt__['contrail.config_node_get'](name, **kwargs)
    if 'Error' not in config_node:
        pass
    else:
        __salt__['contrail.config_node_create'](name, ip_address, **kwargs)
        ret['comment'] = 'Config node {0} has been created'.format(name)
        ret['changes']['ConfigNode'] = 'Created'
    return ret


def bgp_router_present(name, type, ip_address, asn=64512, **kwargs):
    '''
    Ensures that the Contrail BGP router exists.

    :param name:        BGP router name
    '''
    ret = {'name': name,
           'changes': {},
           'result': True,
           'comment': 'BGP router {0} already exists'.format(name)}
    bgp_router = __salt__['contrail.bgp_router_get'](name, **kwargs)
    if 'Error' not in bgp_router:
        pass
    else:
        __salt__['contrail.bgp_router_create'](name, type, ip_address, asn, **kwargs)
        ret['comment'] = 'BGP router {0} has been created'.format(name)
        ret['changes']['BgpRouter'] = 'Created'
    return ret


def database_node_present(name, ip_address, **kwargs):
    '''
    Ensures that the Contrail database node exists.

    :param name:        Database node name
    '''
    ret = {'name': name,
           'changes': {},
           'result': True,
           'comment': 'Database node {0} already exists'.format(name)}
    database_node = __salt__['contrail.database_node_get'](name, **kwargs)
    if 'Error' not in database_node:
        pass
    else:
        __salt__['contrail.database_node_create'](name, ip_address, **kwargs)
        ret['comment'] = 'Database node {0} has been created'.format(name)
        ret['changes']['DatabaseNode'] = 'Created'
    return ret
