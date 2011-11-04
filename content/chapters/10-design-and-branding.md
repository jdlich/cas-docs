---
title: Design and Branding
---

# Design and Branding

Branding the CAS log in UI involves simply editing the CSS stylesheet and also a small collection of relatively simple JSP include files (also known as views).

EDITOR NOTE: All the files that we'll be discussing in this section that concern the theme are located in and referenced from: `[CAS_ROOT]/cas-server-webapp/src/main/webapp`

## Getting Started

When creating a new theme in CAS, there is not an easy way to preserve existing themes (including the default theme). The problem is specifically with the JSP. There's simply not a system in place to keep all of a specific theme's resources (JSP, in particular) independent of other themes without manually editing hardcoded paths.

So, practically the only approach is to override the existing default theme.

EDITOR NOTE: Although, if your skin does not require changes to the JSP views, you can simply create a new `css` file and point to it from within `WEB-INF/classes/cas-theme-default.properties`

### CSS

The default styles are all contained in a single file located in `css/cas.css`. This location is set in `WEB-INF/classes/cas-theme-default.properties`. (Ignore the themes folder, for now; it's an unsolved mystery.)

The location of the theme's CSS file is configured in 'WEB-INF/classes/cas-theme-default.properties'. If you would like to create your own `css/custom.css` file, for example, you will need to update `standard.custom.css.file`:

	standard.custom.css.file=css/custom.css

CAS uses the [Fluid Skinning System]() CSS framework. More details about FSS can be found on their website.

[Fluid Skinning System]: http://wiki.fluidproject.org/display/fluid/Fluid+Skinning+System+%28FSS%29

### Images

There are 2 `images` folders. Ignore `css/images`, which is designated for the mobile theme. Put your images in `images`.

### JavaScript

If you need to add some JavaScript, feel free to append `js/cas.js`.

You can also create your own `custom.js` file, for example, and call it from within `WEB-INF/view/jsp/default/ui/includes/bottom.jsp` like so:

	<script type="text/javascript" src="<c:url value="/js/custom.js" />"></script>

### JSP

The main log in page (the CAS "home page") is located at `WEB-INF/view/jsp/default/ui/casLoginView.jsp`. And there you will find the rest of the JSP files as well.

Notice `top.jsp` and `bottom.jsp` include files located in `WEB-INF/view/jsp/default/ui/includes`. These serve as the layout template for the other JSP files, which get injected in between during compilation to create a complete HTML page.

The location of these JSP files are configured in `WEB-INF/classes/default_views.properties`.

## Workflow

After you make changes, the quickest way to see the results in a browser is to copy them to tomcat. You do not need to rebuild CAS every time you make a change.

`rsync` is a handy (and powerful) command line utility that is perfect for the job.

Here's the command that I use in my skinning projects:

	rsync -ruv --exclude '*svn' CAS_ROOT/cas-server-webapp/src/main/webapp/* TOMCAT_ROOT/webapps/cas/

*(Make sure to replace `CAS_ROOT` and `TOMCAT_ROOT` with the appropiate paths.)*

This will copy only the files that have been changed and give some friendly output.

For more information on 	`rsync` refer to the help menu like any other command line utility:

	rsync --help

## Glossary of Views

**authorizationFailure**  
Displayed when a user successfully authenticates to the services management web-based administrative UI included with CAS, but the user is not authorized to access that application.

**brokenContext**  
Displayed when CAS fails (typically at servlet context initialization, i.e. when the CAS application is first deployed or when Tomcat is started), with an ApplicationContextException, typically indicating an error in a Spring configuration file.

**casConfirmView**  
Displayed when the user is warned before being redirected to the service.  This allows users to be made aware whenever an application uses CAS to log them in. (If they don't elect the warning, they may not see any CAS screen when accessing an application that successfully relies upon an existing CAS single sign-on session.) Some CAS adopters remove the 'warn' checkbox in the CAS login view and don't offer this interstitial advisement that single sign-on is happening.

**casGenericSuccess**  
Displayed when the user has been logged in without providing a service to be redirected to.

**casLoginView**  
Main login form.

**casLogoutView**  
Displayed when the user logs out.

**errors** 
Displayed when CAS experiences an error it doesn't know how to handle (an unhandled Exception). For instance, CAS might be unable to access a database backing the services registry. This is the generic CAS error page. It's important to brand it to provide an acceptable error experience to your users.

**serviceErrorView**  
Used in conjunction with the service registry feature, displayed when the service the user is trying to access is not allowed to use CAS. The default in-memory services registry configuration, in 'deployerConfigContext.xml', allows all users to obtain a service ticket to access all services.

**serviceErrorSsoView**   
Displayed when a user would otherwise have experienced noninteractive single sign-on to a service that is, per services registry configuration, disabled from participating in single sign-on. (In the default services registry registrations, all services are permitted to participate in single sign-on, so this view will not be displayed.)

## Mobile Theme

CAS uses the [Mobile Fluid Skinning System]() to create a separate theme for devices with smaller screens.

Firefox has an extension called [User Agent Switcher]() that can allow you to conveniently experience the mobile theme right in your browser. I've also attached a screenshot below.

![Mobile Theme Screenshot](../../images/docs/mobile_theme.png)

[Mobile Fluid Skinning System]: http://wiki.fluidproject.org/display/fluid/Mobile+FSS+Cheat+Sheet

[User Agent Switcher]: https://addons.mozilla.org/en-US/firefox/addon/user-agent-switcher/

## Mini Tutorial

In this brief tutorial we'll walk through each step in creating the following mockup theme for Yale University.

![Mockup Yale CAS Theme](../../images/docs/theme_tutorial_final.png)

### Initial CAS Setup

*Feel free to follow along. We'll just be working in a single directory that you'll be able to easily delete later.*

First, create a folder to house our new project:

	mkdir cas-theme-tutorial
	cd cas-theme-tutorial

EDITOR NOTE: Make sure to run all further commands in this tutorial from inside this project folder.

Clone CAS and checkout the 3.1.4 tag:

	git clone https://github.com/Jasig/cas.git
	git checkout v3.4.10

Download and extract tomcat tar file:

	curl -0 http://archive.apache.org/dist/tomcat/tomcat-6/v6.0.29/bin/apache-tomcat-6.0.29.tar.gz
	tar -xvzf apache-tomcat-6.0.29.tar.gz
	rm -rf apache-tomcat-6.0.29.tar.gz

Build CAS:

	cd cas && mvn package -Dmaven.test.skip=true && cd ..

Copy `cas.war` to the `webapps` directory in tomcat:

	cp cas/cas-server-webapp/target/cas.war apache-tomcat-6.0.29/webapps/

Start the tomcat server:

	./apache-tomcat-6.0.29/bin/startup.sh

Give it 20-30 seconds or so before pointing your browser to `http://localhost:8080/cas`.

If all went well, you should see the main CAS log in screen below.

![Original CAS Log In Screen](../../images/docs/theme_tutorial_default_theme.png)

EDITOR NOTE: Don't worry about the Non-secure Connection warning. HTTPS is a separate subject that we won't be covering here.

### Writing Custom CSS

First, open up the `webapps` directory in a text editor (I'm using TextMate's `mate` utility):

	mate cas/cas-server-webapp/src/main/webapp/

Create a new file called `yale.css` in the CSS directory. This will be our new custom CSS file. (For this tutorial, we'll be writing our new styles on top of the existing CAS styles.)

Inside our new `yale.css` file, copy and paste the following CSS:

	body {
		background-color: #FAFAE8;
	}
	#header h1#app-name {
   	background-color: #0E4C92;
	}

Now, open up `WEB-INF/view/jsp/default/ui/includes/top.jsp` and add our yale stylesheet right after the default styesheet:

	<link type="text/css" rel="stylesheet" href="<c:url value="${customCssFile}" />" />
	<link type="text/css" rel="stylesheet" href="<c:url value="/css/yale.css" />" />

In order to see our changes, we can simply copy our files to tomcat (we don't have to rebuild CAS or restart tomcat for CSS or JSP changes). To copy our files, I like to use `rsync`:

	rsync -ruv cas/cas-server-webapp/src/main/webapp/* apache-tomcat-6.0.29/webapps/cas/

Now, refresh your browser and you should see our new background colors.

![New Background Color](../../images/docs/theme_tutorial_background_colors.png)

### Changing and Adding Text

Let's update the title to read: "Yale University Log In". In `WEB-INF/view/jsp/default/ui/includes/top.jsp`, update the contents of the `h1` tag:

	<h1 id="app-name" class="fl-table-cell">Yale University Log In</h1>

To see the change, copy your files to tomcat and refresh your browser. You should see our new title.

![Updated Title Text](../../images/docs/theme_tutorial_title_text.png)

Let's now add a welcome message to the body copy. Open up the main log in page at `WEB-INF/view/jsp/default/ui/casLoginView.jsp`. On Line 78, you'll find the following paragraph snippet:

	<p class="fl-panel fl-note fl-bevel-white fl-font-size-80"><spring:message code="screen.welcome.security" /></p>

The body copy is being internationalized (i18n), which allows for the support of multiple languages. Take note of the value of the `code` attribute `screen.welcome.security`. The body copy is being referenced from within property files located in `WEB-INF/classes/`. Open up `messages_en.properties` and let's add our welcome message on a new line:

	screen.welcome.yale=Welcome to Yale University CAS Log In!

Also, add the following paragraph snippet to `casLoginView.jsp` right above the other one:

	<p class="fl-panel fl-note fl-bevel-white fl-font-size-80"><spring:message code="screen.welcome.yale" /></p>

Copy your files and refresh your browser as usual. What happens?

CAS is Unavailable!

This is the most generic error page and it's located at `WEB-INF/view/jsp/errors.jsp`. Let's check the log file to see exactly what kind of error this is. Open up `apache-tomcat-6.0.29/logs/catalina.out` and notice the following stack trace:

	2011-11-03 15:58:40,115 ERROR [org.springframework.web.servlet.tags.MessageTag] - <No message found under code 'screen.welcome.yale' for locale 'en_US'.>
	javax.servlet.jsp.JspTagException: No message found under code 'screen.welcome.yale' for locale 'en_US'.
	at org.springframework.web.servlet.tags.MessageTag.doStartTagInternal(MessageTag.java:184)

We need to restart the tomcat server in order for our i18n changes to take affect. Let's do that now:

	./apache-tomcat-6.0.29/bin/shutdown.sh && sleep 5 && ./apache-tomcat-6.0.29/bin/startup.sh

Refresh your browser again and you should see our new welcome message.

![Welcome Message](../../images/docs/theme_tutorial_welcome_message.png)
	
### Updating the Logo

Run the following command to download a Yale logo into a new `images/yale` directory:

	curl http://www.library.yale.edu/development/resources/images/yale_footer_logo.gif -o cas/cas-server-webapp/src/main/webapp/images/yale/logo.gif --create-dirs

Open our `yale.css` stylesheet and add the following:

	#header {
		background: #fff url("../images/yale/logo.gif") no-repeat 0 0;
	}

Don't forget to copy your files to tomcat and refresh your browser. Now, you should see the new logo:

![Updated Logo](../../images/docs/theme_tutorial_logo.png)
	