# Architecture #

The CAS architecture can be described in terms of system components including the clients and server that communicate via supported protocols.

![architecture diagram](media/architecture.png)

## System Components ##
The CAS server and clients comprise the two physical components of the CAS system architecture that communicate by means of various protocols.

### CAS Server ##

The CAS server application is Java servlet built on the Spring Framework whose primary responsibility is to authenticate users and grant access to CAS-enabled services, commonly called CAS clients, by issuing and validating tickets. An SSO session is created when the server issues a ticket-granting ticket (TGT) to the user upon successful login. A service ticket (ST) is issued to a service at the user's request via browser redirects using the TGT as a token. The ST is subsequently validated at the CAS server via back-channel communication. These interactions are described in great detail in the [CAS Protocol document].

[CAS Protocol document]: http://www.jasig.org/cas/protocol

### CAS Clients ###

The term "CAS client" has two distinct meanings in its common use. A CAS client is any CAS-enabled application that can communicate with the server via a supported protocol. A CAS client is also a software package that can be integrated with various software platforms and applications in order to communicate with the CAS server using or or more supported protocols. CAS clients supporting a number of software platforms and products have been developed.

#### Software Platforms ####

Software integration libraries for making use of the CAS server are available for, among others, these platforms.  

* Apache httpd Server (via the mod_auth_cas module)
* Java (via the Jasig Java CAS Client)
* .NET (via the .NET CAS Client)
* PHP (via phpCAS)
* Perl (via PerlCAS)
* Python (via pycas)
* Ruby (via rubycas-client)

#### Applications ####

Examples of some applications that can be CASified, that is, made to acts as clients of the CAS server.

* Atlassian Confluence (via a plugin)
* Atlassian JIRA (via a plugin)
* Drupal (via a module)
* Liferay (via built-in support)
* Outlook Web Application (via ClearPass Extension and .NET CAS Client)
* uPortal (via built-in support)

When the term "CAS client" appears in this manual without further qualification, it refers to the integration components such as the Jasig Java CAS Client rather than to the application relying upon (a client of) the CAS server.

## Protocols ##

Clients communicate with the server by any of several supported protocols. All the supported protocols are conceptually similar, yet some have features or characteristics that make them desirable for particular applications or use cases. For example, the CAS protocol supports delegated (proxy) authentication, and the SAML protocol supports attribute release and single sign-out.

### CAS Protocol ###

The CAS protocol is a simple and powerful ticket-based protocol developed exclusively for CAS. The CAS protocol has two general versions, version 1 is a simple text-based protocol, while version 2 is an XML-based  protocol that supports a novel form of delegated authentication called "proxy authentication." CAS is one of the few SSO products to support this kind of feature. A complete protocol specification, including versions 1 and 2, may be found at <http://www.jasig.org/cas/protocol>.

#### CAS protocols shared across CAS software versions ####

The CAS 3.4 server software speaks the CAS 1 and CAS 2 protocols. Integrations with CAS via the CAS protocol should be independent of particular versions of the CAS server software. That is, client libraries should work with CAS, not merely work with some particular version of the CAS server software, by virtue of these protocols remaining unchanged across CAS 2 and CAS 3 versions. CAS server 3.4 (which this manual documents) speaks the same CAS protocol that CAS 3.3, 3.2, 3.1, 3.0, and even Yale CAS Server 2 versions speak, and so client libraries shouldn't need to or even be able to differentiate among these.

Additional features not originally in the CAS protocol have been added (such as single logout callbacks), but support for the CAS protocol as defined remains.

### SAML ###

#### SAML 1.1 ####

CAS provides limited support for the SAML 1.1 protocol. SAML support was adopted to leverage a standardized protocol for two important use cases:

* Attribute release, where attributes describe the authenticated principal (that is, whoever logged in)
* Single sign-out (via callbacks to participating applications advising them of single sign-on session termination).

#### SAML 2 ####

CAS provides limited support for the SAML2 protocol.

### OpenID ###

The CAS server has limited support for acting as an OpenID identity provider, which allows integration with applications and services such as Google Apps and Salesforce.com. The OpenID protocol spefication is maintained as [a set of specifications for different protocol aspects](http://openid.net/developers/specs/).

## Server Software Components ##

In order to facilitate discussion of configuration and deployment in following chapters, it is helpful to provide an overview of server software components. CAS server software components are described in terms of Java interfaces that form an API that organizes the application source code and provides configuration and extension points for deployers. The following sections discuss the core interfaces of the CAS server API.

### Authentication ###

CAS supports two distinct notions of authentication, user and service authentication. For the purposes of this user manual, "authentication" means user authentication where a user presents some credential(s) for CAS to validate. The service authentication process will be referred to as an "access." There are a number of components that deal with user authentication that are described in detail in the following sections. 

<p class="note">Editorial note: Does this documentation consistently use 'access' in this way?  May need to keep an eye on this.</p>

#### Principal Name Transformer ####

The PrincipalNameTransformer interface allows customization of the provided user name prior to authentication. A common use case of this component is to add a domain suffix to the username such that a fully-qualified username will be used to perform authentication.

#### Authentication Handlers ####

The AuthenticationHandler interface describes the contract by which users present credentials for validation and simply return a boolean true/false value for success/failure. Authentication handlers are the integration point with identity management systems including directories and databases.

#### Authentication Managers ####

The AuthenticationManager interface describes the strategy by which AuthenticationHandlers will be evaluated to determine authentication success or failure.

#### Authentication Meta Data Populators ####

The AuthenticationMetaDataPopulator interface supports adding arbitrary meta data to the CAS authentication event. A common use case would be to store the authentication method or level of assurance of the user's credential.

### Principal ###

A principal describes an authenticated user, including a unique identifier over one or more identity management systems. The principal may also contain arbitrary attributes describing the user, such as display name and security groups. These attributes may used to facilitate authorization and personalization in CAS client applications using CAS via protocols that convey user attributes.

#### Credential-to-Principal Resolver ####

Upon successful authentication, CAS relies upon a CredentialsToPrincipalResolver to map the succesfully authenticating credentials onto a principal. A CredentialToPrincipalResolver might be trivial in the common use case of relying upon the username of a correct username/password pair, or a CredentialToPrincipalResolver in principle might be more sophisticated in mapping authenticated credentials to a namespace.

### Security Policy ###

CAS provides a number of configurable and extensible components to control various aspects of security policy including SSO session timeouts, cryptographic strength of tickets/identifiers, and pre-authentication/post-authentication actions.

#### Services Registry ####

The ServiceRegistry component is responsible for defining the allowed services that may request and validate tickets provided by CAS as well as other service-specific concerns:

* Authorization to perform delegated authentication (proxy)
* Attribute release policy
* Whether or not service can participate in single sign-on (non-participating services can still use CAS for user login, but the user will be prompted to authenticate on each login to the service)
* Selection of per-service UI theme

#### Ticket Expiration Policy ####

The TicketExpirationPolicy component defines the lifecycle policy for various types of tickets.

Expiration policies support finite timeout expiration, sliding scale expiration, limiting  ticket to N uses, and everlasting tickets. The policy contract is simple to facilitate development of custom policies.

#### Identifier Generators ####

CAS ships with configurable generators for identifiers. Ticket identifiers are key to the CAS security model in it not being feasible to guess valid identifiers.

* NumericGenerator - Generates sequential integer identifiers
* RandomStringGenerator - Generates random string identifiers
* UniqueTicketIdGenerator - Generates unique identifiers for use in tickets

#### Handler Interceptors ####

CAS supports the use of the Spring HandlerInterceptor component to instrument certain operations such as authentication and ticket validation. CAS leverages this component to implement security policies such as login throttling, although other security policies could easily be developed.

### Ticket Registry ###

The TicketRegistry component is a ticket storage abstraction layer. CAS supports a number of implementations out of the box where all except the default in-memory storage are suitable for HA environments:

* Memory - DefaultTicketRegistry (default)
* Database - JpaTicketRegistry
* Memcached - MemCacheTicketRegistry
* JBoss Cache - JBossCacheTicketRegistry

### Login workflow ###

The CAS login workflow is not an interface per se, but is a workflow implemented in Spring WebFlow that can be customized to support novel use cases. Customizing logical transitions, decision  points, and start/end states is straightforward and can generally be done by editing XML, while defining new actions typically requires development of actions in Java.
              
(See also the recording of Adam Rybicki's presentation at the 2010 Jasig conference on [Extending CAS Using Spring Web Flow])

[Extending CAS Using Spring Web Flow]: http://vimeo.com/11631079



