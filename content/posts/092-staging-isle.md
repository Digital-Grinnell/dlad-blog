---
title: "Staging ISLE Installation: Migrate Existing Islandora Site - with Annotations"
publishDate: 2020-09-11
lastmod: 2020-09-14T23:43:10-05:00
draft: false
tags:
  - ISLE
  - migrate
  - staging
---

This post is an addendum to earlier posts [087](https://static.grinnell.edu/blogs/McFateM/posts/087-rebuilding-isle-ld-again/) and [090](https://static.grinnell.edu/blogs/McFateM/posts/090-isle-local-migration-customization/). It is intended to chronicle my efforts to migrate to a `staging` instance of _Digital.Grinnell_ on Linux node `DGDockerX.grinnell.edu`. The remainder of this document is an annotated copy of [Staging ISLE Installation: Migrate Existing Islandora Site](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-staging-migrate.md).

{{% annotation %}}
Annotations, with information specific to my experience with _Digital.Grinnell_ migration, appear in text blocks like this one.
{{% /annotation %}}

# Staging ISLE Installation: Migrate Existing Islandora Site

_Expectations:  It takes an average of **2-4+ hours** to read this documentation and complete this installation._

This Staging ISLE Installation will be similar to the [Local ISLE Installation: Migrate Existing Islandora Site](../install/install-local-migrate.md) instructions you just followed but in addition to using a copy of your currently running Production themed Drupal website, a copy of the Production Fedora repository will also be needed for you to continue migrating to ISLE with the end goal of first deploying to an ISLE Production environment and then cut over from the existing non-ISLE Production and Staging servers to their new ISLE counterparts.

Islandora Drupal site code here should be considered almost finished but hosted here for last touches and team review privately prior to pushing to public Production. Fedora data will be a mirror of your currently running Production Fedora repository. It is recommended that this remote site not be publicly accessible.

This installation builds a Staging environment for the express purpose of migrating a previously existing Islandora site onto the ISLE platform. If you need to build a brand new Staging site for development and are not migrating an existing Islandora site, then please **stop** and use the [Local ISLE Installation: New Site](../install/install-local-new.md) instructions first and then the [Staging ISLE Installation: New Site](../install/install-staging-new.md) instead.

As this Staging domain will require a real domain name or [FQDN](https://kb.iu.edu/d/aiuv), we recommend the following:

* If you do not have a Staging server:
    * Work with your IT department or appropriate resource for an "A record" to be added for your domain to "point" to your new Staging Host Server IP address in your institution's DNS records. We recommend that this sub-domain use `-staging` to differentiate it from the Production site
    * Example:`https://yourprojectnamehere-staging.institution.edu`

* If you have a current non-ISLE Staging server(s):
    * You shutdown any current non-ISLE Staging servers and only use the ISLE server from now on.
    * Work with your IT department or appropriate resource for the existing "A record" for the current non-ISLE Staging domain to now "point" to your new Staging Host Server IP address in your institution's DNS records. **This is critical to be performed PRIOR to any further work below.**

Once this has been completed, if you do not want to use Let's Encrypt, you can also request commercial SSL certificates from your IT department for this domain as well. Please note the DNS records will need to exist prior to the creation of any SSL certificate (Commercial or Let's Encrypt.)

* If you already have pre-existing Staging commercial SSL certificates, they can certainly be reused and copied into the ISLE project as directed.

Unlike the Local and Demo setups, you will not have to edit `/etc/localhosts` to view your domain given that DNS is now involved. Your new domain will no longer use the `.localdomain` but instead something like `https://yourprojectnamehere-staging.institution.edu`

This document also has directions on how you can save newly updated ISLE code into a git software repository as a workflow process designed to manage and upgrade the environments throughout the development process from Local to Staging to Production. The [ISLE Installation: Environments](../install/install-environments.md) documentation can also help with explaining the new ISLE structure, the associated files and what values ISLE end-users should use for the `.env`, `staging.env`, etc.

This document **does not** have directions on how you can save previously existing Islandora Drupal code into a git repository and assumes this step has already happened. The directions below will explain how to clone Islandora Drupal code from a previously existing Islandora Drupal git repository that should already be accessible to you.

Please post questions to the public [Islandora ISLE Google group](https://groups.google.com/forum/#!forum/islandora-isle), or subscribe to receive emails. The [Glossary](../appendices/glossary.md) defines terms used in this documentation.

## Assumptions / Prerequisites

* This Staging ISLE installation is intended for an existing Production Islandora Drupal site to be imported along with a copy of the current Production Fedora Repository for further ISLE migration testing, Drupal theme development, ingest testing, etc. on a remote ISLE host server.
    * Some materials are to be "migrated" from the work you performed on your personal computer from the prior steps and processes in [Local ISLE Installation: Migrate Existing Islandora Site](../install/install-local-migrate.md) instructions.

* You will be using ISLE version **1.2.0** or higher.

* You are using Docker-compose **1.24.0** or higher.

* You have git installed on your personal computer as well as the remote ISLE host server.

* You have already provisioned a remote ISLE hosts server and have documented its IP address.
    * You may have used the [ISLE Ansible script](https://github.com/Islandora-Collaboration-Group/ISLE-Ansible) to accomplish this.
    * If doing this manually, please review the following to ensure the remote Staging ISLE host server has all dependencies e.g. CPU, memory and disk space prior to deploying the ISLE Staging environment profile for deploy
        * [Hardware Requirements](host-hardware-requirements.md)
        * [Software Dependencies](host-software-dependencies.md)
    * This server should be running at the time of deploy.
    * **Critical** - This Staging server has the same amount of disk space as your current Production Fedora server does in order to store a copy of the Fedora repository. Please ensure that these sizes match. Please also plan on adding additional capacity as needed for any potential ingest testing, etc.

* You have a previously existing private Islandora Drupal git repository.

* You have access to a private git repository in [Github](https://github.com), [Bitbucket](https://bitbucket.org/), [Gitlab](https://gitlab.com), etc.
    * If you do not, please contact your IT department for git resources, or else create an account with one of the above providers.
    * **WARNING:** Only use **Private** git repositories given the sensitive nature of the configuration files. **DO NOT** share these git repositories publicly.

* You have already have the appropriate A record entered into your institutions DNS system and can resolve the Staging domain (https://yourprojectnamehere-staging.institution.edu) using a tool like https://www.whatsmydns.net/

* You have reviewed the [ISLE Installation: Environments](../install/install-environments.md) for more information about suggested Staging values.

* You are familiar with using tools like `scp, cp or rsync` to move configurations, files and data from your local to the remote Staging server.

* You have access to your Production Islandora Drupal, Solr and Fedora data and copy from your servers to the new ISLE Staging server.

* You will schedule a content freeze for all Production Fedora ingests and additions to your Production website. This will allow you to get up to date data from Production to Staging.

---

## Index of Instructions

This process will differ slightly from previous builds in that there is work to be done on the local to then be pushed to the Staging ISLE Host server with additional followup work to be performed on the remote Staging ISLE Host server.

The instructions that follow below will have either a `On Local` or a `On Remote Staging` pre-fix to indicate where the work and focus should be. In essence, the git workflow established during the local build process will be extended for deploying on Staging and for future ISLE updates and upgrades.

**Steps 1-6: On Local - Configure the ISLE Staging Environment Profile for Deploy to Remote**

  * Step 1: Copy Production Data to Your Local
  * Step 2: On Local - Shutdown Any Local Containers & Review Local Code
  * Step 3: On Local - Create New Users and Passwords by Editing "staging.env"
  * Step 4: On Local - Review and Edit "docker-compose.staging.yml"
  * Step 4A: On Local - (Optional) Changes for "docker-compose.staging.yml"
  * Step 5: On Local Staging - If Using Commercial SSLs
  * Step 6: On Local - Commit ISLE Code to Git Repository

**Steps 7-18: On Remote Staging - Configure the ISLE Staging Environment Profile for Launch and Usage**

  * Step 7: On Remote Staging - Git Clone the ISLE Repository to the Remote Staging ISLE Host Server
  * Step 8: On Remote Staging - Create the Appropriate Local Data Paths for Apache, Fedora and Log Data
  * Step 9: On Remote Staging - Clone Your Production Islandora Code
  * Step 10: On Remote Staging - Copy Over the Production Data Directories
  * Step 11: On Remote Staging - If Using Let's Encrypt
  * Step 12: On Remote Staging - Edit the ".env" File to Change to the Staging Environment
  * Step 13: On Remote Staging - Download the ISLE Images
  * Step 14: On Remote Staging - Start Containers
  * Step 15: On Remote Staging - Import the Production MySQL Drupal Database
  * Step 16: On Remote Staging - Run ISLE Scripts
  * Step 17: On Remote Staging - Re-Index Fedora & Solr
  * Step 18: On Remote Staging - Review and Test the Drupal Staging Site

---

## Step 1: Copy Production Data to Your Local

{{% annotation %}}
I've made no changes to my production data since it was last copied to my local workstation, therefore I skipped this step.
{{% /annotation %}}

### Drupal Site Database

You are repeating this step given that data may have changed on the Production site since creating your local. It is critical that Staging be a mirror or close to exact copy of Production.

**Prior to attempting this step, please consider the following:**

* Drupal website databases can have a multitude of names and conventions. Confer with the appropriate IT departments for your institution's database naming conventions.

* Recommended that the production databases be exported using the `.sql` /or `.gz` file formats (e.g. "prod_drupal_site_082019.sql.gz") for better compression and minimal storage footprint.

* If the end user is running multi-sites, there will be additional databases to export.

* Do not export the `fedora3` database

* If possible, on the production Apache web server, run `drush cc all` from the command line on the production server in the `/var/www/html` directory PRIOR to any db export(s). Otherwise issues can occur on import due to all cache tables being larger than `innodb_log_file_size` allows

#### Export the Production MySQL Islandora Drupal Database

* Export the MySQL database for the current Production Islandora Drupal site in use and copy it to your local in an easy to find place. In later steps you'll be directed to import this file. **Please be careful** performing any of these potential actions below as the process impacts your Production site. If you are not comfortable or familiar with performing these actions, we recommend that you instead work with your available IT resources to do so.
    * To complete this process, you may use a MySQL GUI client or, if you have command line access to the MySQL database server, you may run the following command, substituting your actual user and database names:
    * **Example:** `mysqldump -u username -p database_name > prod_drupal_site_082019.sql`
    * Copy this file down to your personal computer.

---

## Step 2: On Local - Shutdown Any Local Containers & Review Local Code

{{% annotation %}}
I conducted this work from my MacBook where there are no local containers to shut down or review.
{{% /annotation %}}

* Ensure that your ISLE and Islandora git repositories have all the latest commits and pushes from the development process that took place on your personal computer. If you haven't yet finished, do not proceed until everything is completed.

* Once finished, open a `terminal` (Windows: open `Git Bash`)
    * Navigate to your Local ISLE repository
    * Shut down any local containers e.g. `docker-compose down`

---

## Step 3: On Local - Create New Users and Passwords by Editing "staging.env"

* Open the "staging.env" file in a text editor.
    * Find each comment that begins with: `# Replace this comment with a ...` and follow the commented instructions to edit the passwords, database and user names.
        * **Review carefully** as some comments request that you replace with `...26 alpha-numeric characters` while others request that you create an `...easy to read but short database name`.
        * It is okay if you potentially repeat the values previously entered for your local `(DRUPAL_DB)` & `(DRUPAL_DB_USER)` in this Staging environment but we strongly recommend not reusing all passwords for environments e.g. `(DRUPAL_DB_PASS)` & `(DRUPAL_HASH_SALT)` should be unique values for each environment.
        * In many cases the username is already pre-populated. If it doesn't have a comment directing you to change or add a value after the `=`, then don't change it.
    * Once finished, save and close the file.

{{% annotation %}}
I checked and found no significant differences between my local environment and staging, so I copied the local to staging and changed only the Drupal hash salt value, and the first two comment lines.
{{% /annotation %}}

* Open the `config/apache/settings_php/settings.staging.php` file.
    * Find the first comment that begins with: `# ISLE Configuration` and follow the commented instructions to edit the database, username and password.
    * Find the second comment that begins with: `# ISLE Configuration` and follow the instructions to edit the Drupal hash salt.
    * Once finished, save and close the file.

{{% annotation %}}
Once again, I checked and found no significant differences between my local environment and staging, so I copied the local to staging and changed only the Drupal hash salt value, making it match the changes noted above.
{{% /annotation %}}

---

## Step 4: On Local - Review and Edit "docker-compose.staging.yml"

* Review the disks and volumes on your remote Staging ISLE Host server to ensure they are of an adequate capacity for your collection needs and match what has been written in the `docker-compose.staging.yml` file.

* Please read through the `docker-compose.staging.yml` file as there are bind mount points that need to be configured on the host machine, to ensure data persistence. There are suggested bind mounts that the end-user can change to fit their needs or they can setup additional volumes or disks to match the suggestions.
    * In the `fedora` services section
        * `- /mnt/data/fedora/datastreamStore:/usr/local/fedora/data/datastreamStore`
        * `- /opt/data/fedora/objectStore:/usr/local/fedora/data/objectStore`
    * In the `apache` services section
        * `- /opt/data/apache/html:/var/www/html`

* Review the your `docker-compose.local.yml` file for custom edits made and copy them to the `docker-compose.staging.yml` file as needed, this can include changes to Fedora GSearch Transforms, Fedora hash size and more.

{{% annotation %}}
As was the case with my local environment, I've chosen to append a separate _docker-compose_ file, this time named `docker-compose.DG-STAGING.yml`.  This new file configures things so that my FEDORA repository is mounted at `/mnt/data/DG-FEDORA`, rather than on a USB stick named `DG-FEDORA`.
{{% /annotation %}}


### SSL Certificates

* Depending on your choice of SSL type (Commercial SSL files or the Let's Encrypt service), you'll need to uncomment only one line of the `traefik` services section. There are also inline instructions to this effect in the `docker-compose.staging.yml` file.
    * To use `Let's Encrypt for SSL`, uncomment:
        * `- ./config/proxy/acme.json:/acme.json`

    * To use commercial SSLs, uncomment:
        * `./config/proxy/ssl-certs:/certs:ro`
        * Additionally you'll need to add your SSL certs (.cert, .pem, .key) files to `config/proxy/ssl-certs`

* Based on the choice of SSL type made above, you'll need to refer to the `/config/proxy/traefik.staging.toml` file for further configuration instructions.

{{% annotation %}}
I chose to use `Let's Encrypt for SSL` and configured files accordingly.
{{% /annotation %}}

---

## Step 4A: On Local - (Optional) Changes for "docker-compose.staging.yml"

{{% annotation %}}
I chose to make none of the optional changes at this time.
{{% /annotation %}}

This section is for optional changes for the `docker-compose.staging.yml`, end-users do not have feel like they have to make any choices here and can continue to **Step 4** as needed.

The options include PHP settings, Java Memory Allocation, MySQL configuration and use of the [TICK Stack](../optional-components/tickstack.md)


* _(Optional)_ - You can change PHP settings such as file upload limits and memory usage by uncommenting the following in the `apache` services section.
    * `- ./config/apache/php_ini/php.staging.ini:/etc/php/7.1/apache2/php.ini`
    * You'll then need to make edits in the `./config/apache/php_ini/php.staging.ini` file.

* _(Optional)_ - This line is already uncommented by default in ISLE but we're calling it out here that you can changes to the suggested levels or values within the `./config/mysql/ISLE.cnf` file if needed. When setting up for the first time, it is best practice to leave these settings in place. Over time, you can experiment with further tuning and experimentation based on your project or system needs.

* _(Optional)_ - You can change the suggested `JAVA_MAX_MEM` & `JAVA_MIN_MEM` levels but do not exceed more than 50% of your system memory. When setting up for the first time, it is best practice to leave these settings in place as they are configured for a Staging ISLE Host Server using 16 GB of RAM. Over time, you can experiment with further tuning and experimentation based on your project or system needs.

* _(Optional)_ - You can opt to uncomment the TICK stack settings for monitoring but you'll need to follow the [TICK Stack](../optional-components/tickstack.md) instructions prior to committing changes to your ISLE git repository.
    * All TICK related code can be found at the end of all ISLE services within the `docker-compose.staging.yml` file.
    * **Example:**
```bash
  ## _(Optional)_: Uncomment lines below to run ISLE with the TICK monitoring system
  logging:
    driver: syslog
    options:
      tag: "{{.Name}}"
```

  * Uncomment the lines found in the new TICK stack services section of the `docker-compose.staging.yml` file for hosting of that monitoring service on the Staging ISLE Host server.
      * There are additional configurations to be made to files contained within `./config/tick` but you'll need to follow the [TICK Stack](../optional-components/tickstack.md) instructions prior to committing changes to your ISLE git repository.
  * Uncomment the TICK stack data volumes as well at the bottom of the file.

---

## Step 5: On Local Staging - If Using Commercial SSLs

{{% annotation %}}
I chose to use `Let's Encrypt for SSL` and configured files accordingly.
{{% /annotation %}}

If you are going to use Let's Encrypt instead, you can skip this step and move onto the next one. There will be additional steps further in this document, to help you configure it.

If you have decided to use Commercial SSL certs supplied to you by your IT team or appropriate resource, please continue following this step.

* Add your Commercial SSL certificate and key files to the `./config/proxy/ssl-certs` directory
    * **Example:**
    * `./config/proxy/ssl-certs/yourprojectnamehere-staging.domain.cert`
    * `./config/proxy/ssl-certs/yourprojectnamehere-staging.domain.key`

* Edit the `./config/proxy/traefik.staging.toml` and follow the in-line instructions. Replace the .pem & .key with the name of your Staging SSL certificate and associated key. Do note the positioning of the added lines. Third character indentation.

**Note:** despite the instruction examples differing on file type, (`.pem` or `cert`), either one is compatible, use what you have been given. Merely change the file type suffix accordingly.

**Example: .cert**
```bash
    [entryPoints.https.tls]
      [[entryPoints.https.tls.certificates]]
      certFile = "/certs/yourprojectnamehere-staging.domain.cert"
      keyFile = "/certs/yourprojectnamehere-staging.domain.key"
```

**Example: .pem**
```bash
    [entryPoints.https.tls]
      [[entryPoints.https.tls.certificates]]
      certFile = "/certs/sitename-staging.institution.edu.pem"
      keyFile = "/certs/sitename-staging.institution.edu.key"
```

---

## Step 6: On Local - Commit ISLE Code to Git Repository

* Once you have made all of the appropriate changes to your Staging profile. Please note the steps below are suggestions. You might use a different git commit message. Substitute `<changedfileshere>` with the actual file names and paths. You may need to do this repeatedly prior to the commit message.
    * `git add <changedfileshere>`
    * `git commit -m "Changes for Staging"`
    * `git push origin master`

{{% annotation %}}
I chose to save my work in a new branch so:

```
╭─markmcfate@MAC02NX13MG5RP ~/GitHub/dg-isle ‹ruby-2.3.0› ‹completed-install-local-migrate*›
╰─$ git checkout -b ready-for-staging
D	antibot
M	config/apache/settings_php/settings.staging.php
M	config/proxy/traefik.staging.toml
M	docker-compose.staging.yml
D	islandora_mods_via_twig
M	staging.env
Switched to a new branch 'ready-for-staging'
```

Then:

```
╭─markmcfate@MAC02NX13MG5RP ~/GitHub/dg-isle ‹ruby-2.3.0› ‹ready-for-staging*›
╰─$ git status
On branch ready-for-staging
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	deleted:    antibot
	modified:   config/apache/settings_php/settings.staging.php
	modified:   config/proxy/traefik.staging.toml
	modified:   docker-compose.staging.yml
	deleted:    islandora_mods_via_twig
	modified:   staging.env

Untracked files:
  (use "git add <file>..." to include in what will be committed)

	docker-compose.DG-STAGING.yml
	staging.original.env

no changes added to commit (use "git add" and/or "git commit -a")
╭─markmcfate@MAC02NX13MG5RP ~/GitHub/dg-isle ‹ruby-2.3.0› ‹ready-for-staging*›
╰─$ git add .
╭─markmcfate@MAC02NX13MG5RP ~/GitHub/dg-isle ‹ruby-2.3.0› ‹ready-for-staging*›
╰─$ git commit -m "Ready for staging, maybe"
[ready-for-staging 870bcd6] Ready for staging, maybe
 8 files changed, 423 insertions(+), 60 deletions(-)
 delete mode 100644 antibot
 create mode 100644 docker-compose.DG-STAGING.yml
 delete mode 100644 islandora_mods_via_twig
 create mode 100644 staging.original.env
╭─markmcfate@MAC02NX13MG5RP ~/GitHub/dg-isle ‹ruby-2.3.0› ‹ready-for-staging›
╰─$ git push origin ready-for-staging
Counting objects: 12, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (12/12), done.
Writing objects: 100% (12/12), 6.00 KiB | 3.00 MiB/s, done.
Total 12 (delta 9), reused 0 (delta 0)
remote: Resolving deltas: 100% (9/9), completed with 8 local objects.
remote:
remote: Create a pull request for 'ready-for-staging' on GitHub by visiting:
remote:      https://github.com/Digital-Grinnell/dg-isle/pull/new/ready-for-staging
remote:
To https://github.com/Digital-Grinnell/dg-isle
 * [new branch]      ready-for-staging -> ready-for-staging
╭─markmcfate@MAC02NX13MG5RP ~/GitHub/dg-isle ‹ruby-2.3.0› ‹ready-for-staging›
╰─$
```

{{% /annotation %}}

---

## On Remote Staging - Configure the ISLE Staging Environment Profile for Launch and Usage

## Step 7: On Remote Staging - Git Clone the ISLE Repository to the Remote Staging ISLE Host Server

* This assumes you have setup an `Islandora` deploy user. If not use a different non-root user for this purpose.

* You will also need to ensure that any `/home/islandora/.ssh/id_rsa.pub` key has been added to your git repository admin panel to allow for cloning from your two private git repositories.

Since the `/opt` directory might not let you do this at first, we suggest the following workaround which you'll only need to do once. Future ISLE updates will not require this step.

* Shell into your Staging ISLE host server as the `Islandora` user.

* Clone your ISLE project repository with the newly committed changes for Staging to the `Islandora` user home directory.
    * `git clone https://yourgitproviderhere.com/yourinstitutionhere/yourprojectnamehere-isle.git /home/islandora/`
    * This may take a few minutes (2-4) depending on your server's Internet connection.

* Move the newly cloned directory to the `/opt` directory as the root user
    * `sudo mv /home/islandora/yourprojectnamehere-isle /opt/yourprojectnamehere-isle`

* Fix the permissions so that the `islandora` user has access.
    * `sudo chown -Rv islandora:islandora /opt/yourprojectnamehere-isle`

{{% annotation %}}
My chosen command sequence and results were:

```
╭─islandora@dgdockerx ~
╰─$ git clone https://github.com/Digital-Grinnell/dg-isle
Cloning into 'dg-isle'...
Username for 'https://github.com': digital@grinnell.edu
Password for 'https://digital@grinnell.edu@github.com':
remote: Enumerating objects: 5103, done.
remote: Counting objects: 100% (5103/5103), done.
remote: Compressing objects: 100% (1799/1799), done.
remote: Total 5103 (delta 3235), reused 5036 (delta 3168), pack-reused 0
Receiving objects: 100% (5103/5103), 7.23 MiB | 0 bytes/s, done.
Resolving deltas: 100% (3235/3235), done.
╭─islandora@dgdockerx ~
╰─$ sudo mv -f ./dg-isle /opt/dg-isle
╭─islandora@dgdockerx ~
╰─$ cd /opt/dg-isle
╭─islandora@dgdockerx /opt/dg-isle ‹master›
╰─$ git checkout ready-for-staging
Branch ready-for-staging set up to track remote branch ready-for-staging from origin.
Switched to a new branch 'ready-for-staging'
╭─islandora@dgdockerx /opt/dg-isle ‹ready-for-staging›
╰─$ sudo chown -Rv islandora:islandora /opt/dg-isle
ownership of ‘/opt/dg-isle/vagrant/CentOS/Vagrantfile’ retained as islandora:islandora
ownership of ‘/opt/dg-isle/vagrant/CentOS’ retained as islandora:islandora
ownership of ‘/opt/dg-isle/vagrant/Ubuntu/Vagrantfile’ retained as islandora:islandora
...
```
{{% /annotation %}}

## Step 8: On Remote Staging - Create the Appropriate Local Data Paths for Apache, Fedora and Log Data

* Create the `/opt/data` directory
    * `sudo mkdir -p /opt/data`
* Change the permissions to the Islandora user.
    * `sudo chown -Rv islandora:islandora /opt/data`

{{% annotation %}}
My chosen command sequence and results were:

```
╭─islandora@dgdockerx ~
╰─$ sudo mkdir -p /opt/data
╭─islandora@dgdockerx /opt/data
╰─$ sudo chown -Rv islandora:islandora /opt/data
ownership of ‘/opt/data’ retained as islandora:islandora
```
{{% /annotation %}}

---

## Step 9: On Remote Staging - Clone Your Production Islandora Code

Please clone from your existing Production Islandora git repository.

* `git clone git@yourgitproviderhere.com/yourinstitutionhere/yourprojectnamehere-islandora.git /opt/data/apache/html`

* Fix the permissions so that the `islandora` user has access.
    * `sudo chown -Rv islandora:islandora /opt/data/apache/html`

{{% annotation %}}
My chosen command sequence and results were:

```
╭─islandora@dgdockerx ~
╰─$ git clone https://github.com/Digital-Grinnell/dg-islandora --recursive
Cloning into 'dg-islandora'...
Username for 'https://github.com': digital@grinnell.edu
Password for 'https://digital@grinnell.edu@github.com':
remote: Enumerating objects: 598, done.
remote: Counting objects: 100% (598/598), done.
remote: Compressing objects: 100% (557/557), done.
remote: Total 10404 (delta 102), reused 200 (delta 33), pack-reused 9806
Receiving objects: 100% (10404/10404), 62.94 MiB | 37.71 MiB/s, done.
Resolving deltas: 100% (2196/2196), done.
Submodule 'sites/all/modules/islandora/dg7' (https://github.com/DigitalGrinnell/dg7) registered for path 'sites/all/modules/islandora/dg7'
Submodule 'sites/all/modules/islandora/idu' (https://github.com/DigitalGrinnell/idu) registered for path 'sites/all/modules/islandora/idu'
Submodule 'sites/all/modules/islandora/islandora_binary_object' (https://github.com/Islandora-Labs/islandora_binary_object) registered for path 'sites/all/modules/islandora/islandora_binary_object'
Submodule 'sites/all/modules/islandora/islandora_collection_search' (https://github.com/discoverygarden/islandora_collection_search) registered for path 'sites/all/modules/islandora/islandora_collection_search'
Submodule 'sites/all/modules/islandora/islandora_datastream_exporter' (https://github.com/Islandora-Labs/islandora_datastream_exporter.git) registered for path 'sites/all/modules/islandora/islandora_datastream_exporter'
Submodule 'sites/all/modules/islandora/islandora_datastream_replace' (https://github.com/DigitalGrinnell/islandora_datastream_replace.git) registered for path 'sites/all/modules/islandora/islandora_datastream_replace'
Submodule 'sites/all/modules/islandora/islandora_mods_display' (https://github.com/DigitalGrinnell/islandora_mods_display.git) registered for path 'sites/all/modules/islandora/islandora_mods_display'
Submodule 'sites/all/modules/islandora/islandora_multi_importer' (https://github.com/DigitalGrinnell/islandora_multi_importer) registered for path 'sites/all/modules/islandora/islandora_multi_importer'
Submodule 'sites/all/modules/islandora/islandora_solr_collection_view' (https://github.com/Islandora-Labs/islandora_solr_collection_view.git) registered for path 'sites/all/modules/islandora/islandora_solr_collection_view'
Submodule 'sites/all/modules/islandora/islandora_solr_views' (https://github.com/DigitalGrinnell/islandora_solr_views) registered for path 'sites/all/modules/islandora/islandora_solr_views'
Submodule 'sites/all/modules/islandora/islandora_solution_pack_oralhistories' (https://github.com/Islandora-Labs/islandora_solution_pack_oralhistories.git) registered for path 'sites/all/modules/islandora/islandora_solution_pack_oralhistories'
Submodule 'sites/all/themes/bootstrap' (https://github.com/drupalprojects/bootstrap.git) registered for path 'sites/all/themes/bootstrap'
Submodule 'sites/default/themes/digital_grinnell_bootstrap' (https://github.com/DigitalGrinnell/digital_grinnell_bootstrap.git) registered for path 'sites/default/themes/digital_grinnell_bootstrap'
Cloning into 'sites/all/modules/islandora/dg7'...
remote: Enumerating objects: 335, done.
remote: Total 335 (delta 0), reused 0 (delta 0), pack-reused 335
Receiving objects: 100% (335/335), 201.05 KiB | 0 bytes/s, done.
Resolving deltas: 100% (203/203), done.
Submodule path 'sites/all/modules/islandora/dg7': checked out 'f6cca12904d24c57fcc408b93db92893a564e231'
Cloning into 'sites/all/modules/islandora/idu'...
remote: Enumerating objects: 21, done.
remote: Counting objects: 100% (21/21), done.
remote: Compressing objects: 100% (15/15), done.
remote: Total 64 (delta 10), reused 16 (delta 6), pack-reused 43
Unpacking objects: 100% (64/64), done.
Submodule path 'sites/all/modules/islandora/idu': checked out '0d91bd6e563f2955563649fc9168c4e8e518f45c'
Cloning into 'sites/all/modules/islandora/islandora_binary_object'...
remote: Enumerating objects: 353, done.
remote: Total 353 (delta 0), reused 0 (delta 0), pack-reused 353
Receiving objects: 100% (353/353), 80.16 KiB | 0 bytes/s, done.
Resolving deltas: 100% (187/187), done.
Submodule path 'sites/all/modules/islandora/islandora_binary_object': checked out '53b67d57cf1ca8052910a90006ad0af183a23389'
Cloning into 'sites/all/modules/islandora/islandora_collection_search'...
remote: Enumerating objects: 438, done.
remote: Total 438 (delta 0), reused 0 (delta 0), pack-reused 438
Receiving objects: 100% (438/438), 83.91 KiB | 0 bytes/s, done.
Resolving deltas: 100% (209/209), done.
Submodule path 'sites/all/modules/islandora/islandora_collection_search': checked out '69545bed8d953d71344fee44de39074d88da0f90'
Cloning into 'sites/all/modules/islandora/islandora_datastream_exporter'...
remote: Enumerating objects: 80, done.
remote: Total 80 (delta 0), reused 0 (delta 0), pack-reused 80
Unpacking objects: 100% (80/80), done.
Submodule path 'sites/all/modules/islandora/islandora_datastream_exporter': checked out 'b1be7e77fd9f14b72dd1a78130109ce0d9a51fd3'
Cloning into 'sites/all/modules/islandora/islandora_datastream_replace'...
remote: Enumerating objects: 6, done.
remote: Counting objects: 100% (6/6), done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 84 (delta 2), reused 6 (delta 2), pack-reused 78
Unpacking objects: 100% (84/84), done.
Submodule path 'sites/all/modules/islandora/islandora_datastream_replace': checked out '0e786886d8da2ebc30a89d23654710aaa180cceb'
Cloning into 'sites/all/modules/islandora/islandora_mods_display'...
remote: Enumerating objects: 128, done.
remote: Counting objects: 100% (128/128), done.
remote: Compressing objects: 100% (80/80), done.
remote: Total 271 (delta 91), reused 85 (delta 48), pack-reused 143
Receiving objects: 100% (271/271), 282.28 KiB | 0 bytes/s, done.
Resolving deltas: 100% (182/182), done.
Submodule path 'sites/all/modules/islandora/islandora_mods_display': checked out '08249e5a0486c28c698acb7d11db24af5c6ec63c'
Cloning into 'sites/all/modules/islandora/islandora_multi_importer'...
remote: Enumerating objects: 978, done.
remote: Total 978 (delta 0), reused 0 (delta 0), pack-reused 978
Receiving objects: 100% (978/978), 643.47 KiB | 0 bytes/s, done.
Resolving deltas: 100% (681/681), done.
Submodule path 'sites/all/modules/islandora/islandora_multi_importer': checked out '78c06b719287a3c0250e902552ec05f760780b9b'
Cloning into 'sites/all/modules/islandora/islandora_solr_collection_view'...
remote: Enumerating objects: 134, done.
remote: Total 134 (delta 0), reused 0 (delta 0), pack-reused 134
Receiving objects: 100% (134/134), 31.88 KiB | 0 bytes/s, done.
Resolving deltas: 100% (72/72), done.
Submodule path 'sites/all/modules/islandora/islandora_solr_collection_view': checked out 'c4b2f33251e3f46bb3bc4789480a60a8efe5d351'
Cloning into 'sites/all/modules/islandora/islandora_solr_views'...
remote: Enumerating objects: 615, done.
remote: Total 615 (delta 0), reused 0 (delta 0), pack-reused 615
Receiving objects: 100% (615/615), 174.41 KiB | 0 bytes/s, done.
Resolving deltas: 100% (354/354), done.
Submodule path 'sites/all/modules/islandora/islandora_solr_views': checked out '3c17f497a51bc7f5bf90a6bd38e02733b79dca94'
Cloning into 'sites/all/modules/islandora/islandora_solution_pack_oralhistories'...
remote: Enumerating objects: 11, done.
remote: Counting objects: 100% (11/11), done.
remote: Compressing objects: 100% (11/11), done.
remote: Total 3434 (delta 3), reused 2 (delta 0), pack-reused 3423
Receiving objects: 100% (3434/3434), 11.20 MiB | 0 bytes/s, done.
Resolving deltas: 100% (1392/1392), done.
Submodule path 'sites/all/modules/islandora/islandora_solution_pack_oralhistories': checked out '60b84295deb4c7b11fbe5c172e3f815eb78cd942'
Cloning into 'sites/all/themes/bootstrap'...
remote: Enumerating objects: 12635, done.
remote: Total 12635 (delta 0), reused 0 (delta 0), pack-reused 12635
Receiving objects: 100% (12635/12635), 2.83 MiB | 0 bytes/s, done.
Resolving deltas: 100% (9255/9255), done.
Submodule path 'sites/all/themes/bootstrap': checked out 'c050d1d6ae85ef344be85dbf0a4ed9ec68ac32ce'
Cloning into 'sites/default/themes/digital_grinnell_bootstrap'...
remote: Enumerating objects: 190, done.
remote: Total 190 (delta 0), reused 0 (delta 0), pack-reused 190
Receiving objects: 100% (190/190), 1.08 MiB | 0 bytes/s, done.
Resolving deltas: 100% (70/70), done.
Submodule path 'sites/default/themes/digital_grinnell_bootstrap': checked out '22b51ecfb61c7e348e25892e988bcf82d0b1c781'
╭─islandora@dgdockerx ~
╰─$ cd dg-islandora
╭─islandora@dgdockerx ~/dg-islandora ‹master›
╰─$ git checkout completed-install-local-migrate
Branch completed-install-local-migrate set up to track remote branch completed-install-local-migrate from origin.
Switched to a new branch 'completed-install-local-migrate'
╭─islandora@dgdockerx ~/dg-islandora ‹completed-install-local-migrate›
╰─$ sudo mkdir -p /opt/data/apache/html
╭─islandora@dgdockerx ~/dg-islandora ‹completed-install-local-migrate›
╰─$ sudo chown -Rv islandora:islandora /opt/data/apache/html
changed ownership of ‘/opt/data/apache/html’ from root:root to islandora:islandora
╭─islandora@dgdockerx ~/dg-islandora ‹completed-install-local-migrate›
╰─$ cp -fr . /opt/data/apache/html/
╭─islandora@dgdockerx ~/dg-islandora ‹completed-install-local-migrate›
╰─$ cd /opt/data/apache/html
╭─islandora@dgdockerx /opt/data/apache/html ‹completed-install-local-migrate›
╰─$ ls -alh            
total 332K
drwxr-xr-x. 10 islandora islandora 4.0K Sep 14 23:37 .
drwxr-xr-x.  3 root      root      4.0K Sep 14 23:30 ..
-rw-rw-r--.  1 islandora islandora 6.5K Sep 14 23:37 authorize.php
-rw-rw-r--.  1 islandora islandora 113K Sep 14 23:37 CHANGELOG.txt
-rw-rw-r--.  1 islandora islandora 1.5K Sep 14 23:37 COPYRIGHT.txt
-rw-rw-r--.  1 islandora islandora  720 Sep 14 23:37 cron.php
-rw-rw-r--.  1 islandora islandora 2.2K Sep 14 23:37 Digital-Grinnell-Migration-Mitigation-Script.sh
-rw-rw-r--.  1 islandora islandora  317 Sep 14 23:37 .editorconfig
drwxrwxr-x.  9 islandora islandora 4.0K Sep 14 23:39 .git
-rw-rw-r--.  1 islandora islandora  174 Sep 14 23:37 .gitignore
-rw-rw-r--.  1 islandora islandora 2.6K Sep 14 23:37 .gitmodules
-rw-rw-r--.  1 islandora islandora 6.1K Sep 14 23:37 .htaccess
drwxrwxr-x.  4 islandora islandora 4.0K Sep 14 23:37 includes
-rw-rw-r--.  1 islandora islandora  529 Sep 14 23:37 index.php
-rw-rw-r--.  1 islandora islandora 1.7K Sep 14 23:37 INSTALL.mysql.txt
-rw-rw-r--.  1 islandora islandora 1.9K Sep 14 23:37 INSTALL.pgsql.txt
-rw-rw-r--.  1 islandora islandora  703 Sep 14 23:37 install.php
-rw-rw-r--.  1 islandora islandora 1.2K Sep 14 23:37 install_solution_packs.sh
-rw-rw-r--.  1 islandora islandora 1.3K Sep 14 23:37 INSTALL.sqlite.txt
-rw-rw-r--.  1 islandora islandora  18K Sep 14 23:37 INSTALL.txt
-rw-rw-r--.  1 islandora islandora  18K Sep 14 23:37 LICENSE.txt
-rw-rw-r--.  1 islandora islandora 8.3K Sep 14 23:37 MAINTAINERS.txt
-rw-rw-r--.  1 islandora islandora 3.5K Sep 14 23:37 migration_site_vsets.sh
drwxrwxr-x.  6 islandora islandora 4.0K Sep 14 23:37 misc
drwxrwxr-x. 42 islandora islandora 4.0K Sep 14 23:37 modules
drwxrwxr-x.  5 islandora islandora 4.0K Sep 14 23:37 profiles
-rw-rw-r--.  1 islandora islandora  600 Sep 14 23:37 README.md
-rw-rw-r--.  1 islandora islandora 5.3K Sep 14 23:37 README.txt
-rw-rw-r--.  1 islandora islandora 2.2K Sep 14 23:37 robots.txt
drwxrwxr-x.  2 islandora islandora 4.0K Sep 14 23:37 scripts
drwxrwxr-x.  4 islandora islandora 4.0K Sep 14 23:37 sites
drwxrwxr-x.  7 islandora islandora 4.0K Sep 14 23:37 themes
-rw-rw-r--.  1 islandora islandora  20K Sep 14 23:37 update.php
-rw-rw-r--.  1 islandora islandora 9.9K Sep 14 23:37 UPGRADE.txt
-rw-rw-r--.  1 islandora islandora 2.2K Sep 14 23:37 web.config
```

** >>>> Progress Marker <<<< **

{{% /annotation %}}

---

## Step 10: On Remote Staging - Copy Over the Production Data Directories

* It is recommended that you schedule a content freeze for all Production Fedora ingests and additions to your Production website. This will allow you to get up to date data from Production to Staging.

* As you may have made some critical decisions potentially from "Step 0: Copy Production Data to Your Local" of the [Local ISLE Installation: Migrate Existing Islandora Site](../install/install-local-migrate.md) instructions, you need to re-follow the steps to get your:
    * Production Drupal site `files` directory
    * `Solr schema & Islandora transforms`
        * If you picked **Easy** option:
          * then you don't need to do anything here for the `Solr schema & Islandora transforms`
        * If you picked the **Intermediate** or **Advanced** options:
          * You'll need to copy in the customizations and files you created during the `local` environment into the `docker-compose.staging.yml`. Ensure that one set of transforms and schema are used across all environments.
    * Production Fedora `datastreamStore` directory
        * You'll need to adjust the paths below in case your setup differs on either the non-ISLE Production server or the ISLE Staging server.
        * Copy your `/usr/local/fedora/data/datastreamStore` data to the suggested path of `/mnt/data/fedora/datastreamStore`
            * You may need to change the permissions to `root:root` on the Staging `/mnt/data/fedora/datastreamStore` directory above after copying so the Fedora container can access properly. Do not do this on your existing Production system please.
    * Production Fedora `objectStore`.
        * Copy your `/usr/local/fedora/data/objectStore` data to the suggested path of `/opt/data/fedora/objectStore`
            * You may need to change the permissions to `root:root` on the Staging `/opt/data/fedora/objectStore` above after copying so the Fedora container can access properly. Do not do this on your existing Production system please.

---

## Step 11: On Remote Staging - If Using Let's Encrypt

If you are using Commercial SSLs, then please stop and move onto the next step.

If using Let's Encrypt, please continue to follow this step.

* Create an empty `acme.json` within the `./config/proxy/` directory of your ISLE project.
    * `touch /opt/yourprojectnamehere/config/proxy/acme.json`
        * `chmod 600 /opt/yourprojectnamehere/config/proxy/acme.json`
    * This file will be ignored by git and won't cause any errors with checking in code despite the location
    * Do note that you may need to open your firewall briefly to allow the SSL certs to be added to the `acme.json` file. This will be indicated in the following steps.
    * Open your firewall to ports 80, 443 prior to starting up the containers to ensure SSL cert creation.

---

## Step 12: On Remote Staging - Edit the ".env" File to Change to the Staging Environment

This step is a multi-step, involved process that allows an end-user to make appropriate changes to the `.env` and then commit it locally to git. This local commit that never gets pushed back to the git repository is critical to allow future ISLE updates or config changes.

* Copy the sample.env to .env. By default, the Demo environment is setup. You will need to edit this file to match the correct environment. Please note that the .env is no longer tracked by git as of ISLE version 1.5. Instructions below involving git are for ISLE versions below 1.5. However the settings recommended below for the environment can still be followed as needed.
  * `cp sample.env .env`

* Edit the .env, remove the `local` settings and then commit locally (only if using an ISLE version below 1.5)
    * `cd /opt/yourprojectnamehere`
    * `vi / nano / pico /opt/yourprojectnamehere/.env`
    * Edit `COMPOSE_PROJECT_NAME=` and replace the `local` settings with:
      * `COMPOSE_PROJECT_NAME=`  (Suggested) Add an identifiable project or institutional name plus environment e.g. acme_digital_staging`
    * Edit `BASE_DOMAIN=` and replace the `local` settings with:
      * `BASE_DOMAIN=`            (Suggested) Add the full staging domain here e.g. digital-staging.institution.edu
    * Edit `CONTAINER_SHORT_ID=` and replace the `local` settings with:
      * `CONTAINER_SHORT_ID=`     (Suggested) Make an easy to read acronym from the letters of your institution and collection names plus environment e.g. (acme digitalcollections staging) is acdcs
    * Edit `COMPOSE_FILE` change `local` to `staging`
      * `COMPOSE_FILE=docker-compose.staging.yml`
    * Save the file

* For users of ISLE version 1.5 and above, these git instructions below are not needed. The .env file is no longer tracked in git.

* For users of ISLE versions 1.4.2 and below, you will need to continue to follow these instructions until you upgrade.
    * Enter `git status` - You'll now see the following:

    * Enter `git status` - You'll now see the following:

```bash
On branch master
Your branch is up to date with 'origin/master'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

	modified:   .env
```

* You'll need to add this file and commit it in git to be able to get future updates from ISLE as a process.
    * `git add .env`
    * `git commit -m "Added the edited .env configuration file for Staging. DO NOT PUSH BACK TO UPSTREAM REPOSITORY - Jane Doe 8/2019"`
        * This is a suggested warning for users **NOT TO**  push back this configuration change to the main git repository. If that were done it could conflict with other setups.

* You may run into the following:

```bash
*** Please tell me who you are.

Run

  git config --global user.email "you@example.com"
  git config --global user.name "Your Name"

to set your account's default identity.
Omit --global to set the identity only in this repository.

fatal: empty ident name (for <islandora@yourprojectnamehere-staging.institution.edu>) not allowed
```

* Configure your server git client but don't use the `--global` setting as that could interfere with other git repositories e.g. your Islandora Drupal code.
    * **Example:** Within `/opt/yourprojectnamehere`
    * `git config user.email "jane@institution.edu"`
    * `git config user.name "Jane Doe"`

* Now re-run the commit command:

```bash
git commit -m "Added the edited .env configuration file for Staging. DO NOT PUSH BACK TO UPSTREAM REPOSITORY - Jane Doe 8/2019"
[master 7ab3fcf9] Added the edited .env configuration file for Staging. DO NOT PUSH BACK TO UPSTREAM REPOSITORY - Jane Doe 8/2019
 1 file changed, 4 insertions(+), 4 deletions(-)
```

---

## Step 13: On Remote Staging - Download the ISLE Images

* Download all of the latest ISLE Docker images (_~6 GB of data may take 5-10 minutes_).
* _Using the same open terminal:_
    * Navigate to the root of your ISLE project
    * `cd ~/opt/yourprojectnamehere`
    * Start Docker
    * `systemctl start docker`
    * `docker-compose pull`

---

## Step 14: On Remote Staging - Start Containers

**Note:** Prior to starting the launch process, it is recommended that you briefly open your firewall to allow ports 80 and 443 access to the world. You'll only need to keep this open for 3 -5 minutes and then promptly close access once the Let's Encrypt SSL certificates have been generated.

* _Using the same open terminal:_
    * `docker-compose up -d`

* Please wait a few moments for the stack to fully come up. Approximately 3-5 minutes.

* _Using the same open terminal:_
    * View only the running containers: `docker ps`
    * View all containers (both those running and stopped): `docker ps -a`
    * All containers prefixed with `isle-` are expected to have a `STATUS` of `Up` (for x time).
      * **If any of these are not `UP`, then use [ISLE Installations: Troubleshooting](install-troubleshooting.md) to solve before continuing below.**
      <!---TODO: This could be confusing if (a) there are other, non-ISLE containers, or (b) the isle-varnish container is installed but intentionally not running, or (c) older exited ISLE containers that maybe should be removed. --->

* In your web browser, enter your Staging site URL: `https://yourprojectnamehere.institution.edu`
  * **Note:** You should not see any errors with respect to the SSL certifications, you should see a nice green lock padlock for the site security. If you see a red error or unknown SSL cert provider, you'll need to shut the containers down and review the previous steps taken especially if using Let's Encrypt. You may need to repeat those steps to get rid of the errors.

---

## Step 15: On Remote Staging - Import the Local MySQL Drupal Database

**Prior to attempting this step, please consider the following:**

* If the end user is running multi-sites, there will be additional databases to export.

* Do not import the `fedora3` database

---

### Import the Local MySQL Islandora Drupal Database

* Copy the `local_drupal_site_082019.sql` created in Step 1 to the Remote Staging server:
    * Run docker ps to determine the mysql container name
    * `docker cp /pathto/prod_drupal_site_082019.sql.gz your-mysql-containername:/prod_drupal_site_082019.sql.gz`
        * Example: `docker cp /c/db_backups/prod_drupal_site_082019.sql.gz isle-mysql-ld:/prod_drupal_site_082019.sql.gz`
    * This might take a few minutes depending on the size of the file.

* Import the exported Local MySQL database for use in the current Staging Drupal site. Refer to your `staging.env` for the usernames and passwords used below.
    * You can use a MySQL GUI client for this process instead but the command line directions are only included below.
    * Run `docker ps` to determine the MySQL container name
    * _Using the same open terminal:_
    * Shell into your currently running Staging MySQL container
        * `docker exec -it your-mysql-containername bash`
    * Import the Local Islandora Drupal database. Replace the "DRUPAL_DB_USER" and "DRUPAL_DB" in the command below with the values found in your "staging.env" file.
        * `mysql -u DRUPAL_DB_USER -p DRUPAL_DB < local_drupal_site_082019.sql`
        * Enter the appropriate password: value of `DRUPAL_DB_PASS` in the "staging.env")
        * This might take a few minutes depending on the size of the file.
        * Type `exit` to exit the container

---

## Step 16: On Remote Staging - Run ISLE Scripts

**migration_site_vsets.sh: updates Drupal database settings**

This step will show you how to run the "migration_site_vsets.sh" script on the Apache container to change Drupal database site settings for ISLE connectivity.

 _Using the same open terminal:_

* Run `docker ps` to determine the apache container name
* Copy the "migration_site_vsets.sh" to the root of the Drupal directory on your Apache container
    * `docker cp ./scripts/apache/migration_site_vsets.sh your-apache-containername:/var/www/html/migration_site_vsets.sh`
* Change the permissions on the script to make it executable
    * `docker exec -it your-apache-containername bash -c "chmod +x /var/www/html/migration_site_vsets.sh"`
* Run the script
    * `docker exec -it your-apache-containername bash -c "cd /var/www/html && ./migration_site_vsets.sh"`

**fix-permissions.sh: adjusts directory and file permissions in your Drupal site**

This step will show you how to shell into your currently running Staging Apache container, and run the "fix-permissions.sh" script to fix the Drupal site permissions.

* `docker exec -it your-apache-containername bash`
* `sh /utility-scripts/isle_drupal_build_tools/drupal/fix-permissions.sh --drupal_path=/var/www/html --drupal_user=islandora --httpd_group=www-data`
* This process will take 2-5 minutes
* You should see a lot of green [ok] messages.
* If the script appears to pause or prompt for `y/n`, DO NOT enter any values; the script will automatically answer for you.
* Type `exit` to exit the container

| For Microsoft Windows: |
| :-------------      |
| You may be prompted by Windows to: |
| - Share the C drive with Docker.  Click Okay or Allow.|
| - Enter your username and password. Do this.|
| - Allow vpnkit.exe to communicate with the network.  Click Okay or Allow (accept default selection).|
| - If the process seems to halt, check the taskbar for background windows.|

**install_solution_packs.sh: installs Islandora solution packs**

Since you've imported an existing Drupal database, you must now reinstall the Islandora solution packs so the Fedora repository will be ready to ingest objects.

* Copy the "install_solution_packs.sh" to the root of the Drupal directory on your Apache container
    * `docker cp scripts/apache/install_solution_packs.sh your-apache-containername:/var/www/html/install_solution_packs.sh`
* Change the permissions on the script to make it executable
    * **For Mac/Ubuntu/CentOS/etc:** `docker exec -it your-apache-containername bash -c "chmod +x /var/www/html/install_solution_packs.sh"`
    * **For Microsoft Windows:** `docker exec -it your-apache-containername bash -c "chmod +x /var/www/html/install_solution_packs.sh"`
* Run the script
    * **For Mac/Ubuntu/CentOS/etc:** `docker exec -it your-apache-containername bash -c "cd /var/www/html && ./install_solution_packs.sh"`
    * **For Microsoft Windows:** `docker exec -it your-apache-containername bash -c "cd /var/www/html && ./install_solution_packs.sh"`
* The above process will take a few minutes depending on the speed of your local and Internet connection.
    * You should see a lot of green [ok] messages.
    * If the script appears to pause or prompt for "y/n", DO NOT enter any values; the script will automatically answer for you.

* **Proceed only after this message appears:** "Done. 'all' cache was cleared."

---

## Step 17: On Remote Staging - Re-Index Fedora & Solr

When migrating any non-ISLE Islandora site, it is crucial to rebuild (reindex) the following three indices from the FOXML and datastream files on disk.

* **Fedora's indices:**
    * Resource Index - The Resource Index is the Fedora module that provides the infrastructure for indexing relationships among objects and their components.
    * SQL database - `fedora3` contains information vital for the Drupal site to connect to Fedora correctly.

* **Solr index** - Solr an open source enterprise search platform works in conjunction with the Islandora Solr module to provide a way to configure the Islandora search functions, the search results display, and the display of metadata on object pages. The index serves as a list of those objects for fast searching across large collections.

You can use the command-line interactive utility `fedora-rebuild.sh` on the `fedora` container to rebuild all indices when the Fedora (not Tomcat) server is offline.

Depending on the size of your repository, this entire process may take minutes (thousands of objects) or hours (millions of objects) to complete.

### Reindex Fedora RI & Fedora SQL Database (2/3)

Since this command can take minutes or hours depending on the size of your repository, As such, it is recommended starting a screen session prior to running the following commands. Learn more about [screen here](https://www.tecmint.com/screen-command-examples-to-manage-linux-terminals/)

**Note:** The method described below is a longer way of doing this process to onboard users.

* Shell into your currently running Staging Fedora container
    * Run `docker ps` to determine the Fedora container name
    * `docker exec -it your-fedora-containername bash`

* Navigate to the `utility_scripts` directory
    * `cd utility_scripts`

* Run the `rebuildFedora.sh` script. This script will give you output like the example below.
    * `./rebuildFedora.sh`

```bash
  OK - Stopped application at context path [/fedora]
Starting the rebuild process in the background. This may take a while depending on your Fedora repository size.
To watch the log and process run: tail -f $CATALINA_HOME/logs/fedora-rebuild.out
Truncating old SQL tables.
mysql: [Warning] Using a password on the command line interface can be insecure.
Automatically tailing the log file...
Press CTRL+C to stop watching at any time. This will NOT stop the rebuild process
```

* After a good period of time, again depending on the size of your Fedora collection there should be output like the example below. This indicates that the Fedora RI & SQL reindex process was successful. The number of objects rebuilt will vary. You can hit the CNTRL and C keys to exit out of the process, if need be. Do not exit the Fedora container yet, one more index to go; Solr.

```bash
Adding object #31: islandora:sp_web_archive_collection
Adding object #32: islandora:sp_web_archive
Adding object #33: islandora:newspaperPageCModel
Adding object #34: islandora:compound_collection
Adding object #35: islandora:newspaperCModel
Adding object #36: islandora:newspaperIssueCModel
Adding object #37: ir:citationCollection
Adding object #38: islandora:sp_basic_image_collection
SUCCESS: 38 objects rebuilt.
OK - Started application at context path [/fedora]
```

### Reindex Solr (3/3)

**WARNING** - This reindex process takes the longest of all three, with up to **1-30 or more hours** to complete depending on the size of your Fedora collection. As such, it is recommended starting a screen session prior to running the following command. Learn more about [screen here](https://www.tecmint.com/screen-command-examples-to-manage-linux-terminals/)

* Still staying within the `utility_scripts` directory on the Fedora container or reenter the Fedora container having started a new screen session, now run the `updateSolrIndex.sh` script. This script will give you output like the example below.
    * `./updateSolrIndex.sh`

```bash
FedoraGenericSearch (FGS) update Solr index from Fedora helper script.
Starting to reindex your Fedora repository. This process runs in the background and may take some time.
Checked and this operation is still running. You may disconnect and the process will continue to run.
Find logs at /usr/local/tomcat/logs/fgs-update-foxml.out and /usr/local/tomcat/logs/fgs-update-foxml.err.
You can watch log file 'tail -f /usr/local/tomcat/logs/fedoragsearch.daily.log' as the process runs.
```

**Note:** Within this output, options to tail logs and watch progress are offered. Depending on the size of your collection this process may take hours, however it is okay to exit out of the container and even log off the remote Staging server. You can check back frequently by running `tail -f /usr/local/tomcat/logs/fgs-update-foxml.out` on the Fedora container. If you visit your Drupal site and run a Solr search, you should start to see objects and facets start to work. The number of objects will increase over time.

* After a good period of time, again depending on the size of your Fedora collection, when the Solr re-index process finishes, output like the example below will appear in the `/usr/local/tomcat/logs/fgs-update-foxml.out` log. This indicates that the Solr reindex process was completed. The number of objects rebuilt will vary. You can hit the CNTRL and C keys to exit out of the tail process, if need be.

```bash
 tail -f /usr/local/tomcat/logs/fgs-update-foxml.out
Args
0=http://localhost:8080
1=updateIndex
2=fromFoxmlFiles
<?xml version="1.0" encoding="UTF-8"?>
<resultPage operation="updateIndex" action="fromFoxmlFiles" value="" repositoryName="FgsRepos" indexNames="" resultPageXslt="" dateTime="Thu Aug 08 20:43:12 GMT 2019">
<updateIndex xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:foxml="info:fedora/fedora-system:def/foxml#" xmlns:zs="http://www.loc.gov/zing/srw/" warnCount="0" docCount="13" deleteTotal="0" updateTotal="13" insertTotal="0" indexName="FgsIndex"/>
</resultPage>
```

* Type `exit` when finished to exit the container.

---

## Step 18: On Remote Staging - Review and Test the Drupal Staging Site

* In your web browser, enter this URL: `https://yourprojectnamehere.institution.edu`
    * Please note: You should not see any errors with respect to the SSL certifications. If so, please review your previous steps especially if using Let's Encrypt. You may need to repeat those steps to get rid of the errors.

* Log in to the local Islandora site with the credentials ("DRUPAL_ADMIN_USER" and "DRUPAL_ADMIN_PASS") you created in "staging.env".
    * **Note:** You are free to use previously Drupal admin or user accounts created during the Local site development process.

* You can decide to further QC and review the site as you wish or start to add digital collections and objects.
    * You could also further test using the [Islandora Sample Objects](https://github.com/Islandora-Collaboration-Group/islandora-sample-objects) as you may have done in the previous Local installation.

---

## Next Steps

Once you are ready to deploy your finished Drupal site, you may progress to:

* [Production ISLE Installation: Migrate Existing Islandora Site](../install/install-production-migrate.md)

---

## Additional Resources
* [ISLE Installation: Environments](../install/install-environments.md) help with explaining the ISLE structure, the associated files, and what values ISLE end-users should use for the ".env", "local.env", etc.
* [Local ISLE Installation: Resources](../install/install-local-resources.md) contains Docker container passwords and URLs for administrator testing.
* [ISLE Installation: Troubleshooting](../install/install-troubleshooting.md) contains help for port conflicts, non-running Docker containers, etc.

---

### End of Staging ISLE Installation: New Site

And that's a wrap.  Until next time...
