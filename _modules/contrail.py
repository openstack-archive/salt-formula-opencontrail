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

from netaddr import IPNetwork

try:
    from vnc_api import vnc_api
    from vnc_api.gen.resource_client import VirtualRouter, AnalyticsNode, \
        ConfigNode, DatabaseNode, BgpRouter
    from vnc_api.gen.resource_xsd import AddressFamilies, BgpSessionAttributes, \
        BgpSession, BgpPeeringAttributes, BgpRouterParams
    HAS_CONTRAIL = True
except ImportError:
    HAS_CONTRAIL = False

__opts__ = {}


def __virtual__():
    '''
    Only load this module if vnc_api library is installed.
    '''
    if HAS_CONTRAIL:
        return 'contrail'

    return False


def _auth(**kwargs):
    '''
    Set up Contrail API credentials.
    '''
    user = kwargs.get('user')
    password = kwargs.get('password')
    tenant_name = kwargs.get('project')
    api_host = kwargs.get('api_server_ip')
    api_port = kwargs.get('api_server_port')
    api_base_url = kwargs.get('api_base_url')
    use_ssl = False
    auth_host = kwargs.get('auth_host_ip')
    vnc_lib = vnc_api.VncApi(user, password, tenant_name,
        api_host, api_port, api_base_url, wait_for_connect=True,
        api_server_use_ssl=use_ssl, auth_host=auth_host)

    return vnc_lib


def _get_config(vnc_client, global_system_config = 'default-global-system-config'):
    try:
        gsc_obj = vnc_client.global_system_config_read(id=global_system_config)
    except vnc_api.NoIdError:
        gsc_obj = vnc_client.global_system_config_read(fq_name_str=global_system_config)
    except:
        gsc_obj = None

    return gsc_obj


def _get_rt_inst_obj(vnc_client):

    # TODO pick fqname hardcode from common
    rt_inst_obj = vnc_client.routing_instance_read(
        fq_name=['default-domain', 'default-project',
                 'ip-fabric', '__default__'])

    return rt_inst_obj


def _get_ip(ip_w_pfx):
    return str(IPNetwork(ip_w_pfx).ip)



def virtual_router_list(**kwargs):
    '''
    Return a list of all Contrail virtual routers

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.virtual_router_list
    '''
    ret = {}
    vnc_client = _auth(**kwargs)
    vrouter_objs = vnc_client._objects_list('virtual-router', detail=True)
    for vrouter_obj in vrouter_objs:
        ret[vrouter_obj.name] = {
            'ip_address': vrouter_obj.virtual_router_ip_address,
            'dpdk_enabled': vrouter_obj.virtual_router_dpdk_enabled
        }
    return ret


def virtual_router_get(name, **kwargs):
    '''
    Return a specific Contrail virtual router

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.virtual_router_get cmp01
    '''
    ret = {}
    vrouter_objs = virtual_router_list(**kwargs)
    if name in vrouter_objs:
        ret[name] = vrouter_objs.get(name)
    if len(ret) == 0:
        return {'Error': 'Error in retrieving virtual router.'}
    return ret


def virtual_router_create(name, ip_address, dpdk_enabled=False, **kwargs):
    '''
    Create specific Contrail virtual router

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.virtual_router_create cmp02 10.10.10.102
    '''
    ret = {}
    vnc_client = _auth(**kwargs)
    gsc_obj = _get_config(vnc_client)
    vrouter_objs = virtual_router_list(**kwargs)
    if name in vrouter_objs:
        return {'Error': 'Virtual router %s already exists' % name}
    else:
        vrouter_obj = VirtualRouter(
            name, gsc_obj,
            virtual_router_ip_address=ip_address)
        vrouter_obj.set_virtual_router_dpdk_enabled(dpdk_enabled)
        vnc_client.virtual_router_create(vrouter_obj)
    ret = virtual_router_list(**kwargs)
    return ret[name]


def virtual_router_delete(name, **kwargs):
    '''
    Delete specific Contrail virtual router

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.virtual_router_delete cmp01
    '''
    vnc_client = _auth(**kwargs)
    gsc_obj = _get_config(vnc_client)
    vrouter_obj = VirtualRouter(name, gsc_obj)
    vnc_client.virtual_router_delete(
        fq_name=vrouter_obj.get_fq_name())


def analytics_node_list(**kwargs):
    '''
    Return a list of all Contrail analytics nodes

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.analytics_node_list
    '''
    ret = {}
    vnc_client = _auth(**kwargs)
    node_objs = vnc_client._objects_list('analytics-node', detail=True)
    for node_obj in node_objs:
        ret[node_obj.name] = node_obj.__dict__
    return ret


def analytics_node_get(name, **kwargs):
    '''
    Return a specific Contrail analytics node

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.analytics_node_get nal01
    '''
    ret = {}
    vrouter_objs = analytics_node_list(**kwargs)
    if name in vrouter_objs:
        ret[name] = vrouter_objs.get(name)
    if len(ret) == 0:
        return {'Error': 'Error in retrieving analytics node.'}
    return ret


def analytics_node_create(name, ip_address, **kwargs):
    '''
    Create specific Contrail analytics node

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.analytics_node_create ntw03 10.10.10.103
    '''
    ret = {}
    vnc_client = _auth(**kwargs)
    gsc_obj = _get_config(vnc_client)
    analytics_node_objs = analytics_node_list(**kwargs)
    if name in analytics_node_objs:
        return {'Error': 'Analytics node %s already exists' % name}
    else:
        analytics_node_obj = AnalyticsNode(
            name, gsc_obj,
            analytics_node_ip_address=ip_address)
        vnc_client.analytics_node_create(analytics_node_obj)
    ret = analytics_node_list(**kwargs)
    return ret[name]


def analytics_node_delete(name, **kwargs):
    '''
    Delete specific Contrail analytics node

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.analytics_node_delete cmp01
    '''
    vnc_client = _auth(**kwargs)
    gsc_obj = _get_config(vnc_client)
    analytics_node_obj = AnalyticsNode(name, gsc_obj)
    vnc_client.analytics_node_delete(
        fq_name=analytics_node_obj.get_fq_name())


def config_node_list(**kwargs):
    '''
    Return a list of all Contrail config nodes

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.config_node_list
    '''
    ret = {}
    vnc_client = _auth(**kwargs)
    node_objs = vnc_client._objects_list('config-node', detail=True)
    for node_obj in node_objs:
        ret[node_obj.name] = node_obj.__dict__
    return ret


def config_node_get(name, **kwargs):
    '''
    Return a specific Contrail config node

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.config_node_get nal01
    '''
    ret = {}
    vrouter_objs = config_node_list(**kwargs)
    if name in vrouter_objs:
        ret[name] = vrouter_objs.get(name)
    if len(ret) == 0:
        return {'Error': 'Error in retrieving config node.'}
    return ret


def config_node_create(name, ip_address, **kwargs):
    '''
    Create specific Contrail config node

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.config_node_create ntw03 10.10.10.103
    '''
    ret = {}
    vnc_client = _auth(**kwargs)
    gsc_obj = _get_config(vnc_client)
    config_node_objs = config_node_list(**kwargs)
    if name in config_node_objs:
        return {'Error': 'Config node %s already exists' % name}
    else:
        config_node_obj = ConfigNode(
            name, gsc_obj,
            config_node_ip_address=ip_address)
        vnc_client.config_node_create(config_node_obj)
    ret = config_node_list(**kwargs)
    return ret[name]


def config_node_delete(name, **kwargs):
    '''
    Delete specific Contrail config node

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.config_node_delete cmp01
    '''
    vnc_client = _auth(**kwargs)
    gsc_obj = _get_config(vnc_client)
    config_node_obj = ConfigNode(name, gsc_obj)
    vnc_client.config_node_delete(
        fq_name=config_node_obj.get_fq_name())


def bgp_router_list(**kwargs):
    '''
    Return a list of all Contrail BGP routers

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.bgp_router_list
    '''
    ret = {}
    vnc_client = _auth(**kwargs)
    bgp_router_objs = vnc_client._objects_list('bgp-router', detail=True)
    for bgp_router_obj in bgp_router_objs:
        ret[bgp_router_obj.name] = bgp_router_obj.__dict__
    return ret


def bgp_router_get(name, **kwargs):
    '''
    Return a specific Contrail BGP router

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.bgp_router_get nal01
    '''
    ret = {}
    bgp_router_objs = bgp_router_list(**kwargs)
    if name in bgp_router_objs:
        ret[name] = bgp_router_objs.get(name)
    if len(ret) == 0:
        return {'Error': 'Error in retrieving BGP router.'}
    return ret


def bgp_router_create(name, type, ip_address, asn=64512, **kwargs):
    '''
    Create specific Contrail control node

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.bgp_router_create ntw03 control-node 10.10.10.103
        salt '*' contrail.bgp_router_create mx01 router 10.10.10.105
    '''
    ret = {}
    vnc_client = _auth(**kwargs)

    bgp_router_objs = bgp_router_list(**kwargs)
    if name in bgp_router_objs:
        return {'Error': 'control node %s already exists' % name}
    else:
        address_families = ['route-target', 'inet-vpn', 'e-vpn', 'erm-vpn',
                            'inet6-vpn']
        if type != 'control-node':
            address_families.remove('erm-vpn')

        bgp_addr_fams = AddressFamilies(address_families)
        bgp_sess_attrs = [
            BgpSessionAttributes(address_families=bgp_addr_fams)]
        bgp_sessions = [BgpSession(attributes=bgp_sess_attrs)]
        bgp_peering_attrs = BgpPeeringAttributes(session=bgp_sessions)
        rt_inst_obj = _get_rt_inst_obj(vnc_client)

        if type == 'control-node':
            vendor = 'contrail'
        elif type == 'router':
            vendor = 'mx'
        else:
            vendor = 'unknown'

        router_params = BgpRouterParams(router_type=type,
            vendor=vendor, autonomous_system=int(asn),
            identifier=_get_ip(ip_address),
            address=_get_ip(ip_address),
            port=179, address_families=bgp_addr_fams)
        bgp_router_obj = BgpRouter(name, rt_inst_obj,
            bgp_router_parameters=router_params)
        vnc_client.bgp_router_create(bgp_router_obj)
    ret = bgp_router_list(**kwargs)
    return ret[name]


def bgp_router_delete(name, **kwargs):
    '''
    Delete specific Contrail control node

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.bgp_router_delete mx01
    '''
    vnc_client = _auth(**kwargs)
    gsc_obj = _get_control(vnc_client)
    bgp_router_obj = BgpRouter(name, gsc_obj)
    vnc_client.bgp_router_delete(
        fq_name=bgp_router_obj.get_fq_name())


def database_node_list(**kwargs):
    '''
    Return a list of all Contrail database nodes

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.database_node_list
    '''
    ret = {}
    vnc_client = _auth(**kwargs)
    node_objs = vnc_client._objects_list('database-node', detail=True)
    for node_obj in node_objs:
        ret[node_obj.name] = node_obj.__dict__
    return ret


def database_node_get(name, **kwargs):
    '''
    Return a specific Contrail database node

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.database_node_get nal01
    '''
    ret = {}
    vrouter_objs = database_node_list(**kwargs)
    if name in vrouter_objs:
        ret[name] = vrouter_objs.get(name)
    if len(ret) == 0:
        return {'Error': 'Error in retrieving database node.'}
    return ret


def database_node_create(name, ip_address, **kwargs):
    '''
    Create specific Contrail database node

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.database_node_create ntw03 10.10.10.103
    '''
    ret = {}
    vnc_client = _auth(**kwargs)
    gsc_obj = _get_config(vnc_client)
    database_node_objs = database_node_list(**kwargs)
    if name in database_node_objs:
        return {'Error': 'Database node %s already exists' % name}
    else:
        database_node_obj = DatabaseNode(
            name, gsc_obj,
            database_node_ip_address=ip_address)
        vnc_client.database_node_create(database_node_obj)
    ret = database_node_list(**kwargs)
    return ret[name]


def database_node_delete(name, **kwargs):
    '''
    Delete specific Contrail database node

    CLI Example:

    .. code-block:: bash

        salt '*' contrail.database_node_delete cmp01
    '''
    vnc_client = _auth(**kwargs)
    gsc_obj = _get_database(vnc_client)
    database_node_obj = databaseNode(name, gsc_obj)
    vnc_client.database_node_delete(
        fq_name=database_node_obj.get_fq_name())
