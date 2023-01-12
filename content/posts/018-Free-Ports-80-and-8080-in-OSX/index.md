---
title: Free Ports 80 and 8080 in OSX
date: 2019-06-07
---

Ok, this is info I should have documented here a long, long time ago.  For many months now this tidbit of wisdom has lived on a post-it in my office.  Not the best strategy for someone who works from home and travels a lot.

Apparently OSX ships with built-in [Apache](https://https://httpd.apache.org/) and/or [NGINX](https://www.nginx.com/resources/wiki/) servers, presumably to facilitate creation of web content that's local to the machine.  Well, in my Dockerized workflows those port assignments typically get in the way.  When they do, like when I do a `fin up` to launch a local development project using [Docksal](https://docksal.io), I see error messages like the following in my terminal:

```
docker: Error response from daemon: driver failed programming external connectivity on endpoint docksal-vhost-proxy (4b78f8d326c8461a2c6896f0def4491c9d115feeee3680da1f3a5285a707aa08): Error starting userland proxy: Bind for 192.168.64.100:8080 failed: port is already allocated.  
```

Errors like this simply indicate that something, a process or service (container), is already listening on the indicated port.  Frequently that 'something' is the aforementioned built-in 'Apache' or 'NGINX' web server on my Mac.

### Disabling OSX Built-In Web Servers

There is a simple fix... in my Mac terminal I simply need to enter:

```
sudo apachectl stop
sudo nginx -s stop
```

### Changing Docksal Proxy Port Assignments

Docksal itself can also get in the way because by default its proxy service listens locally on ports 80 and 443.  In cases like my [omeka-s-docker](https://github.com/McFateM/omeka-s-docker) project, I needed my [Omeka](https://omeka.org/s/) service listening on port 80.  

Fortunately, there is another simple fix, and it's nicely documented [in this post](https://blog.docksal.io/how-to-override-default-http-and-https-ports-in-docksal-f4d5a96fced4). In my Omeka case I simply added the following lines to the `.docksal/docksal.env` file in the project directory:

```
DOCKSAL_VHOST_PROXY_PORT_HTTP=8080
DOCKSAL_VHOST_PROXY_PORT_HTTPS=8443
```

These variable settings instruct the Docksal proxy to listen on ports 8080 and 8443, making ports 80 and 443 available for my Omeka service.

And that's a wrap.  Until next time...
