---
title: "Updating Digital.Grinnell (in Islandora) One More Time"
publishdate: 2023-01-19
draft: false
tags:
  - Digital.Grinnell
  - Islandora
  - ISLE
  - drush
last_modified_at: 2023-01-20T19:14:17 CST
---

Digital.Grinnell's Islandora lifespan will most likely come to an end this year, or at least in the early part 2024.  So, I'm adopting a new, lean and mean process for updating it from this point forward.  Basically the process will involve backing up the code that's already in place, then using `drush up` to upgrade the Drupal modules and core if necessary.  

That process on January 19, 2023, went something like this...  

# vSphere Snapshot

In case of catastrophic failure I first elected to open my VPN then a window into [VMware® vSphere](https://vcenter.grinnell.edu).  Once inside I took a "snapshot" of the _DGDocker1_ server to preserve as an emergency backup.

# Backup DG's `html` Directory

Next, to safeguard the Drupal code at a module/file level I made a backup copy of the Apache container's `/var/www/html` directory and subdirs like so...

```
╭─mcfatem@MAC02FK0XXQ05Q ~
╰─$ ssh dgdocker1 
... output removed for clarity ...         
[islandora@dgdocker1 ~]$ docker exec -it isle-apache-dg bash
root@df92a99d657a:/# cd /var/www/html
root@df92a99d657a:/var/www/html# cp -fr . /mnt/storage/html-backup/. --verbose
... output removed for clarity ...         
```

# drush up

Next, the all-important `drush up` command, complete with unabridged output, from inside the Apache container...  

```
root@df92a99d657a:/var/www/html# cd /var/www/html/sites/default/
root@df92a99d657a:/var/www/html/sites/default# drush up
Update information last refreshed: Thu, 2023-01-19 11:15
 Name                                           Installed Version  Proposed version  Message
 Drupal                                         7.87               7.94              SECURITY UPDATE available
 Views Bulk Operations (views_bulk_operations)  7.x-3.6            7.x-3.7           Update available
 Colorbox (colorbox)                            7.x-2.15           7.x-2.17          SECURITY UPDATE available
 Date (date)                                    7.x-2.12           7.x-2.14          Update available
 Field Group (field_group)                      7.x-1.6            7.x-1.8           Update available
 Link (link)                                    7.x-1.9            7.x-1.11          SECURITY UPDATE available
 SMTP Authentication Support (smtp)             7.x-1.7            7.x-1.9           Update available
 Views (views)                                  7.x-3.25           7.x-3.28          Update available


NOTE: A security update for the Drupal core is available.
Drupal core will be updated after all of the non-core projects are updated.

Security and code updates will be made to the following projects: Views Bulk Operations (VBO) [views_bulk_operations-7.x-3.7], Colorbox [colorbox-7.x-2.17], Date [date-7.x-2.14], Field Group [field_group-7.x-1.8], Link [link-7.x-1.11], SMTP Authentication Support [smtp-7.x-1.9], Views (for Drupal 7) [views-7.x-3.28]

Note: A backup of your project will be stored to backups directory if it is not managed by a supported version control system.
Note: If you have made any modifications to any file that belongs to one of these projects, you will have to migrate those modifications after updating.
Do you really want to continue with the update process? (y/n): y
Project views_bulk_operations was updated successfully. Installed version is now 7.x-3.7.
Backups were saved into the directory /root/drush-backups/digital_grinnell/20230119174513/modules/views_bulk_operations.                                                       [ok]
Project colorbox was updated successfully. Installed version is now 7.x-2.17.
Backups were saved into the directory /root/drush-backups/digital_grinnell/20230119174513/modules/colorbox.                                                                    [ok]
Project date was updated successfully. Installed version is now 7.x-2.14.
Backups were saved into the directory /root/drush-backups/digital_grinnell/20230119174513/modules/date.                                                                        [ok]
Project field_group was updated successfully. Installed version is now 7.x-1.8.
Backups were saved into the directory /root/drush-backups/digital_grinnell/20230119174513/modules/field_group.                                                                 [ok]
Project link was updated successfully. Installed version is now 7.x-1.11.
Backups were saved into the directory /root/drush-backups/digital_grinnell/20230119174513/modules/link.                                                                        [ok]
Project smtp was updated successfully. Installed version is now 7.x-1.9.
Backups were saved into the directory /root/drush-backups/digital_grinnell/20230119174513/modules/smtp.                                                                        [ok]
Project views was updated successfully. Installed version is now 7.x-3.28.
Backups were saved into the directory /root/drush-backups/digital_grinnell/20230119174513/modules/views.                                                                       [ok]

Code updates will be made to drupal core.
WARNING:  Updating core will discard any modifications made to Drupal core files, most noteworthy among these are .htaccess and robots.txt.  If you have made any modifications to these files, please back them up before updating so that you can re-create your modifications in the updated version of the file.
Note: Updating core can potentially break your site. It is NOT recommended to update production sites without prior testing.

Do you really want to continue? (y/n): y
Project drupal was updated successfully. Installed version is now 7.94.
Backups were saved into the directory /root/drush-backups/digital_grinnell/20230119174513/drupal.                                                                              [ok]
 System  7085  Remove FLoC-blocking variable.
 Link    7100  Rebuild the menu cache to make the settings page use the correct permission.
 Smtp    7104  Add "smtp_verify_peer", "smtp_verify_peer_name", "smtp_allow_self_signed" variables  based on current running PHP version for most compatibility.
Do you wish to run all pending updates? (y/n): y
Performed update: system_update_7085                                                                                                                                           [ok]
Performed update: link_update_7100                                                                                                                                             [ok]
Performed update: smtp_update_7104                                                                                                                                             [ok]
'all' cache was cleared.                                                                                                                                                       [success]
Finished performing updates.                                                                                                                                                   [ok]
root@df92a99d657a:/var/www/html/sites/default#
```

# Comparing New Files to Old

The process of updating Drupal `core` always introduces changes in a couple of files, namely `/var/www/html/.htaccess` and `/var/www/html/robots.txt`.  It's prudent for check for differences and take steps to preserve critical portions of these files.  In this instance that looked like this...  

```
root@df92a99d657a:/var/www/html/sites/default# cd ../../
root@df92a99d657a:/var/www/html# diff .htaccess /mnt/storage/html-backup/.htaccess
6c6
< <FilesMatch "\.(engine|inc|info|install|make|module|profile|test|po|sh|.*sql|theme|tpl(\.php)?|xtmpl)(~|\.sw[op]|\.bak|\.orig|\.save)?$|^(\.(?!well-known).*|Entries.*|Repository|Root|Tag|Template|composer\.(json|lock)|web\.config)$|^#.*#$|\.php(~|\.sw[op]|\.bak|\.orig|\.save)$">
---
> <FilesMatch "\.(engine|inc|info|install|make|module|profile|test|po|sh|.*sql|theme|tpl(\.php)?|xtmpl)(~|\.sw[op]|\.bak|\.orig|\.save)?$|^(\.(?!well-known).*|Entries.*|Repository|Root|Tag|Template|composer\.(json|lock)|web\.config)$|^#.*#$|\.php(~|\.sw[op]|\.bak|\.orig\.save)$">
116a117,127
>
>   ## The following rule lifted from https://www.drupal.org/node/38960
>   ## Implemented in April 2021 in order to redirect old object addresses of the form
>   ##   drupal/fedora/repository/grinnell:182, to a proper equivalent form like
>   ##   islandora/object/grinnell:182
>   ##
>   # custom redirects
>   RewriteRule ^drupal/fedora/repository/(.+)$ https://digital.grinnell.edu/islandora/object/$1 [R=301,L]
>   # end custom redirects
>
>
156a168,169
>
> SetEnvIf X-Forwarded-Proto https HTTPS=on
root@df92a99d657a:/var/www/html#
```

Finding no real difference in the `6c6` block above, I elected to do this with `.htaccess`...   

```
root@df92a99d657a:/var/www/html#
root@df92a99d657a:/var/www/html# mv -f .htaccess .htaccess-update-January-19-2023
root@df92a99d657a:/var/www/html# cp -f /mnt/storage/html-backup/.htaccess .
root@df92a99d657a:/var/www/html# diff .htaccess /mnt/storage/html-backup/.htaccess
```
Likewise, looking at `/var/www/html/robots.txt` I elected to keep the old copy since no important changes had been introduced in the update.  Like so...  

```
root@df92a99d657a:/var/www/html# diff robots.txt /mnt/storage/html-backup/robots.txt
51a52
> Disallow: /sites/default/files/webform/
root@df92a99d657a:/var/www/html# cp -f /mnt/storage/html-backup/robots.txt robots.txt
root@df92a99d657a:/var/www/html# diff robots.txt /mnt/storage/html-backup/robots.txt
```

# Testing the Update

First, a high-level look at the results...  

```
[islandora@dgdocker1 ~]$ cd ~/ISLE
[islandora@dgdocker1 ISLE]$ ll
total 12
drwxrwxr-x.  4 islandora islandora 4096 Aug  2 15:04 DEPLOY
drwxr-x---. 10 islandora        33 4096 Jan 19 11:51 dg-islandora
drwxrwxr-x. 12 islandora islandora 4096 Sep 19 13:13 dg-isle
[islandora@dgdocker1 ISLE]$ cd dg-islandora
[islandora@dgdocker1 dg-islandora]$ ll
total 296
-rw-r--r--.  1 root      root   6604 Dec 14 10:08 authorize.php
-rw-r--r--.  1 root      root 118636 Dec 14 10:08 CHANGELOG.txt
-rw-r--r--.  1 root      root   1481 Dec 14 10:08 COPYRIGHT.txt
-rw-r--r--.  1 root      root    720 Dec 14 10:08 cron.php
-rw-r--r--.  1 root      root   2174 Jan 19 11:45 Digital-Grinnell-Migration-Mitigation-Script.sh
-rw-r--r--.  1 root      root     53 Jan 19 11:45 google831161f3ec8e9a73.html
drwxr-xr-x.  4 root      root   4096 Dec 14 10:08 includes
-rw-r--r--.  1 root      root    529 Dec 14 10:08 index.php
-rw-r--r--.  1 root      root   1717 Dec 14 10:08 INSTALL.mysql.txt
-rw-r--r--.  1 root      root   1874 Dec 14 10:08 INSTALL.pgsql.txt
-rw-r--r--.  1 root      root    722 Dec 14 10:08 install.php
-rw-r--r--.  1 root      root   1143 Jan 19 11:45 install_solution_packs.sh
-rw-r--r--.  1 root      root   1298 Dec 14 10:08 INSTALL.sqlite.txt
-rw-r--r--.  1 root      root  18054 Dec 14 10:08 INSTALL.txt
-rw-r--r--.  1 root      root  18092 Nov 16  2016 LICENSE.txt
-rw-r--r--.  1 root      root   8522 Dec 14 10:08 MAINTAINERS.txt
-rw-r--r--.  1 root      root   3554 Jan 19 11:45 migration_site_vsets.sh
drwxr-xr-x.  6 root      root   4096 Dec 14 10:08 misc
drwxr-xr-x. 42 root      root   4096 Dec 14 10:08 modules
drwxr-xr-x.  5 root      root     66 Dec 14 10:08 profiles
-rw-r--r--.  1 root      root   1173 Jan 19 11:45 README.md
-rw-r--r--.  1 root      root   5382 Dec 14 10:08 README.txt
-rw-r--r--.  1 root      root   2229 Jan 19 11:52 robots.txt
drwxr-xr-x.  2 root      root   4096 Dec 14 10:08 scripts
drwxr-x---.  4 islandora   33   4096 Sep 29  2021 sites
drwxr-xr-x.  7 root      root     88 Dec 14 10:08 themes
-rw-r--r--.  1 root      root  19890 Dec 14 10:08 update.php
-rw-r--r--.  1 root      root  10123 Dec 14 10:08 UPGRADE.txt
-rw-r--r--.  1 root      root   2774 Dec 14 10:08 web.config
-rw-r--r--.  1 root      root    417 Dec 14 10:08 xmlrpc.php
```

Then I brought the ISLE stack down and back up again...  

```
[islandora@dgdocker1 ISLE]$ cd /home/islandora/ISLE/dg-isle; docker-compose down
Stopping isle-images-dg    ... done
Stopping isle-apache-dg    ... done
Stopping isle-fedora-dg    ... done
Stopping isle-solr-dg      ... done
Stopping isle-proxy-dg     ... done
Stopping isle-mysql-dg     ... done
Stopping isle-portainer-dg ... done
Removing isle-images-dg    ... done
Removing isle-apache-dg    ... done
Removing isle-fedora-dg    ... done
Removing isle-solr-dg      ... done
Removing isle-proxy-dg     ... done
Removing isle-mysql-dg     ... done
Removing isle-portainer-dg ... done
Removing network dg_isle-internal
Removing network dg_isle-external
[islandora@dgdocker1 dg-isle]$ cd /home/islandora/ISLE/dg-isle; docker-compose up -d
Creating network "dg_isle-internal" with the default driver
Creating network "dg_isle-external" with the default driver
Creating isle-portainer-dg ... done
Creating isle-mysql-dg     ... done
Creating isle-proxy-dg     ... done
Creating isle-solr-dg      ... done
Creating isle-fedora-dg    ... done
Creating isle-apache-dg    ... done
Creating isle-images-dg    ... done
[islandora@dgdocker1 dg-isle]$
```

Checking on [https://digital.grinnell.edu](https://digital.grinnell.edu) showed me that the site was "working", but the theme was not properly in play.  I've seen this before and research showed that it was due to Drupal caching of `.htaccess` settings.  Time to flush the cache, so I did that using the link provided on the Digital.Grinnell home page when one is logged in with proper admin permissions.  

The flush of the cache worked to clean up the theme, so I did a little search and facet testing to demonstrate that these operations were working, and with that I'll declare this update to be DONE!   

---

This probably isn't the last time for an Islandora update, but for now... that's a wrap.
