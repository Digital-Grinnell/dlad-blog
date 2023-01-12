---
title: SNOWBALL
date: 2021-05-17T13:47:36-05:00
publishdate: 2021-05-15
draft: false
emoji: true
tags:
    - Java
    - SNOWBALL
---

{{% boxmd %}}
Digital.Grinnell and a handful of other servers/sites that I deal with crashed on the morning of Thursday, May 16.  Really bad timing! I have yet to figure out what happened to trigger the tsunami, but it happened shortly before the college announced successful cut-over to a new emergency alert system.  Related?  I dunno.

In any case, on Friday afternoon (yesterday) I got a steroid shot for a nasty sinus condition and my doctor warned that I might not be able to sleep well.  I didn't believe her at the time, but at about 4 AM this morning the prophecy came true.  

What follows is my posting to _Slack_ from the ensuing early-morning sleepless rant.
{{% /boxmd %}}   



Mark M.  4:15 AM
It’s 4 AM and I can’t sleep, again.  Too many concerns about DGDocker1 and whatever the hell took it and other servers down on Thursday, coupled with the untimely death of our HDL server.  I’m hoping an hour or two of fiddling with things will help resolve this, or at least get things working again, so I can get this out of my head for now.

Unfortunately, I think my first move is to bring DGDocker1 down, apply pending updates, and bring it back.  However, that means backing it up first in case of catastrophic failure, and that requires using the vSphere Client, a start-to-finish process that will take at least 30 minutes…once I get it started.

I said unfortunately above because it literally took me 20 minutes to get my MacBook up and running again, connected via VPN, and ready to open the vSphere Client.  When I finally did I was greeted with the security warnings shown below.

So, it appears that the vSphere Client https cert is not valid, or self-signed.  I can understand why that might be allowed as an exception to our security rules since this client requires VPN or on-campus access, but it’s still a little troubling that we might make an “exception” for the UI into all our server assets.  Maybe I’m just extra sensitive to this because it’s now 4:14 AM.

Anyway, vSphere is finally open so I’m going to start that backup.  Wish me luck.


Mark M.  4:23 AM
Grrrrrrr…… the clucking VPN died halfway through the backup process.  Now 4:23 AM.  Starting over.

4:27 AM   Discovered that all of my NFS mounts are also dead.  Not surprised based on what I saw on Thursday morning.  I should have seen this coming.

Mark M.  4:35 AM
Got things re-mounted and am removing the old, failed snapshots so I can start a new vSphere snapshot now.

Mark M.  4:58 AM
In the meantime I think I’ve come up with a new name for GUAVA, er, you know what I mean.   Most developers probably associate GUAVA with coffee, and that might make sense for some folks who love coffee since I think that’s central to the origin of the name…back in 1995.  It will come as no surprise that I hate coffee.  Never liked it, can’t imagine that I ever will.  Begs the question… which came first, my dislike of coffee or my utter loathing of all things GUAVA?  Probably the coffee, but it’s all ancient history so who really knows?

4:40 AM   Back to the new name train of thought since removing the old snapshots is now 87% complete.

So I think GUAVA is a rabbit of some kind.  Clearly it lives in a hole, a rabbit hole I think, at least that’s what this feels like because I’m having a difficult time remembering why I started down this path.  Fortunately, I can look back in this Slack thread for reminders.  Gotta love Slack!  Naturally, it is NOT based on GUAVA.  Coincidence?  Nope, it’s modern, not 20th century software.

4:44 AM  Removal of the failed backup is complete, so time to start another backup.  VPN don’t fail me now!  :crossed_fingers:

Oh ya, the name….   So the taxonomic name for rabbit is Oryctolagus cuniculus, but that’s a lot to remember, and there are so many different kinds of rabbits, as I’m learning now.  GUAVA  was created by Oracle and Sun Microsystems (are either of them still in business?  does anybody care?) way back in the day.  I believe they were headquartered in Silicon Valley, so it makes sense that GUAVA is a Californian rabbit, a particular breed of domestic rabbit.

Well, taxonomic names only get longer as we get more specific, so this ain’t gonna help.  :white_frowning_face:  But wait, Californian rabbits are mostly white with gray/black tips, so, owners of this breed commonly name them “Snowball”.   That sounds like a perfect name to me, it fits!    I’ll try and remember to write it as SNOWBALL just to help folks remember that we’re talking about rabbits, er, I mean GUAVA, er, I mean… you know what I mean.

4:57 AM and the snapshot is done!  Now give me a minute to look back in this thread and see how this SNOWBALL (see, it works!) started…

Ok, here we go…

5:00 AM   With a snapshot in hand I’ve taken DG down.  `docker-compose down`

Back to vSphere and I’m going to reboot DGDocker1.

5:01
> Restart the guest OS

5:06
Ok, so that killed the VPN, for good reason this time.  Back at it.  sudo yum update.  Only 253 packages that require updates.  The SNOWBALL is getting bigger.  Gotta love progress, aka complexity… NOT.

5:08 AM   Almost there, completed update of 252 packages.  Unfortunately that means package cleanup comes next, and it’s really boring.  All of this makes me wonder…  Isn’t all of this the kind of thing you’d think ITS would take care of?  Must be late, what am I thinking?  That ain’t never gonna happen.

5:10 AM   Update is done.  Now, :crossed_fingers: and hope there’s enough disk space to complete sudo yum upgrade.

5:11
Made it!  One more vSphere restart just for good measure.

5:13
So far, so good.  Reconnect VPN and restoring the NFS mounts…

Mark M.  5:18 AM
Hmmm, 2 out of 3 ain’t bad.  Unfortunately, that 3rd one is our bagit storage, our backup failsafe.  Not so good.  I’m seeing this:

```
[root@dgdocker1 islandora]# mount -t nfs -o username=mcfatem 132.161.252.72:/nas/LibArchive /libarchive
mount.nfs: an incorrect mount option was specified
```

It’s always worked in the past.  :white_frowning_face:  I guess I’ll proceed without and hope for the best, and open another ticket when all this is done.  What was I doing here again?

5:20
Lets just hope this works…

```
[islandora@dgdocker1 ~]$ cd /opt/ISLE/dg-isle
[islandora@dgdocker1 dg-isle]$
[islandora@dgdocker1 dg-isle]$ docker-compose up -d
Creating network "dg_isle-internal" with the default driver
Creating network "dg_isle-external" with the default driver
Creating isle-proxy-dg     ... done
Creating isle-mysql-dg     ... done
Creating isle-portainer-dg ... done
Creating isle-solr-dg      ... done
Creating isle-fedora-dg    ... done
Creating isle-apache-dg    ... done
Creating isle-images-dg    ... done
[islandora@dgdocker1 dg-isle]$
```

Looking good.  Now, is DG back?

5:20 AM   Not yet.  Wait for it…

5:21 AM   Yes, DG is back and a search for ley returned 270 records with complete facets.  Always a good test.

Now, how about SNOWBALL and our HDL server, will it restart now?

Mark M.  5:29 AM
:drum_with_drumsticks:
```
[root@dgdocker1 dg-isle]# cd /hs/handle-9.2.0
[root@dgdocker1 handle-9.2.0]# ./bin/hdl-server /hs/svr_1
Handle.Net Server Software version 9.2.0
Enter the passphrase for this server's authentication private key:
Note: Your passphrase will be displayed as it is entered

***The fact that I have to type this phrase every time is the reason why all of this can't be automated, but that's the way SNOWBALL is.  She can't help it , after all, she was born in 1995 and that's just how things worked back in the good 'ol days, I guess***

HTTP handle Request Listener:
   address: 132.161.132.103
      port: 8000
Starting HTTP server...
UDP handle Request Listener:
   address: 132.161.132.103
      port: 2641
TCP handle Request Listener:
   address: 132.161.132.103
      port: 2641
Starting TCP request handlers...
Starting UDP request handlers...
^Z
[1]+  Stopped                 ./bin/hdl-server /hs/svr_1
[root@dgdocker1 handle-9.2.0]# bg
[1]+ ./bin/hdl-server /hs/svr_1 &
[root@dgdocker1 handle-9.2.0]# exit
exit
[islandora@dgdocker1 dg-isle]$ ps -ef | grep handle
root      24821  24812  8 06:19 ?        00:00:26 /opt/java/openjdk/bin/java -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djava.awt.headless=true -server -Xmx2048M -Xms512M -XX:+UseG1GC -XX:+UseStringDeduplication -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=70 -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true -Djdk.tls.ephemeralDHKeySize=2048 -Djava.protocol.handler.pkgs=org.apache.catalina.webresources -Dorg.apache.catalina.security.SecurityListener.UMASK=0027 -Dignore.endorsed.dirs= -classpath /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar -Dcatalina.base=/usr/local/tomcat -Dcatalina.home=/usr/local/tomcat -Djava.io.tmpdir=/usr/local/tomcat/temp org.apache.catalina.startup.Bootstrap start
root      42021  42012 36 06:19 ?        00:01:55 /opt/java/openjdk/bin/java -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djava.awt.headless=true -server -Xmx4096M -Xms1024M -XX:+UseG1GC -XX:+UseStringDeduplication -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=70 -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true -Djdk.tls.ephemeralDHKeySize=2048 -Djava.protocol.handler.pkgs=org.apache.catalina.webresources -Dorg.apache.catalina.security.SecurityListener.UMASK=0027 -Dignore.endorsed.dirs= -classpath /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar -Dcatalina.base=/usr/local/tomcat -Dcatalina.home=/usr/local/tomcat -Djava.io.tmpdir=/usr/local/tomcat/temp org.apache.catalina.startup.Bootstrap start
root      59454  59443  9 06:20 ?        00:00:28 /opt/java/openjdk/bin/java -Djava.util.logging.config.file=/usr/local/tomcat/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djava.awt.headless=true -server -Xmx2048M -Xms512M -XX:+UseG1GC -XX:+UseStringDeduplication -XX:MaxGCPauseMillis=200 -XX:InitiatingHeapOccupancyPercent=70 -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true -Djdk.tls.ephemeralDHKeySize=2048 -Djava.protocol.handler.pkgs=org.apache.catalina.webresources -Dorg.apache.catalina.security.SecurityListener.UMASK=0027 -Dcantaloupe.config=/usr/local/cantaloupe/cantaloupe.properties -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -Djava.library.path=/usr/local/lib:/usr/local/tomcat/lib -DLD_LIBRARY_PATH=/usr/local/lib:/usr/local/tomcat/lib -Dignore.endorsed.dirs= -classpath /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar -Dcatalina.base=/usr/local/tomcat -Dcatalina.home=/usr/local/tomcat -Djava.io.tmpdir=/usr/local/tomcat/temp org.apache.catalina.startup.Bootstrap start
root      92190      1  6 06:23 pts/0    00:00:05 java -Xmx200M -server -cp :/hs/handle-9.2.0/bin/../lib/admintool-9.2.0.jar:/hs/handle-9.2.0/bin/../lib/bcpkix-jdk15on-1.59.jar:/hs/handle-9.2.0/bin/../lib/bcprov-jdk15on-1.59.jar:/hs/handle-9.2.0/bin/../lib/cnriutil-2.0.jar:/hs/handle-9.2.0/bin/../lib/commons-codec-1.11.jar:/hs/handle-9.2.0/bin/../lib/gson-2.8.5.jar:/hs/handle-9.2.0/bin/../lib/handle-9.2.0.jar:/hs/handle-9.2.0/bin/../lib/javax.servlet-api-3.0.1.jar:/hs/handle-9.2.0/bin/../lib/je-7.5.11.jar:/hs/handle-9.2.0/bin/../lib/jna-5.3.1.jar:/hs/handle-9.2.0/bin/../lib/jna-platform-5.3.1.jar:/hs/handle-9.2.0/bin/../lib/jython-2.2.1.jar:/hs/handle-9.2.0/bin/../lib/oldadmintool-9.2.0.jar:/hs/handle-9.2.0/bin/../lib/oshi-core-3.13.3.jar:/hs/handle-9.2.0/bin/../lib/slf4j-api-1.7.25.jar:/hs/handle-9.2.0/bin/../lib/jetty/com.sun.el-2.2.0.v201108011116.jar:/hs/handle-9.2.0/bin/../lib/jetty/javax.annotation-1.1.0.v201108011116.jar:/hs/handle-9.2.0/bin/../lib/jetty/javax.el-2.2.0.v201108011116.jar:/hs/handle-9.2.0/bin/../lib/jetty/javax.servlet.jsp-2.2.0.v201112011158.jar:/hs/handle-9.2.0/bin/../lib/jetty/javax.servlet.jsp.jstl-1.2.0.v201105211821.jar:/hs/handle-9.2.0/bin/../lib/jetty/javax.transaction-1.1.1.v201105210645.jar:/hs/handle-9.2.0/bin/../lib/jetty/jetty-all-8.1.22.v20160922.jar:/hs/handle-9.2.0/bin/../lib/jetty/org.apache.jasper.glassfish-2.2.2.v201112011158.jar:/hs/handle-9.2.0/bin/../lib/jetty/org.apache.taglibs.standard.glassfish-1.2.0.v201112081803.jar:/hs/handle-9.2.0/bin/../lib/jetty/org.eclipse.jdt.core-3.7.1.jar:/hs/handle-9.2.0/bin/../lib/jetty/org.objectweb.asm-3.1.0.v200803061910.jar net.handle.server.Main /hs/svr_1
islando+  92358   2346  0 06:25 pts/0    00:00:00 grep --color=auto handle
```

5:33
So, what does all that $hit mean?  IT WORKS!

In SNOWBALL terms it means that at 5:32 AM I can go back to bed.  Notice I said bed, not sleep.  There’s no telling how long it might take me to forget all this $hit so I can relax a little.

Oh yeah, I also have to remember to work out that `mount -t nfs -o username=mcfatem 132.161.252.72:/nas/LibArchive /libarchive` failure sometime.

Probably ought to capture all of this in my blog sometime too, but who has time for that?

G’night all.
