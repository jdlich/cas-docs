# Planning a CAS Deployment #

Planning a CAS deployment requires consideration of the application and platform ecosystem in light of security considerations, availability, and capacity.

## System Integration ##

Enterprise deployment planning begins with careful consideration of existing software and systems to be integrated with CAS including applications, identity management and authentication services, and other supporting enterprise services.

### CAS Client Integration ###

The following CAS clients can be employed to integrate most proprietary and open source applications:

* Java CAS Client
* .NET CAS Client
* mod_auth_cas module for Apache
* phpCAS

Additionally, custom applications developed in common languages/platforms are easily supported in most cases. In almost all cases Web applications are easily integrated with CAS. Difficulty commonly arises, however, with applications built on legacy frameworks such as database procedural languages (e.g. PL/SQL) or mainframe applications. These kinds of applications frequently require creative solutions for CAS integration, but there are many such examples in community-contributed integration solutions that showcase the flexibility of CAS.

<p class="note">EDITOR NOTE: This was a table in the DocBook version of this documentation, but converting inline HTML tables to tables in PDF as the Markdown document build is presently implemented proves difficult, so here this content has been refactored to no longer use a table.</p>

#### Outlook Web Access / Outlook Web Application ####

Use the .NET CAS Client and ClearPass Extension.

The .NET CAS Client is a core supported vended-by-Jasig CAS integration module. ClearPass is a community-supported CAS extension that is not part of the CAS server itself.

#### Apache httpd ####

Use mod_auth_cas.

mod_auth_cas is a core vended-by-Jasig CAS integration module.

#### ASP.NET ####

Use the .NET CAS Client.

The .NET CAS Client is a core supported vended-by-Jasig CAS integration module.

#### IIS7 ####

Use the .NET CAS Client.

The .NET CAS Client is a core supported vended-by-Jasig CAS integration module.

#### Java Servlets ####

Use the Jasig Java CAS Client.

The Jasig Java CAS Client is a core supported vended-by-Jasig CAS integration module.

#### Spring Security ####

Spring Security and the Jasig Java CAS Client

Spring Security is not vended by Jasig, but CAS server depends out of the box on Spring Security's CAS support for authenticating administrators to access the CAS Services Registry functionality. The Jasig Java CAS Client is a core supported vended-by-Jasig CAS integration module.

#### PHP Applications ####

Use phpCAS.

phpCAS is a core supported vended-by-Jasig CAS integration module.

#### Ruby on Rails ####

Use the [rubycas-client](http://code.google.com/p/rubycas-client/).

rubycas-client is not vended by Jasig.

#### Perl ####

Use [PerlCAS].

[PerlCAS]: http://sourcesup.cru.fr/projects/perlcas/

PerlCAS is not vended by Jasig.

#### IMAP Server ####

It may be feasible to use the `pam_cas` module, depending upon whether your IMAP server supports delegation to a pam module and is running on an OS affording pam module plugin points.

### Authentication ###

CAS must be integrated with one or more enterprise authentication systems such as LDAP/Active Directory. While it is most common to integrate CAS with a single enterprise authentication system, it is possible to integrate with multiple systems given the following important requirement.

#### Using Multiple Authentication Sources ####

The namespaces of each authentication source must be guaranteed to be unique in order to prevent ambiguity about the identity of the authenticating user. In particular neither a credential such as a username nor the name of the resolved principal may exist in more than one authentication source.

#### Available authentication handlers ####

CAS supports many ways of authenticating user credentials, including:

* validation against Active Directory, either via LDAP or Kerberos protocol
* JAAS (whereby CAS supports Kerberos)
* RDBMS / JDBC (database)
* LDAP
* RADIUS
* SPNEGO
* REMOTE_USER (Container authentication)
* X.509 Certificates

### Attribute Release ###

In addition to authenticating the user, CAS is capable of querying for additional attributes about a user following authentication in order to store and release some or all of this information to requesting services for the purposes such as authorization and personalization. Attribute data is commonly sourced from the same store as authentication data, but the design of attribute retrieval allows configuring multiple disparate attribute sources.

### Supporting Services ###

Many enterprises have services that may be leveraged by CAS. For example, the availability of enterprise database hosting might suggest the use of JpaTicketRegistry for the server ticket store. Likewise clustering hardware or software might be used by CAS for improved availability and/or capacity.

## Security Considerations ##

CAS deployment requires consideration of enterprise security concerns such as integration with IDM software, PKI, and security policy.

<p class="todo">TODO: complete this Security Considerations section.</p>

## Availability and Capacity Planning ##

Every enterprise deployment of CAS should be vitally concerned with availability and performance obtained through careful capacity planning.

<p class="todo">TODO: complete this Availability and Capacity Planning section.</p>

## Deployment Scenarios ##

We present some popular deployment scenarios for CAS with commentary on availability and performance characteristics.

<p class="todo">TODO: complete this Deployment Scenarios section. E.g. "Single Client/Single Server"</p>
