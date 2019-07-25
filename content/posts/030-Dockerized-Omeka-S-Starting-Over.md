---
title: "Dockerized Omeka-S: Starting Over"
date: 2019-07-25T14:18:24-05:00
---
I've created a new fork of [dodeeric/omeka-s-docker](https://github.com/dodeeric/omeka-s-docker) at [DigitalGrinnell/omeka-s-docker](https://github.com/DigitalGrinnell/omeka-s-docker), and it introduces a new `docker-compose.yml` file for spinning [Omeka-S](https://omeka.org/s/) up locally, but WITHOUT Docksal (due to problems with the integration originally documented [here](https://static.grinnell.edu/blogs/McFateM/posts/019-dockerized-omeka-s/)).

System requirements for local development of this project currently include:

- [Docker (Community Edition)](https://docs.docker.com/install/)
- [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

## Local Development and Testing

If your workstation is able to run the aforementioned required components then the following steps can be used to launch and develop a local instance.  Assuming your workstation is Linux or a Mac, you'll need to edit your `/etc/hosts` with an editor of your choice, and `sudo` privileges might be required.  For me this was...

```
sudo nano /etc/hosts
```

In the `/etc/hosts` file comment out any line beginning with `127.0.0.1` and add the following two lines just above it...
```
### For omeka-s-docker
127.0.0.1    localhost omeka.localdomain pma.localdomain gramps.localdomain
```
The new `127.0.0.1...` line will enable you to use `http://omeka.localdomain` to open and work with your new Omeka-S instance in any browser on your workstation.

Now to launch Omeka-S, return to your workstation terminal and...

```
cd ~/Projects    # or any path of your choice
git clone https://github.com/DigitalGrinnell/omeka-s-docker.git
cd omeka-s-docker
docker-compose up -d
```

The `docker-compose up -d` command in this sequence should launch the project locally.  Once it is complete you should be able to open any browser and visit `http://omeka.localdomain` to work with Omeka-S, or `http://pma.localdomain` if you want PHPMyAdmin.

## Capturing the Configuration
So, having successfully started my new, local Omeka-S stack with `docker-compose up -d`, I wanted to visit the primary container and capture all of the pristine Omeka-S config and code.  The project does NOT map the document root to a persistent directory on the host, so to capture it I did this:

| Workstation Commands |
| --- |
| cd ~/Projects/omeka-s-docker; <br/> mkdir html; <br/> docker cp omeka-s-docker_omeka_1:/var/www/html/. ./html/ |

The last command above, `docker cp...`, is the key.  It copies the established docroot, '/var/www/html', from inside the Omeka container, out to the new `./html` directory on host.

## Adding a Custom Docksal Configuration
Having successfully captured a pristine Omeka-S docroot, I executed a `fin config generate` command on the host from my `~/Projects/omeka-s-docker` project directory.  The result was this:
```
╭─mark@Marks-Air.grinnell.edu ~/Projects/omeka-s-docker  ‹docksal*›
╰─➤  fin config generate
DOCROOT has been detected as html. Is that correct? [y/n]: y
Configuration was generated. You can start it with fin project start
```
Following the prompted suggestion, I then executed `fin project start` and the stack did come alive.  However, when I visit http://omeka-s-docker.docksal I get an "Internal Server Error" page, probably because my database config isn't right yet?  I subsequently did `fin logs` at my command prompt and got back...

```
╭─mark@Marks-Air.grinnell.edu ~/Projects/omeka-s-docker  ‹docksal*›
╰─➤  fin logs
Attaching to omeka-s-docker_web_1, omeka-s-docker_cli_1, omeka-s-docker_db_1
web_1  | Configuring Apache2 environment variables...
web_1  | [Thu Jul 25 15:45:58.407927 2019] [ssl:warn] [pid 1:tid 140419333643144] AH01909: web:443:0 server certificate does NOT include an ID which matches the server name
web_1  | [Thu Jul 25 15:45:58.417368 2019] [ssl:warn] [pid 1:tid 140419333643144] AH01909: web:443:0 server certificate does NOT include an ID which matches the server name
web_1  | [Thu Jul 25 15:45:58.419233 2019] [mpm_event:notice] [pid 1:tid 140419333643144] AH00489: Apache/2.4.35 (Unix) LibreSSL/2.6.5 configured -- resuming normal operations
web_1  | [Thu Jul 25 15:45:58.419345 2019] [core:notice] [pid 1:tid 140419333643144] AH00094: Command line: 'httpd -D FOREGROUND'
web_1  | [Thu Jul 25 15:49:00.969960 2019] [core:alert] [pid 10:tid 140419332627176] [client 172.24.0.5:35076] /var/www/html/.htaccess: Invalid command 'php_value', perhaps misspelled or defined by a module not included in the server configuration
web_1  | 172.24.0.5 - - [25/Jul/2019:15:49:00 +0000] "GET / HTTP/1.1" 500 528
web_1  | [Thu Jul 25 15:49:01.222289 2019] [core:alert] [pid 8:tid 140419332156136] [client 172.24.0.5:35078] /var/www/html/.htaccess: Invalid command 'php_value', perhaps misspelled or defined by a module not included in the server configuration
web_1  | 172.24.0.5 - - [25/Jul/2019:15:49:01 +0000] "GET /favicon.ico HTTP/1.1" 500 528
web_1  | [Thu Jul 25 15:49:18.852967 2019] [core:alert] [pid 10:tid 140419332721384] [client 172.24.0.5:35082] /var/www/html/.htaccess: Invalid command 'php_value', perhaps misspelled or defined by a module not included in the server configuration
web_1  | 172.24.0.5 - - [25/Jul/2019:15:49:18 +0000] "GET /install HTTP/1.1" 500 528
web_1  | [Thu Jul 25 15:58:27.745096 2019] [core:alert] [pid 10:tid 140419332344552] [client 172.24.0.5:35086] /var/www/html/.htaccess: Invalid command 'php_value', perhaps misspelled or defined by a module not included in the server configuration
web_1  | 172.24.0.5 - - [25/Jul/2019:15:58:27 +0000] "GET / HTTP/1.1" 500 528
web_1  | [Thu Jul 25 16:48:15.623872 2019] [core:alert] [pid 8:tid 140419332061928] [client 172.24.0.5:35090] /var/www/html/.htaccess: Invalid command 'php_value', perhaps misspelled or defined by a module not included in the server configuration
web_1  | 172.24.0.5 - - [25/Jul/2019:16:48:15 +0000] "GET / HTTP/1.1" 500 528
cli_1  | 2019-07-25 15:45:56 | Updating docker user uid/gid to 501/20 to match the host user uid/gid...
cli_1  | 2019-07-25 15:45:58 | Resetting permissions on /home/docker and /var/www...
cli_1  | 2019-07-25 15:45:58 | Preliminary initialization completed.
cli_1  | 2019-07-25 15:45:58 | Passing execution to: supervisord
cli_1  | 2019-07-25 15:46:00,068 CRIT Supervisor running as root (no user in config file)
cli_1  | 2019-07-25 15:46:00,069 INFO Included extra file "/etc/supervisor/conf.d/supervisord.conf" during parsing
cli_1  | 2019-07-25 15:46:00,107 INFO RPC interface 'supervisor' initialized
cli_1  | 2019-07-25 15:46:00,107 CRIT Server 'unix_http_server' running without any HTTP authentication checking
cli_1  | 2019-07-25 15:46:00,108 INFO supervisord started with pid 1
cli_1  | 2019-07-25 15:46:01,111 INFO spawned: 'cron' with pid 29
cli_1  | 2019-07-25 15:46:01,115 INFO spawned: 'sshd' with pid 30
cli_1  | 2019-07-25 15:46:01,118 INFO spawned: 'php-fpm' with pid 31
cli_1  | 2019-07-25 15:46:01,918 DEBG fd 16 closed, stopped monitoring <POutputDispatcher at 140451264069856 for <Subprocess at 140451264308792 with name php-fpm in state STARTING> (stdout)>
cli_1  | 2019-07-25 15:46:01,951 DEBG 'php-fpm' stderr output:
cli_1  | [25-Jul-2019 15:46:01] NOTICE: fpm is running, pid 31
cli_1  |
cli_1  | 2019-07-25 15:46:01,953 DEBG 'php-fpm' stderr output:
cli_1  | [25-Jul-2019 15:46:01] NOTICE: ready to handle connections
cli_1  |
cli_1  | 2019-07-25 15:46:02,955 INFO success: cron entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
cli_1  | 2019-07-25 15:46:02,955 INFO success: sshd entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
cli_1  | 2019-07-25 15:46:02,955 INFO success: php-fpm entered RUNNING state, process has stayed up for > than 1 seconds (startsecs)
db_1   | Running init scripts in /docker-entrypoint.d/ as root...
db_1   | Including custom configuration from /var/www/.docksal/etc/mysql/my.cnf
db_1   | 2019-07-25 15:45:57 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).
db_1   | 2019-07-25 15:45:57 0 [Note] mysqld (mysqld 5.6.43) starting as process 1 ...
db_1   | 2019-07-25 15:45:57 1 [Note] Plugin 'FEDERATED' is disabled.
db_1   | 2019-07-25 15:45:57 1 [Note] InnoDB: Using atomics to ref count buffer pool pages
db_1   | 2019-07-25 15:45:57 1 [Note] InnoDB: The InnoDB memory heap is disabled
db_1   | 2019-07-25 15:45:57 1 [Note] InnoDB: Mutexes and rw_locks use GCC atomic builtins
db_1   | 2019-07-25 15:45:57 1 [Note] InnoDB: Memory barrier is not used
db_1   | 2019-07-25 15:45:57 1 [Note] InnoDB: Compressed tables use zlib 1.2.11
db_1   | 2019-07-25 15:45:57 1 [Note] InnoDB: Using Linux native AIO
db_1   | 2019-07-25 15:45:57 1 [Note] InnoDB: Using CPU crc32 instructions
db_1   | 2019-07-25 15:45:57 1 [Note] InnoDB: Initializing buffer pool, size = 256.0M
db_1   | 2019-07-25 15:45:57 1 [Note] InnoDB: Completed initialization of buffer pool
db_1   | 2019-07-25 15:45:57 1 [Note] InnoDB: Highest supported file format is Barracuda.
db_1   | 2019-07-25 15:45:57 1 [Note] InnoDB: 128 rollback segment(s) are active.
db_1   | 2019-07-25 15:45:57 1 [Note] InnoDB: Waiting for purge to start
db_1   | 2019-07-25 15:45:57 1 [Note] InnoDB: 5.6.43 started; log sequence number 1626143
db_1   | 2019-07-25 15:45:57 1 [Note] Server hostname (bind-address): '*'; port: 3306
db_1   | 2019-07-25 15:45:57 1 [Note] IPv6 is available.
db_1   | 2019-07-25 15:45:57 1 [Note]   - '::' resolves to '::';
db_1   | 2019-07-25 15:45:57 1 [Note] Server socket created on IP: '::'.
db_1   | 2019-07-25 15:45:57 1 [Warning] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
db_1   | 2019-07-25 15:45:57 1 [Warning] 'proxies_priv' entry '@ root@db' ignored in --skip-name-resolve mode.
db_1   | 2019-07-25 15:45:58 1 [Note] Event Scheduler: Loaded 0 events
db_1   | 2019-07-25 15:45:58 1 [Note] mysqld: ready for connections.
db_1   | Version: '5.6.43'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
```  

The `web_1... Invalid command 'php_value'` looks odd so I opened the `./html/.htaccess` file on the host and commented out the last two lines (where the `php_value` statements were). I was also concerned that this configuration doesn't specify any database name or credentials, so following [this documentation](https://docs.docksal.io/stack/extend-images/#extend-docksal.yml) I added to `./.docksal/docksal.yml` in the project directory so that it now has  the following initial content:

```
version: "2.1"

services:
  db:
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: omeka
      MYSQL_USER: omeka
      MYSQL_PASSWORD: omeka
```

Then a new `fin up` and http://omeka-s-docker.docksal successfully **opened the Omeka install page!**  

# Woot!
I'm pushing the latest changes to https://github.com/DigitalGrinnell/omeka-s-docker NOW!

NOT a wrap.  As Arnold Schwarzenegger would say: "I'll be back!"
