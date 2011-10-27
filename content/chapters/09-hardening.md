# Hardening #

Jasig CAS is security software and can provide secure Web-based single sign on reducing the proliferation of end user password exposures, improving both the reality and your confidence in the reality of security considerations in your environment.

## Use SSL ## 

This should probably go without saying, but: yes, you have to use SSL. Really. No, you can't just run CAS over `http://`. It won't be okay. And yes, your CAS-using service needs to use SSL too, or else authenticated sessions with it can be hijacked. Really. You have to use SSL. CAS ships not using SSL for ease of getting started with and trying out CAS, but your real production CAS implementation must use SSL.

## If you aren't using Proxy Tickets ## 

Proxy Tickets are a powerful, important, and potentially security-improving feature of the CAS single sign-on solution. You can use them to good effect in place of replaying end-user credentials or plenipotent service credentials that do not require participation in an end-user single sign-on session.

However, Proxy Tickets carry risk in that services accepting proxy tickets are responsible for validating the proxy chain (the list of services through which the end-user's authentication have been delegated to arrive at the ticket validating service). Services can opt out of accepting proxy tickets entirely (and avoid responsibility for validating proxy chains) by simply validating tickets against the `/serviceValidate` validation endpoint, but experience has shown it's easy to be confused about this and configure to unintentionally use the /proxyValidate endpoint yet not scrutinize any proxy chains that appear in the ticket validation response.

If your CAS environment is not (yet?) intending to make use of proxy tickets, consider un-mapping the `/proxyValidate` endpoint in your CAS server to prevent services from accidentally choosing to accept proxy tickets. Note that if you run a decentralized CAS server then you may not know whether and what services are making use of proxy tickets.

Historically any service could obtain a Proxy Granting Ticket and from it a Proxy Ticket to access any other service. That is, the security model is decentralized rather than centralized. You can centralize some of this through the Services Registry, by restricting which services are allowed to obtain proxy tickets, such that if you're careful to restrict all registrations from being allowed to acquire proxy tickets. This is one option for disabling proxy tickets.

However, you may sleep better at night if you disable the `/proxyValidate` endpoint outright. This is easy to do. Simply add `/WEB-INF/cas-servlet.xml` to your local CAS project if it's not there already, and then comment out or delete this element:

    <prop
      key="/proxyValidate">
        proxyValidateController
    </prop>
        
However, some versions of the phpCAS client library require the `/proxyValidate` endpoint even when only service tickets are accepted. If you simply remove the `/proxyValidate` mapping, this client library won't work with your CAS server and that may be annoying. Instead of removing the /proxyValidate endpoint outright, you could map it to the serviceValidateController behavior:

    <prop
      key="/proxyValidate">
        serviceValidateController
    </prop>
        
This will have the effect of making your `/proxyValidate` endpoint behave as `/serviceValidate` and reject all proxy tickets.

EDITOR NOTE: Wouldn't it be even better to disable the /proxy endpoint so that no service can acquire a PGT?  Yes, yes it would. This tip needs updated to do that instead.

## Configure Java DNS refresh intervals ##

Java server DNS refresh configuration is important in a CAS deployment in two places.

Firstly, services making use of CAS perform DNS lookups to figure out where the CAS server is to validate service ticket against it. If you move your CAS server and update DNS to give it a new IP address, you may want the CAS-relying services to figure this out and start using the new CAS server.

Secondly, CAS itself performs callbacks to services and may need to look them up in DNS in order to generate its single logout or proxy granting ticket vending callbacks. You may want CAS to be able to find the new IP address of a service if that service's DNS entry updates.

The Java Virtual Machine's default DNS cache timeout is configured in `$JRE_HOME/lib/security/java.security`

    networkaddress.cache.ttl=-1

(-1 means cache-forever, so Java will do a DNS lookup once and then use that cached domain-name-to-IP-address mapping forever until JVM restart.)

Set this to whatever saner timeout you'd like, in milliseconds, being appropriately wary of rogue DNS responders, but also being comforted that an incorrect DNS mapping won't expose sensitive information because you're using SSL (you are using SSL, right?  See above.)

    networkaddress.cache.ttl=14400

(See also the [JavaDoc for Java 6 InetAddress].)

EDITOR NOTE: Does this belong in the Hardening chapter, or would this go into the high availability chapter when discussing DNS role in HA?

[JavaDoc for Java 6 InetAddress]: http://download.oracle.com/javase/6/docs/api/java/net/InetAddress.html
