#
# Cookbook Name:: glassfish
# Attribute File:: glassfish
#
# Copyright 2009, Opscode, Inc.
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
#
#openInstaller Dry Run Answer File.  This File can be used as input to the openInstaller engine using the -a option.

# unis system user
default[:glassfish][:systemuser]="glassfish"
#unix system group
default[:glassfish][:systemgroup]="glassfish"
# fetch_url
default[:glassfish][:fetch_url]="http://download.java.net/glassfish/v3-prelude/promoted/glassfish-v3-prelude-b28f-unix.sh"
#InstallHome.directory.INSTALL_HOME=
default[:glassfish][:INSTALL_HOME]="/opt/glassfishv3-prelude"
#License.license.ACCEPT_LICENSE=0
default[:glassfish][:ACCEPT_LICENSE]="0"
#RegistrationOptions.regoptions.CREATE_NEWACCT=CREATE_NEWACCT
default[:glassfish][:CREATE_NEWACCT]="CREATE_NEWACCT"
#RegistrationOptions.regoptions.DUMMY_PROP=
default[:glassfish][:DUMMY_PROP]=""
#RegistrationOptions.regoptions.SKIP_REGISTRATION=SKIP_REGISTRATION
default[:glassfish][:SKIP_REGISTRATION]="SKIP_REGISTRATION"
#RegistrationOptions.regoptions.USERNAME=
default[:glassfish][:USERNAME]=""
#RegistrationOptions.regoptions.USERPASSWORD=
default[:glassfish][:USERPASSWORD]=""
#RegistrationOptions.regoptions.USE_EXISTINGACCT=USE_EXISTINGACCT
default[:glassfish][:USE_EXISTINGACCT]="USE_EXISTINGACCT"
#SOAccountCreation.accountinfo.COMPANYNAME=
default[:glassfish][:COMPANYNAME]=""
#SOAccountCreation.accountinfo.COUNTRY=
default[:glassfish][:COUNTRY]=""
#SOAccountCreation.accountinfo.COUNTRY_DROP_DOWN=
default[:glassfish][:COUNTRY_DROP_DOWN]=""
#SOAccountCreation.accountinfo.EMAIL=
default[:glassfish][:EMAIL]=""
#SOAccountCreation.accountinfo.FIRSTNAME=
default[:glassfish][:FIRSTNAME]=""
#SOAccountCreation.accountinfo.LASTNAME=
default[:glassfish][:LASTNAME]=""
#SOAccountCreation.accountinfo.PASSWORD=
default[:glassfish][:PASSWORD]=""
#SOAccountCreation.accountinfo.REENTERPASSWORD=
default[:glassfish][:REENTERPASSWORD]=""
#glassfish.Administration.ADMIN_PASSWORD=adminadmin
default[:glassfish][:ADMIN_PASSWORD]="adminadmin"
#glassfish.Administration.ADMIN_PORT=4848
default[:glassfish][:ADMIN_PORT]="4848"
#glassfish.Administration.ADMIN_USER=admin
default[:glassfish][:ADMIN_USER]="admin"
#glassfish.Administration.ANONYMOUS=ANONYMOUS
default[:glassfish][:ANONYMOUS]="ANONYMOUS"
#glassfish.Administration.LOGIN_MODE=true
default[:glassfish][:LOGIN_MODE]="true"
#glassfish.Administration.HTTP_PORT=8080
default[:glassfish][:HTTP_PORT]="8081"
# Can be set to anonymous or non_anonymous, to require administrator to log in with user name and password.
# glassfish.Administration.NON_ANONYMOUS=NON_ANONYMOUS
default[:glassfish][:NON_ANONYMOUS]="NON_ANONYMOUS"
#updatetool.Configuration.ALLOW_UPDATE_CHECK=true
default[:glassfish][:ALLOW_UPDATE_CHECK]="false"
#updatetool.Configuration.BOOTSTRAP_UPDATETOOL=true
default[:glassfish][:BOOTSTRAP_UPDATETOOL]="false"
#updatetool.Configuration.PROXY_HOST=
default[:glassfish][:PROXY_HOST]= ""
#updatetool.Configuration.PROXY_PORT=
default[:glassfish][:PROXY_PORT]= ""

