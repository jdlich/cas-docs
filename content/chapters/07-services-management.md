# Services Management #

The CAS Services Management features allows CAS server administrators to declare and configure which services (applications) may make use of CAS in which ways.

## Must I use the Services Registry? Must services be registered? ##

Technically, yes to both. Practically, no to both.

Yes, in the latest CAS releases, under the hood, you'll always be using the Services Registry and every service must match a service registration or else the service can't use CAS. However, the default in-memory services registry includes default wildcard matching service registrations such that any `http://` or `https://` service can all CAS features. If you don't want to use the Services Registry to replace those wildcard registrations with registrations restricting to and configuring the services you'd like to allow to use your CAS server, simply do nothing.

If you are using the services registry, you don't have to use the Web-based tooling to administer it. You can instead maintain your service registrations as Spring-wired beans in the `deployerConfigContext.xml` file. However, presently updates to this file require a CAS server restart to take effect, so not using the Web-based services registry UI eliminates your ability to make live registration changes.

## Registered Services ##

First, let's understand in excruciating detail what is meant by a "service" and what can be registered about it.

### What's a service? ###

A service is an application that accepts CAS authentication, that is, an application to which a user or another service can authenticate via CAS.

### Service Name and Description ### 

Service registrations have a name. The only purpose of this name is to uniquely identify the service within the Services Registry.

Likewise, service registrations also each have a description. This description is solely for your administrative sanity -- a place to put notes about the service, what it is, and why it is configured the way it is. Currently, the description is not used for any purpose (e.g., it is not displayed to end users).

### Service URL ### 

Service registrations have a service URL. This is the attribute whereby CAS matches a request to use CAS at runtime with service registry registrations. This can be a URL or a URL-like string using Ant-style pattern matching, e.g. `https://apps.example.com/**` to match any Web application running on `https://apps.example.com`.

### Theme Name ### 

CAS supports per-service theming such that a different Spring WebMVC "theme" (set of styles) can be applied depending upon what service the end user is attempting to log into. This is one option for customizing the login experience depending upon which application the user seeks to log into.

### Enable/Disable ### 

A service registration can be disabled, preventing services matching the registration from using CAS.

A disabled service registration is different from not having the registration at all in that if CAS matches the disabled registration, the service is prevented from using CAS, whereas if the registration were not present at all, another registration with a lower priority order might have matched were this disabled registration not blocking.

### SSO Participant ### 

Registrations can specify that the registered service is forbidden to participate in CAS single sign-on. The application can still use CAS for authentication, but users will always be prompted to present credentials (e.g. present username and password) to log in to the service and will never be transparently autheticated on the basis of an established CAS single sign-on session.

### Anonymous Access ### 

Normally in the CAS protocol, CAS releases the end user's username to a service successfully relying upon CAS for authentication. However, when the service's registration specifies anonymous access, CAS generates a per-service per-user opaque persistent identifier (functionally, a big random number) to identify the user rather than releasing the end user's username. CAS will provide the same identifier to the same service when the same user authenticates subsequently, so the service will be able to identify the user across logins, but will not be able to correlate the user with other systems using this identifier since the identifier is unique to the service. (If the user accesses another service registered to receive an opaque identifier, a different such identifier will be consistently presented to that service, such that, using only these identifiers, the two services are not able to compare notes and determine that they've been interacting with the same user.

Of course, many sneaky techniques exist to identify, track and correlate users. The typical web browser has a "fingerprint" that may uniquely identify it within some scope and the typical user may give up his email address in exchange for a smiley.

Many applications, especially enterprise applications, need the username in order to query other systems to build the user account and service the user's request.

### Allowed to proxy ### 

Service registrations specify whether a registered service is allowed to proxy, that is, allowed to use CAS delegated authentication features to obtain proxy tickets to proxy authentication to other applications.

Note that this is configuration of whether the service is able to proxy authentication, not whether the service accepts proxy authentication.

This is coarse-grained configuration as to whether the serivce is allowed to obtain proxy tickets at all or not, not configuration of to which services the registered service is allowed to proxy authentication. As such, this is not a substitute for scrutinizing proxy chains in proxy-ticket-accepting CAS-using applications, in the case where multiple services are allowed to obtain proxy tickets and should be allowed to access different backing services with those proxy tickets.

#### Currently implemented as preventing Proxy Granting Ticket acquisition #### 

The allowed to proxy feature is currently implemented such that services disabled from proxying are disabled from acquiring new Proxy Granting Tickets but not from acquiring new Proxy Tickets from already-issued Proxy Granting Tickets. As such, disabling a service registration from proxying in a live running CAS server will not immediately prevent that application from proxying authentication, it will only prevent it from proxying authentication in the course of new logins to it from the point of the configuration change onward.

### User attributes ### 

Service registrations allow you to select which user attributes will be released to the registered service if and when the service exercises validation services that can include user attributes (i.e., the SAML validation endpoint.)

### Evaluation Order ### 

Each registration has an evaluation order so that you can control the order in which CAS attempts to match the registrations to a service URL encountered at runtime.

## Options for Services Management Persistence ## 

There are two options for the backing implementation of the ServicesManager. There's an in-memory implementation (used by default) and a JPA-backed implementation (that stores service registrations into a database).

### In-Memory Services Registry ### 

CAS uses in-memory services management by default, with the registry seeded from registration beans wired via Spring. This is a read-write implementation in that you can edit the registrations live via the Services Registry Web interface, but these changes are not written back to the Spring bean XML files, so _any changes made to service registrations through the Web-based Services Registry administrative UI will be lost on stopping the CAS server web application_. The in-memory implementation is more quickstart example than anything else, though you can choose to use it in production, maintaining your service registry data in Spring bean wiring XML, so long as you're okay with not being able to persist changes made through the live admin UI and with not being able to make changes in the XML take effect without a CAS server restart.

In practice, the in-memory registry implementation will only be attractive to CAS adopters making trivial use of the Services Registry features, e.g. using broadly matching patterns in a few service registrations. If you're only going to have one registration that allows any service to use CAS anyway, there's no need to go to the trouble of making that live-editable or stored anywhere special.

#### Changes made to service registrations when using the In-Memory Services Registry are lost on CAS server restart #### 

While the in-memory implementation supports using the Services Registry UI to edit the live registration data, it does not persist these changes anywhere, so _all of your careful data entry will be lost on CAS server restart_.

### JPA Services Registry ### 

CAS includes a JPA services registry implementation that stores service registrations in a database. This is the commonly adopted option for CAS instances making use of administratively live-editable service registrations.

## Web-based Services Management UI ## 

CAS includes a Web-based administrative UI for managing service registrations.

First we'll configure the URLs associated with the services management UI and authorize a user to access it.  Then we'll actually access it.

### Configuring URLs to the Services Management UI in cas.properties ###

TIP: If your CAS server is deployed to `http://localhost:8080` (as in, say, you've naively deployed CAS to an unconfigured Tomcat instance installed on your local computer) and you're not yet using SSL, then you need not change any of the `cas.properties` properties.

The file `cas.properties` includes several properties that configure CAS to know the URL to its own services management feature and to its own CAS server endpoints . These URLs configure the use of Spring Security to secure access to the administrative panes.

`server.prefix` was introduced in CAS 3.4.10 and specifies the protocol (`http` or `https`), hostname, non-default port, and path to the CAS server web application. It is a convenience property so that you can update this in one line rather than having to tweak the `cas.securityContext.serviceProperties.service`, `cas.securityContext.casProcessingFilterEntryPoint.loginUrl`, and `cas.securityContext.casProxyTicketValidator.casValidate` properties individually. If you're using an older version of CAS 3.4, then you should upgrade, but in the meantime, no worries, you can configure those other properties individually or simply add the `server.prefix` property. If you're using CAS 3.4.10, great, set this one `server.prefix` property to have a value like `https://mycasserver.com:8993/caswebapp`. `http://localhost:8080/cas` is what you want for the simplest possible example of trying out CAS in an unconfigured Tomcat on your laptop, and is the default value.

`cas.securityContext.serviceProperties.service` specifies the Service URL associated with the CAS Services Registry webapplication itself. The value of this property will be the value of the service parameter on the CAS login redirect generated by Spring Security when you try to access the Services Registry UI with a not-yet-authenticated browser session.

`cas.securityContext.casProcessingFilterEntryPoint.loginUrl` specifies the CAS server login URL. This will be the URL of the redirect Spring Security generates when you try to access the Services Registry web user interface with a not-yet-authenticated session.

`cas.securityContext.casProxyTicketValidator.casValidate` specifies the CAS server endpoint whereat Spring Security will validate the Service Ticket it obtains in logging the administrator in via CAS.

__Note:__ Linebreaks are introduced to make documentation fit in below listings. In documentation formatting, the `cas.securityContext.serviceProperties.service` property key and its value appear on separate lines to get the documentation to fit on the page. However, in the real cas.properties, a property key, equals character, and property value must all be on a single line.

These properties in `cas.properties` have these values by default:

    server.prefix=http://localhost:8080/cas

    cas.securityContext.serviceProperties.service=
      ${server.prefix}/services/j_acegi_cas_security_check
    cas.securityContext.casProcessingFilterEntryPoint.loginUrl=${server.prefix}/login
    cas.securityContext.ticketValidator.casServerUrlPrefix=${server.prefix}
                     
... whereas they would have these values if your CAS server is deployed as a web application named "cas" to `https://secure.its.yale.edu` running on the default `https://` port...

    server.prefix=https://secure.its.yale.edu/cas

    cas.securityContext.serviceProperties.service=
      ${server.prefix}/services/j_acegi_cas_security_check
    cas.securityContext.casProcessingFilterEntryPoint.loginUrl=${server.prefix}/login
    cas.securityContext.ticketValidator.casServerUrlPrefix=${server.prefix}
                     
Notice that only server.prefix changed. That's the intended convenience of server.prefix.

__Note:__  As in the example, you'll need to change these URLs if they differ in your environment, i.e. if you're accessing CAS at a host other than localhost or a port other than 8443.

### Authorizing users to access the Services Management tool ###

By default, no users can access the CAS management UI.

In deployerConfigContext.xml, you can enumerate users allowed to log in to the Services Registry administrative Web application:

    <sec:user-service id="userDetailsService">
      <sec:user name="some_trusted_username" password="notused"
       authorities="ROLE_ADMIN" />
      <sec:user name="another_trusted_username" password="notused"
       authorities="ROLE_ADMIN" />
    </sec:user-service>
                    
You can list as many authorized users as you like. The password attribute isn't used because by default you're configuring a set of authorized users who will authenticate using CAS. (Yes, by default, administrators use CAS to authenticate to the administrative panels in CAS.) However, this is using Spring Security, so you can replace more of this wiring and instead configure Spring Security to authenticate users in some other way.

The services registry has only one role, but the key of that role is configured in `cas.properties`, so you can use something other than `ROLE_ADMIN` if you want -- that might make sense if you reconfigured Spring Security to use an external user details service that has more roles in it beyond the single in-or-out role used for the CAS Services Registry.

Usernames enumerated in the user details service with authority `ROLE_ADMIN` will be able to access the Services Registry interface. All other users will be denied access.

### URL to the Services Management UI ###

The CAS Services Management UI is available at the path `/services/` within your CAS server. If your CAS webapp is named "cas" and you've deployed it at `http://localhost:8080`, then the URL to the CAS server services management UI is `http://localhost:8080/cas/services` or, if you're using SSL, `https://localhost:8443/cas/services`.

### Using the Web-based services registry administrative UI ###

Once you reach the Services Registry, it looks like this:

![Managing registered services](media/services_edit.jpg)

The front page of the services registry lists the existing service registrations, providing summary information about these registrations and controls to edit them.

#### Deleting an Existing Service ####

You can delete an existing service registration from this summary screen.

WARNING: There's no undo. If you delete a registration, it's gone.

#### Registering a New Service #### 

You can register a new service.

![Registering a new service](media/add_service_registration_1024_872.jpg)

#### Editing an Existing Service Registration #### 

You can also edit an existing service registration, using a very similar UI.
