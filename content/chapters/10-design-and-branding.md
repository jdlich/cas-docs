---
title: Design and Branding
---

# Design and Branding

Branding the CAS log in UI involves simply editing the CSS stylesheet and also a small collection of relatively simple JSP include files (also known as views).

EDITOR NOTE: All the files that we'll be discussing in this section that concern the theme are located in and referenced from: `[CAS_ROOT]/cas-server-webapp/src/main/webapp`

## Getting Started

When creating a new theme in CAS, there is not an easy way to preserve existing themes (including the default theme). The problem is specifically with the JSP. There's simply not a system in place to keep all of a specific theme's resources (JSP, in particular) independent of other themes without manually editing hardcoded paths.

So, practically the only approach is to override the existing default theme.

### CSS

The default styles are all contained in a single file located in `css/cas.css`. This location is set in `WEB-INF/classes/cas-theme-default.properties`. (Ignore the themes folder, it's nothing but leftovers from yesteryear.)

CAS uses the [Fluid Skinning System]() CSS framework. More details about FSS can be found on their website.

[Fluid Skinning System]: http://wiki.fluidproject.org/display/fluid/Fluid+Skinning+System+%28FSS%29

### Images

There are 2 `images` folders. Ignore `css/images`, which is designated for the mobile theme. Put your images in `images`.

### JavaScript

If you need to add some JavaScript, feel free to append `js/cas.js`.

You an also create your own `custom.js` file, for example, and call it from within `view/jsp/default/ui/includes/bottom.jsp` like so:

	<script type="text/javascript" src="<c:url value="/js/custom.js" />"></script>

### JSP

The main log in page (the CAS "home page") is located at `view/jsp/default/ui/casLoginView.jsp`. And there you will find the rest of the JSP files as well.

Notice `top.jsp` and `bottom.jsp` include files located in `view/jsp/default/ui/includes`. These serve as the layout template for the other JSP files, which get injected in between during compilation to create a complete HTML page.

## Glossary of Views

**authorizationFailure**  

**brokenContext**  

**casConfirmView**  
Displayed when the user is warned before being redirected to the service.

**casGenericSuccess**  
Displayed when the user has been logged in without providing a service to be redirected to.

**casLoginView**  
As mentioned above, this is the main log in view.

**casLogoutView**  
Displayed when the user logs out.

**errors** 

**serviceErrorView**  
Used in conjunction with the service registry feature, displayed when the service the user is trying to access is not allowed to use CAS. Note that this feature is not enabled by default, in which case all services are able to use CAS.

**serviceErrorSsoView**   

## Configuration

There are 2 configuration files in particular that concern the theme:

* `WEB-INF/classes/cas-theme-default.properties` - Contains the location of the theme's CSS files.

* `WEB-INF/classes/default_views.properties` - Contains the location of the JSP views.

## Mobile Theme

CAS uses [jQuery Mobile]() along with the Fluid Skinning System.

[jQuery Mobile]: http://jquerymobile.com/