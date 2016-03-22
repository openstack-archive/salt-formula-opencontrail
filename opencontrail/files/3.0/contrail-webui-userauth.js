{%- from "opencontrail/map.jinja" import web with context %}
/*
 * Copyright (c) 2014 Juniper Networks, Inc. All rights reserved.
 */

/****************************************************************************
 * Specify the authentication parameters for admin user
 ****************************************************************************/
var auth = {};
auth.admin_user = '{{ web.identity.user }}';
auth.admin_password = '{{ web.identity.password }}';
auth.admin_token = '{{ web.identity.token }}';
auth.admin_tenant_name = '{{ web.identity.tenant }}';

module.exports = auth;
