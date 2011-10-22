# Introduction #

![Big picture diagram](media/sso-diagram.png)

CAS is a multiprotocol Web single sign-on (SSO) product composed of a single logical server component that services authentication requests from multiple CAS clients that communicate via one or more supported protocols. The CAS server delegates authentication decisions to any number of supported authentication mechanisms including LDAP/Active Directory, Kerberos, and RDBMS. The hallmark of CAS is ease of integration and extension in support of a wide variety of environments. In addition to supporting a large number of technologies out of the box, the well-documented API extension points have enabled deployers to develop custom components to support novel use cases not supported by default.

## Features ##

CAS has a number of features that distinguish it from other SSO products:

### Single Sign-On (SSO) Implementation ###

Unlike many SSO products, CAS does not use shared cookies to authenticate to services within the SSO domain. The CAS implementation uses a secure SSO session identifier (ticket-granting ticket in CAS protocol parlance), shared exclusively with the CAS server, to generate one-time-use credentials (service tickets in CAS protocol parlance) that are used to access services within the SSO domain. Passing the "master key" session identifier exclusively between the user's browser and CAS server dramatically limits the potential for man-in-the-middle attacks on the session identifier. CAS benefits from increased security in this regard over shared cookie strategies.

### Integration ###

CAS client integration components are available for all popular Web development frameworks and many popular Web applications.

#### Popular CAS Clients ####

* Java
* Microsoft .NET Framework
* PHP
* Outlook Web Access
* Drupal
* Confluence

The combination of open protocols and open source facilitate the development of integration components for almost any product as has been demonstrated over many years by the development of components for frameworks as varied as PL/SQL and Cold Fusion.


### Authentication Providers ###

The CAS server authenticates users by means of the AuthenticationHandler component for which a number of implementations are provided with the CAS distribution.

#### Bundled Authentication Providers ####

* LDAP (e.g. Active Directory, OpenLDAP)
* RDBMS
* SPNEGO
* X.509/Client SSL
* JAAS
* RADIUS
* Flat file

CAS has a proven track record of supporting custom authentication providers such as proprietary Web services. Adopters leverage the open and well-documented source to develop custom AuthenticationHandler components and wire them into the application using Spring XML configuration. The result is straightforward extension for virtually any authentication need.

### Authorization ###

CAS approaches authorization from the perspective that authorization is the responsibility of individual services that authenticate to CAS. This design owes to the history of CAS having been developed in the Higher Education setting, which is typically highly decentralized and ill suited to agreement and enforcement of centralized authorization policy. CAS supports decentralized authorization via an attribute release mechanism where any number of stores may be configured to load and store attributes about principals upon authentication to CAS, and which are released to services when they authenticate to CAS. Attributes are interpreted by services as needed, commonly for authorization and personalization.

## Support ##

CAS is supported by a community of developers and users via a variety of means.

* Product documentation (like this manual)
* Real-time user support via the <cas-user@lists.jasig.org> mailing list
* Discussion via Internet Relay Chat (IRC) in the `#jasig-cas` channel on `irc.freenode.net`. Note that while several CAS developers and adopters typically hang out in this IRC chat room, the project has no commitment to 24x7 support via that mechanism and you may be better off directing your question to the `cas-user@` email list.
* Conferences and webinars

### Commercial Support Channels ###

In addition to community support, the Jasig CAS project has a [CAS Solutions Providers][] program for recognizing vendors and consultants that provide services related to Jasig CAS. Please note that acceptance in the Solution Provider Program does not constitute an endorsement or recommendation by Jasig.

[CAS Solutions Providers]: http://www.jasig.org/cas/support/solutions-providers "Jasig CAS Solutions Providers program page"

Current CAS Solution Provider:

* [Unicon Inc.][] (a [Jasig Partner][]), [Cooperative Support for CAS][] and [consulting services related to CAS][unicon-cas-consulting].

[Unicon Inc.]: http://www.unicon.net/ "Unicon Inc. homepage"
[Jasig Partner]: http://www.jasig.org/jasig-membership-partners "Jasig webpage about Jasig Partner program"
[Cooperative Support for CAS]: http://www.unicon.net/services/cas/support "Unicon Inc. Cooperative Suppport for CAS webpage"
[unicon-cas-consulting]: http://www.unicon.net/services/cas "Unicon Inc. CAS services webpage"





