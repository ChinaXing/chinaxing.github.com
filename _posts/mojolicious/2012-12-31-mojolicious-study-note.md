---
layout: post
title: Mojolicious study note
category: Perl
change_frequency: monthly
tag: Mojolicious
---

**Mojolicious**:<http://mojolicio.us/>

feature:
=======
- event drive 
- minus moduel dependency
- database relateless
- tempalte lauguage embed perl
- and so on ...

architecture:
============
- route
- controller
- templates
- layouts

misc:
=====
- stash
- flash
- helpers ( default helpers )
- plugins: config plugin, and other third party plugins.
- mode: development, production, prepub, defined in MOJO_MODE and set to `app->mode`


Q&A:
===
1. request: $controler->req
2. http-header: $controler->req->headers 
3. configure: use config-plugin, write perl-ish configure file. mojo will merge main configure file with `MOJO_MODE` configure file.(can read the config-plugin's source code and confirm ).
4. in controller, $self->app: get the application
5. $controller->stash, $controller->current_route, $controller->url_for ...
6. route: route to Controller#action or to callback
7. bridge: in nested route , bridge will return true code, so route can continue, otherwise it will broken.
8. over: over a condition or call back. condition check is earler than bridge and other route.
9. use $route->add_condition to add condition in route.
10. form validation: Validator::Cutstom or thers you like.
11. DB: DBIx::Class, a ORM in Perl.

... continue 

