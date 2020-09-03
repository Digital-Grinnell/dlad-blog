---
title: "Local ISLE Installation: Migrate Existing Islandora Site - with Annotations"
publishDate: 2020-08-31
lastmod: 2020-09-02T17:34:52-05:00
draft: false
tags:
  - ISLE
  - migrate
  - local
  - development
---

This post is an addendum to earlier posts 021 and 058, with simiar titles.  It is intended to chronicle my efforts to migrate to a `local development` instance of _Digital.Grinnell_ on my work-issued iMac, `MA8660`, currently identified as `MAD25W812UJ1G9`.

## Goal
The goal of this project is once again to spin up a local Islandora stack using [the ISLE project](https://github.com/Islandora-Collaboration-Group/ISLE/) following the guidance of the project's [install-local-migrate](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-migrate.md) document.  My process will be slightly different than documented since I've already created a pair of private [dg-isle](https://github.com/Digital-Grinnell/dg-isle/) and [dg-islandora](https://github.com/Digital-Grinnell/dg-islandora/) repositories. This workflow will also take steps to introduce elements like the [Digital Grinnell theme](https://github.com/DigitalGrinnell/digital_grinnell_theme/) and custom modules like [DG7](https://github.com/DigitalGrinnell/dg7/).  Once these pieces are in-place and working, I'll begin adding other critical components as well as a robust set of data gleaned from https://digital.grinnell.edu/.

### Changes Since Post 058
There have been three significant changes since I last attempted this effort:

  1) ISLE v1.5.1 is now the latest release,
  2) I now have proper HTTPS access to, and availability of, DGDockerX.Grinnell.edu to use for staging ISLE, and
  3) All of my GitHub-hosted projects have moved from a local directory of `~/Projects` to `~/GitHub`.

## Using This Document
There are just a couple of notes regarding this document that I'd like to pass along to make it more useful.

  - **Gists** - You will find a few places in this post where I generated a [gist](https://help.github.com/en/articles/creating-gists) to take the place of lengthy command output.  Instead of a long stream of text you'll find a simple [link to a gist](https://gist.github.com/McFateM/98d09fdcc29f88ac88bf7b3cbfb8324d).

  - **Workstation Commands** - There are lots of places in this document where I've captured a series of command lines along with output from those commands in block text.  Generally speaking, after each such block you will find a **Workstation Commands** table that can be used to conveniently copy and paste the necessary commands directly into your workstation. The tables look something like this:

| Workstation Commands |
| --- |
| cd ~/GitHub <br/> git clone https://github.com/DigitalGrinnell/ISLE <br/> cd ISLE <br/> git checkout -b ld |

  - **Apache Container Commands** - Similar to `Workstation Commands`, a tabulated list of commands may appear with a heading of **Apache Container Commands**. \*Commands in such tables can be copied and pasted into your command line terminal, but ONLY after you have opened a shell into the _Apache_ container. The asterisk (\*) at the end of the table heading is there to remind you of this! See the [next section](#opening-a-shell-in-the-apache-container) of this document for additional details. These tables looks something like this:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/contrib <br/> drush dl backup_migrate <br/> drush -y en backup_migrate |

## Opening a Shell in the Apache Container
This is something I find myself doing quite often during ISLE configuration, so here's a reminder of how I generally do this...

| Workstation Commands |
| --- |
| docker exec -it isle-apache-ld bash |

## Cleaning Up
I typically use the following command stream to clean up any _Docker_ cruft before I begin anew.  Note: Uncomment the third line ONLY if you want to delete images and download new ones.  If you do, be patient, it could take several minutes depending on connection speed.

| Workstation Commands |
| --- |
| docker stop &dollar;(docker ps -q) <br/> docker rm -v &dollar;(docker ps -qa) <br/> # docker image rm &dollar;(docker image ls -q) --force <br/> docker system prune --force |

# Local ISLE Installation: Migrate Existing Islandora Site

{{% annotation %}}
What follows is my annotated copy of [Local ISLE Installation: Migrate Existing Islandora Site](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-migrate.md). Annotations in this document use the `annotation` shortcode and appear in a highlighted box like the one you are reading from now.
{{% /annotation %}}

_Expectations:  It takes an average of **2-4+ hours** to read this documentation and complete this installation._

This Local ISLE Installation builds a local environment for the express purpose of migrating a previously existing Islandora site onto the ISLE platform. If you need to build a brand new local development site, please **stop** and use the [Local ISLE Installation: New Site](../install/install-local-new.md) instead.

This Local ISLE Installation will use a copy of a currently running Production Islandora Drupal website and an empty Fedora repository for end users to test migration to ISLE and do site development and design with the end goal of deploying to ISLE Staging and Production environments for public use. The final goal would be to cut over from the existing non-ISLE Production and Staging servers to their new ISLE counterparts.

This Local ISLE Installation will allow you to locally view this site in your browser with the domain of your choice (**Example:** "https://yourprojectnamehere.localdomain"), instead of being constrained to the Demo URL ("https://isle.localdomain").

This document has directions on how you can save newly created ISLE code into a git software repository as a workflow process designed to manage and upgrade the environments throughout the development process from Local to Staging to Production. The [ISLE Installation: Environments](../install/install-environments.md) documentation offers an overview of the ISLE structure, the associated files, and what values ISLE end users should use for the ".env", "local.env", etc.

This document **does not** have directions on how you can save previously existing Islandora Drupal code into a git repository and assumes this step has already happened. The directions below will explain how to clone Islandora Drupal code from a previously existing Islandora Drupal git repository that should already be accessible to you.

Please post questions to the public [Islandora ISLE Google group](https://groups.google.com/forum/#!forum/islandora-isle), or subscribe to receive emails. The [Glossary](../appendices/glossary.md) defines terms used in this documentation.

## Assumptions / Prerequisites

* This Local ISLE installation expects that an existing Production Islandora Drupal site will be imported on a personal computer for further ISLE migration testing, Drupal theme development, ingest testing, etc.

* You will be using ISLE version **1.2.0** or higher.

* You are using Docker-compose **1.24.0** or higher.

* You have git installed on your personal computer.

* You have a previously existing private Islandora Drupal git repository.

* You have access to a private git repository in [Github](https://github.com), [Bitbucket](https://bitbucket.org/), [Gitlab](https://gitlab.com), etc.
    * If you do not, please contact your IT department for git resources, or else create an account with one of the above providers.
    * **WARNING:** Only use **Private** git repositories given the sensitive nature of the configuration files. **DO NOT** share these git repositories publicly.

* **For Microsoft Windows:**
    * You have installed [Git for Windows](../install/host-software-dependencies.md#windows) and will use its provided "Git Bash" as your command line interface; this behaves similarly to LINUX and UNIX environments. Git for Windows also installs "openssl.exe" which will be needed to generate self-signed SSL certs. (Note: PowerShell is not recommended as it is unable to run UNIX commands or execute bash scripts without a moderate degree of customization.)
    * Set your text editor to use UNIX style line endings for files. (Text files created on DOS/Windows machines have different line endings than files created on Unix/Linux. DOS uses carriage return and line feed ("\r\n") as a line ending, which Unix uses just line feed ("\n").)

---

## Index of Instructions

* Step 0: Copy Production Data to Your Personal Computer
* Step 1: Choose a Project Name
* Step 1.5: Edit "/etc/hosts" File
* Step 2: Setup Git Project Repositories
* Step 3: Git Clone the Production Islandora Drupal Site Code
* Step 4: Edit the ".env" File to Change to the Local Environment
* Step 5: Create New Users and Passwords by Editing "local.env" File
* Step 6: Create New Self-Signed Certs for Your Project
* Step 7: Download the ISLE Images
* Step 8: Launch Process
* Step 9: Import the Production MySQL Drupal Database
* Step 10: Run Islandora Drupal Site Scripts
* Step 11: Test the Site
* Step 12: Ingest Sample Objects

---

## Step 0: Copy Production Data to Your Personal Computer

Be sure to run a backup of any current non-ISLE systems prior to copying or exporting any files.

### Drupal Site Files and Code

1. Copy the `/var/www/html/sites/default/files` directory from your Production Apache server to an appropriate storage area on your personal computer. You'll move this directory in later steps.

{{% annotation %}}
On the production instance of _Digital.Grinnell_ the Apache container's Drupal webroot at `/var/www/html` maps to the host, `DGDocker1` with a static IP address of `132.161.132.103`, at `/opt/ISLE/persistent/html`. So, as directed above, I put a copy of the `/var/www/html/sites/default/files` directory into `~/Desktop/migration-copy` from my iMac like so:
```
rsync -aruvi islandora@132.161.132.103:/opt/ISLE/persistent/html/sites/default/files/. ~/Desktop/migration-copy/var/www/html/sites/default/files/ --progress
```
{{% /annotation %}}

2. Locate and note the previously existing private Islandora Drupal git repository. {{% annotation %}} https://github.com/Digital-Grinnell/dg-islandora {{% /annotation %}} You'll be cloning this into place once the ISLE project has been cloned in later steps.

### Drupal Site Database

**Prior to attempting this step, please consider the following:**

* Drupal website databases can have a multitude of names and conventions. Confer with the appropriate IT departments for your institution's database naming conventions.

* Recommended that the production databases be exported using the ".sql" /or ".gz" file formats (e.g. "prod_drupal_site_082019.sql.gz") for better compression and minimal storage footprint.

* If the end user is running multi-sites, there will be additional databases to export.

* Do not export the "fedora3" database or any system tables (such as "information_schema", "performance_schema", "mysql")

* If possible, on the production Apache web server, run `drush cc all` from the command line on the production server in the `/var/www/html` directory PRIOR to any db export(s). Otherwise issues can occur on import due to all cache tables being larger than "innodb_log_file_size" allows

#### Export the Production MySQL Islandora Drupal Database

* Export the MySQL database for the current Production Islandora Drupal site in use and copy it to your personal computer (local) in an easy to find place. In later steps you'll be directed to import this file. **Please be careful** performing any of these potential actions below as the process impacts your Production site.

* If you are not comfortable or familiar with performing these actions, we recommend that you instead work with your available IT resources to do so.
    * To complete this process, you may use a MySQL GUI client or, if you have command line access to the MySQL database server, you may run the following command, substituting your actual user and database names:
    * **Example:** `mysqldump -u username -p database_name > prod_drupal_site_082019.sql`
    * Copy this file down to your personal computer.

{{% annotation %}}
Even though the production instance of _Digital.Grinnell_ has built-in facilities for performing this step, I chose to use an easily-repeated command line from an SSH session open on DGDocker1, like so:

```
docker exec -w /var/www/html/sites/default isle-apache-dg drush cc all
docker exec -it isle-mysql-dg bash
```

Then, working inside the _isle-mysql-dg_ container:
```
mysqldump -u isle_dg_user -p isle_dg > prod_drupal_site_083120.sql
exit
```

Back in the DGDocker1 terminal:
```
docker cp isle-mysql-dg:/prod_drupal_site_083120.sql ~/.
exit
```

Next, from my desktop terminal this command saved a copy of the exported database in `/Users/markmcfate/Desktop/migration-copy/prod_drupal_site_083120.sql`:
```
rsync -aruvi islandora@132.161.132.103:/home/islandora/prod_drupal_site_083120.sql ~/Desktop/migration-copy/prod_drupal_site_083120.sql
```
{{% /annotation %}}

### Fedora Hash Size (Conditional)

* Are you migrating an existing Islandora site that has greater than one million objects?  {{% annotation %}}No{{% /annotation %}}

* If true, then please carefully read about the [Fedora Hash Size (Conditional)](../install/install-troubleshooting.md#fedora-hash-size-conditional).

### Solr Schema and Islandora Transforms

This data can be challenging depending on the level of customizations to contend with and as such, ISLE maintainers recommends following one of the three (3), "Easy", "Intermediate", and "Advanced" strategies outlined below.

#### Strategy 1: **Easy** - Run "Stock" ISLE

Don't copy any existing production Solr schemas, GSearch .xslt files, etc., and opt instead to use ISLE's default versions. Import some objects from your existing Fedora repository and see if they display properly in searches as you like.

#### Strategy 2: **Intermediate** - Bind Mount in Existing Transforms and Schemas

Bind mount in existing transforms and schemas  to override ISLE settings with your current Production version.

**WARNING** _This approach assumes you are running Solr 4.10.x.; **only attempt** if you are running that version on Production._

* Copy these current Production files and directory to your personal computer in an appropriate location.
    * Solr `schema.xml`
    * GSearch `foxmltoSolr.xslt` file
    * GSearch `islandora_transforms`
    * Keep the files you create during this process; you will need them again for `Step 2a` (below)!

* **Note:** You may need to further review paths in the files mentioned above, and edit them to match ISLE system paths. i.e. If `foxmltoSolr.xslt` and any transforms within `islandora_transforms` include `xsl:include` statements, make sure they match the paths noted in Step 2a (i.e. `/usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms`).

#### Strategy 3: **Advanced** - Diff and Merge Current Production Customization Edits Into ISLE Configs

{{% annotation %}}
I chose this approach, _Strategy 3_, just as I have in the past.
{{% /annotation %}}

* Copy these current production files and directory to your personal computer in an appropriate location.
    * Solr `schema.xml`
    * GSearch `foxmltoSolr.xslt` file
    * GSearch `islandora_transforms`

* Run the Demo ISLE briefly to pull files for modification and correct ISLE system paths.

{{% annotation %}}
Since I already have "customized" copies of the files in question (see [post 058](content/posts/058-rebuilding-isle-ld.md) I executed this step in two parts so that I can identify any changes in the files since the last time I did this. Specifically, I loaded and pulled the files and directory listed below from both ISLE v1.5.1 and ISLE v1.3.0, the version that I used in my previous attempt. In each case, before spinning up the `Demo ISLE` instance I did `git checkout ISLE-1.3.0` and `git checkout master`, the later was to create a v1.5.1 instance.
{{% /annotation %}}

* You can find these paths by running the Demo and copying these files out to an appropriate location.

    * `docker cp isle-solr-ld:/usr/local/solr/collection1/conf/schema.xml schema.xml`
    * `docker cp isle-fedora-ld:/usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt foxmlToSolr.xslt`
    * `docker cp isle-fedora-ld:/usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms islandora_transforms`

{{% annotation %}}
Using the commands above, I pulled content from ISLE v1.5.1 and saved it in `~/Desktop/isle-demo-v1.5.1`. The same content from ISLE v1.3.0 is saved in `~/Desktop/isle-demo-v1.3.0` for comparison.
{{% /annotation %}}

* Using a "diff" tool (_software that allows one to compare and find the differences between two files_), compare:

    * your Production Solr `schema.xml` file to the ISLE demo `schema.xml` file.
    * your Production GSearch `foxmltoSolr.xslt` file to the ISLE demo `foxmltoSolr.xslt` file.
    * your Production GSearch `islandora_transforms` directory to the ISLE demo `islandora_transforms` directory.

{{% annotation %}}
I subsequently used `diff -bur ~/Desktop/isle-demo-v1.3.0 ~/Desktop/isle-demo-v1.5.1` to recursively report any differences between the two versions of files and directories. **There were NONE.**
{{% /annotation %}}

* Look for edits and comments that indicate specific customization and make note of the differences.

    * Merge in the customizations into the ISLE versions.
    * Keep the files you create during this merge process; you will need them again for `Step 2a` (below)!

---

## Step 1: Choose a Project Name

Please choose a project name (concatenated, with no spaces) that describes your institution or your collection platform. You will substitute in your preferred project name whenever the documentation refers to **"yourprojectnamehere"**. (Be creative. Some real-life examples include: arminda, dhinitiative, digital, digitalcollections, digitallibrary, unbound, etc.)

{{% annotation %}}
As in past cases, I chose the very simple name `dg`.
{{% /annotation %}}

---

## Step 1.5: Edit "/etc/hosts" File

Enable the Local ISLE Installation to be viewed locally on a personal computer browser using "yourprojectnamehere" (e.g. "https://yourprojectnamehere.localdomain").

* Please use these instructions to [Edit the "/etc/hosts" File](../install/install-demo-edit-hosts-file.md).

{{% annotation %}}
Checked my `/etc/hosts` file and the necessary edits are in place. To protect that file from future updates to Docker, I changed the file's permissions to `444`, read-only!
{{% /annotation %}}

---

## Step 2: Setup Git Project Repositories

You will create two new, empty, private git repositories (if they do not already exist) within your git repository hosting service (e.g [Github](https://github.com), [Bitbucket](https://bitbucket.org/), [Gitlab](https://gitlab.com)). Below, we suggest a naming convention that will clearly distinguish your ISLE code from your Islandora code. It's very important to understand that these are two separate code repositories, and not to confuse them.

* Login to your git repository hosting service.
* Create a new private repository for **ISLE**.
    * **We suggest you name it:** `yourprojectnamehere-isle`
    * (This git repository will hold your ISLE code and your environment-specific customizations. Storing this in a private repository and following the workflow below will save you a lot of time and confusion.)
* Create a new private repository for **Islandora Drupal**.
    * **We suggest you name it:** `yourprojectnamehere-islandora`
    * (This git repository will hold your Islandora Drupal code and your site specific customizations. Storing this in a private repository and following the workflow below will save you a lot of time and confusion.)

**Note:** This documentation will walk you through using git on the command line.

You will open a terminal and use the command line to clone your newly created (and empty) `yourprojectnamehere-isle` repository from your git hosting service to create a local directory/copy on your personal computer:

* Open a `terminal` (Windows: open `Git Bash`)

* Use the "cd" command to navigate to a directory where you want to locate your new `yourprojectnamehere-isle` directory.  (We recommend using the default user home directory. You may choose a different location, but it must not be a protected folder such as system or root directory.)
    * **Example (Mac):** `cd ~`
    * **Example (Windows):** `cd /c/Users/somebody/`

* Clone your new `yourprojectnamehere-isle` repository to your personal computer:
    * **Example:** `git clone https://yourgitproviderhere.com/yourinstitutionhere/yourprojectnamehere-isle.git`

* **Note:** It is OKAY if you see this warning message: "Warning: You appear to have cloned an empty repository."

* Navigate to the new directory created by the above clone operation:

    * **Example:** `cd yourprojectnamehere-isle`

* Add the ICG ISLE git repository as a git upstream:

    * `git remote add icg-upstream https://github.com/Islandora-Collaboration-Group/ISLE.git`

* View your connections to remote git repositories:

    * `git remote -v`

* You should now see the following:

```bash
icg-upstream	https://github.com/Islandora-Collaboration-Group/ISLE.git (fetch)
icg-upstream	https://github.com/Islandora-Collaboration-Group/ISLE.git (push)
origin	https://yourgitproviderhere.com/yourinstitutionhere/yourprojectnamehere-isle.git (fetch)
origin	https://yourgitproviderhere.com/yourinstitutionhere/yourprojectnamehere-isle.git (push)
```

* Run a "git fetch" from the `icg-upstream` repository:

    * `git fetch icg-upstream`

* Pull down the ICG ISLE "master" branch into your `yourprojectnamehere-isle` local "master" branch:

    * `git pull icg-upstream master`

* View the ISLE code you now have in this directory:

    * `ls -lha`

* Push this code to your git hosting provider:

    * `git push -u origin master`
    * This will take 2-5 minutes depending on your internet speed.

You now have the current ISLE project code checked into git as a foundation to make changes on specific to your local and project needs. You'll use this git "icg-upstream" process in the future to pull updates and new releases from the main ISLE project.

{{% annotation %}}
The prescribed private repositories, [dg-isle](https://github.com/Digital-Grinnell/dg-isle) and [dg-islandora](https://github.com/Digital-Grinnell/dg-islandora), were created long ago in blog posts [051](content/posts/051-Migrating-DG-to-ISLE-1.3.0-ld.md) and [059](content/posts/059-Pushing-ISLE-to-Staging.md).
{{% /annotation %}}

---

### Step 2a: Add Customizations from "Step 0" to the Git Workflow

This step is intended for users who followed either the "**Intermediate**" or "**Advanced**" migration options in "Step 0" above.  If you choose the **Easy** migration option you may safely skip `Step 2a`.

Navigate to your local `yourprojectnamehere-isle` directory:

* `cd /path/to/yourprojectnamehere-isle`

Create new directories under "./config" to hold the Solr and GSearch files you retrieved in "Step 0".  Do the following::

```
mkdir -p ./config/solr
mkdir -p ./config/fedora/gsearch
```

* Copy your "schema.xml" file from "Step 0" into the new "./config/solr/" directory.

* Copy your "foxmltoSolr.xslt" file and "islandora_transforms" directory from "Step 0" into the "config/fedora/gsearch/" directory.

* Add a new line in the Solr volumes section of your "docker-compose.local.yml"
```
  - config/solr/schema.xml:/usr/local/solr/collection1/conf/schema.xml`
```

* Add new lines in the Fedora volumes section of your "docker-compose.local.yml"
```
  - ./config/fedora/gsearch/islandora_transforms:/usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/islandora_transforms
  - ./config/fedora/gsearch/foxmlToSolr.xslt:/usr/local/tomcat/webapps/fedoragsearch/WEB-INF/classes/fgsconfigFinal/index/FgsIndex/foxmlToSolr.xslt
```

Continue the local setup as directed below and ultimately import some objects from your existing Fedora repository and see if they display properly in searches as you like.

{{% annotation %}}
All prescribed "customizations" were previously incorporated into my [dg-isle](https://github.com/Digital-Grinnell/dg-isle) repository. Since no changes to the base files, see annotations above in Step 0 - Strategy 3, were detected, I will assume that my previous customizations remain valid.
{{% /annotation %}}

---

## Step 3: Git Clone the Production Islandora Drupal Site Code

This step assumes you have an existing Islandora Drupal site, like `yourprojectnamehere-islandora`, checked into a git repository. (If not, then you'll need to check your Drupal site into a git repository following the same commands from [Local ISLE Installation: New Site](../install/install-local-new.md) documentation. Your git repository should be initialized at the Drupal root.)

**Note:** If below you see a "fatal: Could not read from remote repository." error, then please read [Fatal: Could not read from remote repository](../install/install-troubleshooting.md#fatal-could-not-read-from-remote-repository).

_Using the same open terminal:_

* Create a location outside of your `/path/to/yourprojectnamehere-isle` directory where your Islandora Drupal site code will be stored.
  While you may create this location anywhere, we suggest that you put it at the same level as your existing `yourprojectnamehere-isle` directory. From your `/path/to/yourprojectnamehere-isle` directory, go up one level:
    * `cd /path/to/yourprojectnamehere-isle`
    * `cd ..`
    * `git clone https://yourgitproviderhere.com/yourinstitutionhere/yourprojectnamehere-islandora.git`
    * **Example:** The above process created a folder named "yourprojectnamehere-islandora"
* Now update the "docker-compose.local.yml" in the `yourprojectnamehere-isle` directory to create a bind-mount to the Islandora Drupal site code:
    * Search for "apache:"
    * Find the sub-section called "volumes:"
    * Find this line:
        * "- ./data/apache/html:/var/www/html:cached"
    * Edit the above line to be like this:
        * ` - ../yourprojectnamehere-islandora:/var/www/html:cached`
* Your Production Islandora site code is now configured to be used in this local setup.

{{% annotation %}}
I followed the instructions in this section to-the-letter.
{{% /annotation %}}

---

## Step 4: Edit the ".env" File to Change to the Local Environment

* Navigate to your local `yourprojectnamehere-isle` directory.

* Copy the sample.env to .env. By default, the Demo environment is setup. You will need to edit this file to match the correct environment. Please note that the .env is no longer tracked by git as of ISLE version 1.5. Instructions below involving git are for ISLE versions below 1.5. However the settings recommended below for the environment can still be followed as needed.
  * `cp sample.env .env`

* Open the ".env" file in a text editor.

* Change only the following lines in the ".env" file so that the resulting values look like the following: **Please note: the following below is an example not actual values you should use. Use one word to describe your project and follow the conventions below accordingly**
    * `COMPOSE_PROJECT_NAME=yourprojectnamehere_local`
    * `BASE_DOMAIN=yourprojectnamehere.localdomain`
    * `CONTAINER_SHORT_ID=ld` _leave default setting of `ld` as is. Do not change._
    * `COMPOSE_FILE=docker-compose.local.yml`

* Save and close the file.

* Additionally, depending on your decision from "Step 0", you may need to make additional edits to `docker-compose.local.yml` and move files into place as directed from the (**Intermediate**) and (**Advanced**) sections.

**Note:** We highly recommend that you also review the contents of the `docker-compose.local.yml` file as the Apache service volume section uses bind mounts for the intended Drupal Code instead of using default Docker volumes. This allows users to perform Local Islandora Drupal site development with an IDE. This line is a suggested path and users are free to change values to the left of the `:` to match their Apache data folder of choice. However we recommend starting out with the default setting below.
Default: `- ./data/apache/html:/var/www/html:cached`

{{% annotation %}}
I checked for significant changes to `sample.env` (for `.env`) and `docker-compose.local.yml` between past versions and v1.5.1, and found **NONE**. So, I believe my previous changes to these files should still be valid.
{{% /annotation %}}

---

## Step 5: Create New Users and Passwords by Editing "local.env" File

You can reuse some of the older Production settings in the "local.env" if you like (e.g. the database name "DRUPAL_DB", database user "DRUPAL_DB_USER" even the Drupal database user password "DRUPAL_DB_PASS" if that makes it easier). It is important to avoid repeating passwords in the ISLE Staging and Production environments.

* Open the "local.env" file in a text editor.

    * Find each comment that begins with: `# Replace this comment with a ...` and follow the commented instructions to edit the passwords, database and user names.

        * **Review carefully** as some comments request that you replace with `...26 alpha-numeric characters` while others request that you create an `...easy to read but short database name`.

        * In many cases the username is already pre-populated. If it doesn't have a comment directing you to change or add a value after the `=`, then don't change it.

    * **For Microsoft Windows:**
        * Find the following line:
            * `# COMPOSE_CONVERT_WINDOWS_PATHS=1`
        * In the above line, delete the first two characters (`# `) so as to uncomment the line. It should now look like this:
            * `COMPOSE_CONVERT_WINDOWS_PATHS=1`

    * Once finished, save and close the file.

* Open the "config/apache/settings_php/settings.local.php" file in a text editor.
    * Find the first comment that begins with: `# ISLE Configuration` and follow the commented instructions to edit the database, username and password.
    * Find the second comment that begins with: `# ISLE Configuration` and follow the instructions to edit the Drupal hash salt.
    * Once finished, save and close the file.

{{% annotation %}}
As in previous sections, I checked for significant changes to `local.env` and `config/apache/settings_php/settings.local.php` between past versions and v1.5.1, and found **NONE**. So, I believe my previous changes to these files should still be valid.
{{% /annotation %}}

---

## Step 6: Create New Self-Signed Certs for Your Project

* Open the appropriate file in a text editor:
    * **For Mac/Ubuntu/CentOS/etc:** "./scripts/proxy/ssl-certs/local.sh"
    * **For Microsoft Windows:** "./scripts/proxy/ssl-certs/local-windows-only.sh"

* Follow the in-line instructions to add your project's name to the appropriate areas.
    * Once finished, save and close the file.

* _Using the same open terminal:_, navigate to "/path/to/yourprojectnamehere-isle/scripts/proxy/ssl-certs/"
    * `cd ./scripts/proxy/ssl-certs/`

* Change the permissions on the script to make it executable
    * **For Mac/Ubuntu/CentOS/etc:** `chmod +x local.sh`
    * **For Microsoft Windows:** `chmod +x local-windows-only.sh`

* Run the following command to generate new self-signed SSL keys using your "yourprojectnamehere.localdomain" domain. This now secures the local site.
    * **For Mac/Ubuntu/CentOS/etc:** `./local.sh`
    * **For Microsoft Windows:** `./local-windows-only.sh`
    * The generated keys can now be found in:
        * `cd ../../../config/proxy/ssl-certs`

* Add the SSL .pem and .key file names generated from running the above script to the "./config/proxy/traefik.local.toml" file.
    * `cd ..`
    * Open `traefik.local.toml` in a text editor.
    * **Example:**
        * `certFile = "/certs/yourprojectnamehere.localdomain.pem"`
        * `keyFile = "/certs/yourprojectnamehere.localdomain.key"`

{{% annotation %}}
As in previous sections, I checked for significant changes to the files involved in this section between past versions and v1.5.1, and found **NONE**. So, I believe my previous changes to these files should still be valid.
{{% /annotation %}}

---

## Step 7: Download the ISLE Images

* Download all of the latest ISLE Docker images (_~6 GB of data may take 5-10 minutes_):
* _Using the same open terminal:_
    * Navigate to the root of your local `yourprojectnamehere-isle` directory:
        * `cd ~/path/to/yourprojectnamehere-isle`
    * `docker-compose pull`

{{% annotation %}}
I followed the instructions in this section to-the-letter.
{{% /annotation %}}

## Step 8: Launch Process

* _Using the same open terminal:_
    * `docker-compose up -d`

* Please wait a few moments for the stack to fully come up. Approximately 3-5 minutes.

* _Using the same open terminal:_
    * View only the running containers: `docker ps`
    * View all containers (both those running and stopped): `docker ps -a`
    * All containers prefixed with "isle-" are expected to have a "STATUS" of "Up" (for x time).
      * **If any of these are not "UP", then use [Non-Running Docker Containers](../install/install-troubleshooting.md#non-running-docker-containers) to solve before continuing below.**
      <!---TODO: This could be confusing if (a) there are other, non-ISLE containers, or (b) the isle-varnish container is installed but intentionally not running, or (c) older exited ISLE containers that maybe should be removed. --->

{{% annotation %}}
I followed the instructions in this section to-the-letter.
{{% /annotation %}}

## Step 9: Import the Production MySQL Drupal Database

**Method A: Use a MySQL client with a GUI**

* Configure the client with the following:
    * Host = `127.0.0.1`
    * Port: `3306` _or a different port if you changed it_
    * Username: `root`
    * Password: `YOUR_MYSQL_ROOT_PASSWORD` in the "local.env")
* Select the Drupal database "DRUPAL_DB" in the "local.env")
* Click File > Import (_or equivalent_)
* Select your exported Production Islandora Drupal database file (e.g. "prod_drupal_site_082019.sql.gz")
* The import process will take 1 -3 minutes depending on the size.

**Method B: Use the command line**

* Copy the Production Islandora Drupal database file (e.g. "prod_drupal_site_082019.sql.gz") to your ISLE MySQL container
    * Run `docker ps` to determine the mysql container name
    * `docker cp /pathto/prod_drupal_site_082019.sql.gz your-mysql-containername:/prod_drupal_site_082019.sql.gz`
    * **Example:**
        * `docker cp /c/db_backups/prod_drupal_site_082019.sql.gz isle-mysql-ld:/prod_drupal_site_082019.sql.gz`
    * This might take a few minutes depending on the size of the file.

* Shell into the mysql container by copying and pasting the appropriate command:
    * **For Mac/Ubuntu/CentOS/etc:** `docker exec -it your-mysql-containername bash`
    * **For Microsoft Windows:** `winpty docker exec -it your-mysql-containername bash`
* Import the Production Islandora Drupal database. Replace the "DRUPAL_DB_USER" and "DRUPAL_DB" in the command below with the values found in your "local.env" file.
    * `mysql -u DRUPAL_DB_USER -p DRUPAL_DB < prod_drupal_site_082019.sql.gz`
* This might take a few minutes depending on the size of the file.
* Type `exit` to exit the container

{{% annotation %}}
I chose _Method B_ and used the following commands to complete this step:
```
docker cp /Users/markmcfate/Desktop/migration-copy/prod_drupal_site_083120.sql isle-mysql-ld:/prod_drupal_site_083120.sql
docker exec -it isle-mysql-ld bash
mysql -u admin -p digital_grinnell < prod_drupal_site_083120.sql
```
{{% /annotation %}}

---

## Step 10: Run Islandora Drupal Site Scripts

**migration_site_vsets.sh: updates Drupal database settings**

This step will show you how to run the "migration_site_vsets.sh" script on the Apache container to change Drupal database site settings for ISLE connectivity.

 _Using the same open terminal:_

* Run `docker ps` to determine the apache container name
* Copy the "migration_site_vsets.sh" to the root of the Drupal directory on your Apache container
    * `docker cp scripts/apache/migration_site_vsets.sh your-apache-containername:/var/www/html/migration_site_vsets.sh`
* Change the permissions on the script to make it executable
    * **For Mac/Ubuntu/CentOS/etc:** `docker exec -it your-apache-containername bash -c "chmod +x /var/www/html/migration_site_vsets.sh"`
    * **For Microsoft Windows:** `winpty docker exec -it your-apache-containername bash -c "chmod +x /var/www/html/migration_site_vsets.sh"`
* Run the script
    * **For Mac/Ubuntu/CentOS/etc:** `docker exec -it your-apache-containername bash -c "cd /var/www/html && ./migration_site_vsets.sh"`
    * **For Microsoft Windows:** `winpty docker exec -it your-apache-containername bash -c "cd /var/www/html && ./migration_site_vsets.sh"`

{{% annotation %}}
I ran the following commands to complete this portion of Step 10:
```
docker cp scripts/apache/migration_site_vsets.sh isle-apache-ld:/var/www/html/migration_site_vsets.sh
docker exec -it isle-apache-ld bash -c "chmod +x /var/www/html/migration_site_vsets.sh"
time docker exec -it isle-apache-ld bash -c "cd /var/www/html && ./migration_site_vsets.sh"
```

The script output included several copies of the following warning messages:
```
The following module is missing from the file system: <em                           [warning]
class="placeholder">antibot</em>. For information about how to fix this, see <a
href="https://www.drupal.org/node/2487215">the documentation page</a>.
bootstrap.inc:1156
The following module is missing from the file system: <em                           [warning]
class="placeholder">dg7</em>. For information about how to fix this, see <a
href="https://www.drupal.org/node/2487215">the documentation page</a>.
bootstrap.inc:1156
The following module is missing from the file system: <em                           [warning]
class="placeholder">idu</em>. For information about how to fix this, see <a
href="https://www.drupal.org/node/2487215">the documentation page</a>.
bootstrap.inc:1156
The following module is missing from the file system: <em                           [warning]
class="placeholder">islandora_binary_object</em>. For information about how to fix
this, see <a href="https://www.drupal.org/node/2487215">the documentation page</a>.
bootstrap.inc:1156
The following module is missing from the file system: <em                           [warning]
class="placeholder">islandora_collection_search</em>. For information about how to
fix this, see <a href="https://www.drupal.org/node/2487215">the documentation
page</a>. bootstrap.inc:1156
The following module is missing from the file system: <em                           [warning]
class="placeholder">islandora_datastream_exporter</em>. For information about how to
fix this, see <a href="https://www.drupal.org/node/2487215">the documentation
page</a>. bootstrap.inc:1156
The following module is missing from the file system: <em                           [warning]
class="placeholder">islandora_datastream_replace</em>. For information about how to
fix this, see <a href="https://www.drupal.org/node/2487215">the documentation
page</a>. bootstrap.inc:1156
The following module is missing from the file system: <em                           [warning]
class="placeholder">islandora_mods_display</em>. For information about how to fix
this, see <a href="https://www.drupal.org/node/2487215">the documentation page</a>.
bootstrap.inc:1156
The following module is missing from the file system: <em                           [warning]
class="placeholder">islandora_mods_via_twig</em>. For information about how to fix
this, see <a href="https://www.drupal.org/node/2487215">the documentation page</a>.
bootstrap.inc:1156
The following module is missing from the file system: <em                           [warning]
class="placeholder">islandora_multi_importer</em>. For information about how to fix
this, see <a href="https://www.drupal.org/node/2487215">the documentation page</a>.
bootstrap.inc:1156
The following module is missing from the file system: <em                           [warning]
class="placeholder">islandora_oralhistories</em>. For information about how to fix
this, see <a href="https://www.drupal.org/node/2487215">the documentation page</a>.
bootstrap.inc:1156
The following module is missing from the file system: <em                           [warning]
class="placeholder">islandora_solr_collection_view</em>. For information about how
to fix this, see <a href="https://www.drupal.org/node/2487215">the documentation
page</a>. bootstrap.inc:1156
The following module is missing from the file system: <em                           [warning]
class="placeholder">islandora_solr_views</em>. For information about how to fix
this, see <a href="https://www.drupal.org/node/2487215">the documentation page</a>.
bootstrap.inc:1156
The following module is missing from the file system: <em                           [warning]
class="placeholder">transcripts_ui</em>. For information about how to fix this, see
<a href="https://www.drupal.org/node/2487215">the documentation page</a>.
bootstrap.inc:1156
```

The script finished with:
```
'all' cache was cleared.                                                            [success]
Drush script finished! ...exiting
docker exec -it isle-apache-ld bash -c   0.07s user 0.07s system 0% cpu 4:14.54 total
```
{{% /annotation %}}

**install_solution_packs.sh: installs Islandora solution packs**

Since you've imported an existing Drupal database, you must now reinstall the Islandora solution packs so the Fedora repository will be ready to ingest objects.

* Copy the "install_solution_packs.sh" to the root of the Drupal directory on your Apache container
    * `docker cp scripts/apache/install_solution_packs.sh your-apache-containername:/var/www/html/install_solution_packs.sh`
* Change the permissions on the script to make it executable
    * **For Mac/Ubuntu/CentOS/etc:** `docker exec -it your-apache-containername bash -c "chmod +x /var/www/html/install_solution_packs.sh"`
    * **For Microsoft Windows:** `winpty docker exec -it your-apache-containername bash -c "chmod +x /var/www/html/install_solution_packs.sh"`
* Run the script
    * **For Mac/Ubuntu/CentOS/etc:** `docker exec -it your-apache-containername bash -c "cd /var/www/html && ./install_solution_packs.sh"`
    * **For Microsoft Windows:** `winpty docker exec -it your-apache-containername bash -c "cd /var/www/html && ./install_solution_packs.sh"`
* The above process will take a few minutes depending on the speed of your local and Internet connection.
    * You should see a lot of green [ok] messages.
    * If the script appears to pause or prompt for "y/n", DO NOT enter any values; the script will automatically answer for you.

| For Microsoft Windows: |
| --- |
| You may be prompted by Windows to:
|  - Share the C drive with Docker.  Click Okay or Allow. |
|  - Enter your username and password. Do this. |
|  - Allow vpnkit.exe to communicate with the network.  Click Okay or Allow (accept default selection). |
|  - If the process seems to halt, check the taskbar for background windows. |

* **Proceed only after this message appears:** "Done. 'all' cache was cleared."

{{% annotation %}}
I ran the following commands to complete this portion of Step 10:
```
docker cp scripts/apache/install_solution_packs.sh isle-apache-ld:/var/www/html/install_solution_packs.sh
docker exec -it isle-apache-ld bash -c "chmod +x /var/www/html/install_solution_packs.sh"
time docker exec -it isle-apache-ld bash -c "cd /var/www/html && ./install_solution_packs.sh"
```

The aforementioned warnings were repeated several times and the script finished with:
```
Drush script finished! ...exiting
docker exec -it isle-apache-ld bash -c   0.04s user 0.02s system 0% cpu 4:05.92 total
```
<<<<<<<<<< Progress Marker >>>>>>>>>>
{{% /annotation %}}

---

## Step 11: Test the Site

* In your web browser, enter this URL: `https://yourprojectnamehere.localdomain`

<!--- TODO: Add error message and how to proceed (click 'Advanced...') --->

* Note: You may see an SSL error warning that the site is unsafe. It is safe, it simply uses "self-signed" SSL certs. Ignore the error and proceed to the site.

* Log in to the local Islandora site with the credentials ("DRUPAL_ADMIN_USER" and "DRUPAL_ADMIN_PASS") you created in "local.env".

    * You can also attempt to use login credentials that the Production server would have stored in its database.

* If the newly created Drupal login doesn't work then, you'll need to Shell into the Apache container:

    * **For Mac/Ubuntu/CentOS/etc:** `docker exec -it your-apache-containername bash`
    * **For Microsoft Windows:** `winpty docker exec -it your-apache-containername bash`

* Navigate to this directory
    * `cd /var/www/html`

* Create the user found in "DRUPAL_ADMIN_USER" and set its password to the value of "DRUPAL_ADMIN_PASS" as you previously created in "local.env".

    * In the example below swap-out "DRUPAL_ADMIN_USER" and "DRUPAL_ADMIN_PASS" with those found in "local.env".

    * `drush user-create DRUPAL_ADMIN_USER --mail="youremailaddresshere" --password="DRUPAL_ADMIN_PASS";`

    * `drush user-add-role "administrator" DRUPAL_ADMIN_USER`

* Type `exit` to exit the container

* Attempt to login again

---

## Step 12: Ingest Sample Objects

It is recommended that end users migrating their sites opt to either import sample objects from their non-ISLE Production Fedora servers or use the following below:

The Islandora Collaboration Group provides a set of [Islandora Sample Objects](https://github.com/Islandora-Collaboration-Group/islandora-sample-objects) with corresponding metadata for testing Islandora's ingest process. These sample objects are organized by solution pack and are zipped for faster bulk ingestion.

* To download these sample objects, clone them to your computer's desktop:
```
git clone https://github.com/Islandora-Collaboration-Group/islandora-sample-objects.git
```

* Follow these ingestion instructions [How to Add an Item to a Digital Collection](https://wiki.duraspace.org/display/ISLANDORA/How+to+Add+an+Item+to+a+Digital+Collection)

* (Note: [Getting Started with Islandora](https://wiki.duraspace.org/display/ISLANDORA/Getting+Started+with+Islandora) contains explanations about content models, collections, and datastreams.)

* After ingesting content, you may need to add an Islandora Simple Search block to the Drupal structure. (The default search box will only search Drupal content, not Islandora content.) This might already exist in your current Drupal Production site as a feature.

    * Select from the menu: `Structure > Blocks > Islandora Simple Search`

    * Select: `Sidebar Second`

    * Click: `Save Blocks` at bottom of page

    * You may now search for ingested objects that have been indexed by SOLR

* After ingesting either the ICG sample objects or a selection of your pre-existing Fedora Production objects, continue to QC the migrated site, ensuring that objects display properly, the theme and design continue to work properly, there are no errors in the Drupal watchdog and everything matches the functionality of the previous non-ISLE Production Islandora Drupal site.

---

## Next Steps

Once you are ready to deploy your finished Drupal site, you may progress to:

* [Staging ISLE Installation: Migrate Existing Islandora Site](../install/install-staging-migrate.md)

---

## Additional Resources
* [ISLE Installation: Environments](../install/install-environments.md) helps explain the ISLE workflow structure, the associated files, and what values ISLE end users should use for the ".env", "local.env", etc.
* [Local ISLE Installation: Resources](../install/install-local-resources.md) contains Docker container passwords and URLs for administrator testing.
* [ISLE Installation: Troubleshooting](../install/install-troubleshooting.md) contains help for port conflicts, non-running Docker containers, etc.

---

### End of Local ISLE Installation: Migrate Existing Islandora Site

<!--

## Cloning to Local
The first step is to clone my fork of _ISLE_, namely [dg-isle](https://github.com/Digital-Grinnell/dg-isle.git), to my workstation at `~/GitHub/dg-isle`, checkout the `master` branch there, if necessary, and begin like so...

| Workstation Commands |
| --- |
| cd ~/GitHub <br/> git clone https://github.com/Digital-Grinnell/dg-isle.git <br/> cd dg-isle |

# Local ISLE Installation: New Site

OK, I began by reading through the guidance provided in [Local ISLE Installation: New Site](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-new.md#local-isle-installation-new-site).  Having met all the requirements and satisfied all assumptions, I embarked on each installation step.  Each section below documents any special conditions I imposed as well as outcomes of each step.

## Step 1: Choose a Project Name

In [Step 1](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-new.md#step-1-choose-a-project-name) I chose a project name, as before, of `dg` to replace instances of `yourprojectnamehere`.

## Step 1.5: Edit "/etc/hosts" File

The outcome of [Step 1.5](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-new.md#step-15-edit-etchosts-file) left me with an `/etc/hosts` file that looks like this:

```
##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##

## For Omeka-S v2
#127.0.0.1    localhost omeka.localdomain traefik.localdomain pma.localdomain solr.localdomain

## For ISLE ld
127.0.0.1  localhost dg.localdomain admin.dg.localdomain images.dg.localdomain portainer.dg.localdomain
```

Take note: In the above `/etc/hosts` file the last line that you see is also the last "uncommented" instance of `127.0.0.1 localhost...`.  This is critical!

## Step 2: Setup Git Project Repositories

Ok, I completed most of [Step 2](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-new.md#step-2-setup-git-project-repositories) long ago, so I've substituted a `git pull` command in place of `git clone`, and will now pick up with the sub-step that says `Run a git fetch`.  The results of the documented `git fetch icg-upstream` command are:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master›
╰─$ git fetch icg-upstream
remote: Enumerating objects: 543, done.
remote: Counting objects: 100% (543/543), done.
remote: Compressing objects: 100% (53/53), done.
remote: Total 931 (delta 339), reused 527 (delta 333), pack-reused 388
Receiving objects: 100% (931/931), 2.36 MiB | 5.78 MiB/s, done.
Resolving deltas: 100% (483/483), completed with 35 local objects.
From https://github.com/Islandora-Collaboration-Group/ISLE
 * [new branch]      ISLE-1.5.0           -> icg-upstream/ISLE-1.5.0
   4b8ac42..7cc8f6e  gh-pages             -> icg-upstream/gh-pages
 * [new branch]      marksandford-patch-2 -> icg-upstream/marksandford-patch-2
 * [new branch]      marksandford-patch-3 -> icg-upstream/marksandford-patch-3
   3344097..efd837e  master               -> icg-upstream/master
 * [new tag]         ISLE-1.5.0-release   -> ISLE-1.5.0-release
 * [new tag]         ISLE-1.5.1-release   -> ISLE-1.5.1-release
 * [new tag]         ISLE-1.4.2-release   -> ISLE-1.4.2-release
```

Next, the results of `git pull icg-upstream master`:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master›
╰─$ git pull icg-upstream master
From https://github.com/Islandora-Collaboration-Group/ISLE
 * branch            master     -> FETCH_HEAD
Auto-merging docs/install/install-local-migrate.md
CONFLICT (content): Merge conflict in docs/install/install-local-migrate.md
Auto-merging docker-compose.local.yml
Automatic merge failed; fix conflicts and then commit the result.
```

The one conflict in `install-local-migrate.md` were easy to resolve by accepting the new update from the `icg-upstream` remote.

Next, I commited the merge and pushed the result to my `dg-isle` master like so:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master›
╰─$ git status
On branch master
Your branch is up to date with 'origin/master'.

You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)

Changes to be committed:

	modified:   .circleci/config.yml
	modified:   .gitignore
	modified:   README.md
	renamed:    config/apache/php_ini/php_staging.ini -> config/apache/php_ini/php.staging.ini
	new file:   config/matomo-nginx/ngix.conf
	new file:   config/matomo/.gitignore
	new file:   config/matomo/.htaccess
	new file:   config/matomo/environment/dev.php
	new file:   config/matomo/environment/test.php
	new file:   config/matomo/environment/ui-test.php
	new file:   config/matomo/global.ini.php
	new file:   config/matomo/global.php
	modified:   docker-compose.demo.yml
	modified:   docker-compose.local.yml
	modified:   docker-compose.production.yml
	modified:   docker-compose.staging.yml
	modified:   docker-compose.test.yml
	modified:   docs/assets/isle-v140-git-cleanup-script.sh
	modified:   docs/contributor-docs/making-pr-guide.md
	modified:   docs/contributor-docs/style-guide.md
	modified:   docs/cookbook-recipes/example-aws-configuration.md
	modified:   docs/install/install-demo.md
	modified:   docs/install/install-environments.md
	modified:   docs/install/install-local-new.md
	modified:   docs/install/install-production-migrate.md
	modified:   docs/install/install-production-new.md
	modified:   docs/install/install-staging-migrate.md
	modified:   docs/install/install-staging-new.md
	modified:   docs/install/install-troubleshooting.md
	modified:   docs/optional-components/blazegraph.md
	modified:   docs/optional-components/components.md
	new file:   docs/optional-components/matomo.md
	modified:   docs/optional-components/tickstack.md
	modified:   docs/optional-components/varnish.md
	new file:   docs/release-notes/release-1-4-2.md
	new file:   docs/release-notes/release-1-5-0.md
	new file:   docs/release-notes/release-1-5-1.md
	modified:   mkdocs.yml
	renamed:    .env -> sample.env

Unmerged paths:
  (use "git add <file>..." to mark resolution)

	both modified:   docs/install/install-local-migrate.md

╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master*›
╰─$ git add .
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master*›
╰─$ git commit -m "Merged with icg-upstream v1.5.1"
[master 77db7f9] Merged with icg-upstream v1.5.1
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master›
╰─$ git push -u origin master
Counting objects: 239, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (91/91), done.
Writing objects: 100% (239/239), 331.16 KiB | 47.31 MiB/s, done.
Total 239 (delta 171), reused 208 (delta 143)
remote: Resolving deltas: 100% (171/171), completed with 39 local objects.
To https://github.com/Digital-Grinnell/dg-isle.git
   32a6219..77db7f9  master -> master
Branch 'master' set up to track remote branch 'master' from 'origin'.
```

All is well, thus far.  Moving on.

## Step 3: Edit the ".env" File to Point to the Local Environment

I did as instructed in [Step 3](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-new.md#step-3-edit-the-env-file-to-point-to-the-local-environment), but since I had previously modified `sample.env` in my repo, the resulting `.env` file was this:

```
#### Activated ISLE environment
# To use an environment other than the default Demo, please change values below
# from the default Demo to one of the following: Local, Test, Staging or Production
# For more information, consult https://islandora-collaboration-group.github.io/ISLE/install/install-environments/

COMPOSE_PROJECT_NAME=dg_local
BASE_DOMAIN=dg.localdomain
CONTAINER_SHORT_ID=ld
COMPOSE_FILE=docker-compose.local.yml:docker-compose.DG-FEDORA.yml
# :docker-compose.DATABASE.yml
```

Note the presence of a modified `COMPOSE_FILE` definition in my copy, with the addition of `docker-compose.DG-FEDORA.yml` used to pull in some convenient, local customization.

## Step 4: Create New Users and Passwords by Editing "local.env" File

This is another step that I completed long ago, and I don't believe there are any changes or additions here so, for now, I'm going to assume that all of my pertinent files are ready-to-go. The files involved in this step are: `local.env` and `config/apache/settings_php/settings.local.php`.

## Step 5: Create New Self-Signed Certs for Your Project

This is another step that I completed long ago, so all I did in this instance was look for the required files and changes to those files.  Here again, everything appears to be ready-to-go.

## Step 6: Download the ISLE Images

I ran `docker-compose pull` as instructed and after a couple of minutes I had this afirmative result:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master›
╰─$ docker-compose pull
Pulling isle-portainer ... done
Pulling traefik        ... done
Pulling mysql          ... done
Pulling solr           ... done
Pulling fedora         ... done
Pulling apache         ... done
Pulling image-services ... done
```

## Step 7: Launch Process

Time to give it a go with `docker-compose up -d`, as documented.  My results:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master›
╰─$ time docker-compose up -d
Recreating 7ac3d399c7b2_isle-portainer-ld ... done
Recreating 1aa37570c35e_isle-mysql-ld     ... done
Recreating 522d325b0a76_isle-proxy-ld     ... done
Recreating isle-solr-ld                   ... done
Recreating isle-fedora-ld                 ... error

ERROR: for isle-fedora-ld  Cannot start service fedora: error while creating mount source path '/Volumes/DG-FEDORA/datastreamStore': mkdir /Volumes/DG-FEDORA: permission denied

ERROR: for fedora  Cannot start service fedora: error while creating mount source path '/Volumes/DG-FEDORA/datastreamStore': mkdir /Volumes/DG-FEDORA: permission denied
ERROR: Encountered errors while bringing up the project.
docker-compose up -d  0.86s user 0.14s system 6% cpu 16.387 total
```

### Oops, I Forgot to Mount the DG-FEDORA Portable Repository

Been there, done that, again. Remember that custom `COMPOSE_FILE` line mentioned above in [Step 3](#step-3-edit-the-env-file-to-point-to-the-local-environment), well it requires that one of my `DG-FEDORA Portable Repo` USB memory sticks has to be mounted and accessible on the host. So I stuck stick `DG-FEDORA-0` into an available USB port and repeated the above command.  This time the result was:

```
╭─markmcfate@MAD25W812UJ1G9 ~/GitHub/dg-isle ‹ruby-2.3.0› ‹master›
╰─$ time docker-compose up -d                                                                         1 ↵
Removing isle-fedora-ld
isle-mysql-ld is up-to-date
isle-portainer-ld is up-to-date
isle-proxy-ld is up-to-date
isle-solr-ld is up-to-date
Recreating f7ab9f47188b_isle-fedora-ld ... done
Recreating isle-apache-ld              ... done
Recreating isle-images-ld              ... done
docker-compose up -d  0.79s user 0.13s system 12% cpu 7.127 total
```

Much better!

## Step 8: Run Islandora Drupal Site Install Script

After running the prescribed command I used the `Command + shift + A` command in _iTerm2_ to select/highlight all of the output from the last command and I copied that into [this gist](https://gist.github.com/McFateM/271cbd668331f9c863a685da3d1ebe3f) rather than pasting it all here. It appears the install worked with perhaps one exception, there is an `rsync` error at line 207 in the aforementioned gist.  Lines 206-208 from the gist read:

```
Copying Islandora Installation...
rsync: rename "/var/www/html/sites/default/.settings.php.0lfAZl" -> "sites/default/settings.php": Device or resource busy (16)
rsync error: some files/attrs were not transferred (see previous errors) (code 23) at main.c(1196) [sender=3.1.2]
```

I'm going to proceed to the next step and will try to determine if this issue was critical to the process, or if it can be ignored or easily overcome.

## Step 9: Test the Site

A web browser visit to [https://dg.localdomain/](https://dg.localdomain/) shows that the standard ISLE stack is working as a default-themed, pristine Islandora site with no front-page content and an empty FEDORA repository.  I was able to successfully login as `admin` with my super-secret password.

## Installing the DG Theme

[Step 10 in the documentation](https://github.com/Islandora-Collaboration-Group/ISLE/blob/master/docs/install/install-local-new.md#step-10-ingest-sample-objects) calls for ingest of some sample objects, but this is where I depart from the script since I've done this a number of times before and already have a working FEDORA repository at-the-ready.

So my focus here turned to installing the [digital_grinnell_bootstrap](https://github.com/DigitalGrinnell/digital_grinnell_bootstrap) theme instead.  Initially I did this with a pair of `git clone...` commands, but later in this process I'm tasked with saving my _Islandora / Drupal_ code as-a-whole into a larger _Git_ repository that will include these themes.  Cloning a _Git_ repository inside another can lead to significant workflow problems, so lets use _Git_ `submodules` instead.

To do this we will need to engage Git to make changes inside our Apache container, so it's important to note that our Drupal webroot, namely `/var/www/html` inside the Apache container, maps to `~/GitHub/dg-isle/data/apache/html` on our workstation and in our `dg-isle` repository. From my workstation the commands to engage our theme as a submodule were:

| Workstation Commands |
| --- |
| cd ~/GitHub/dg-isle/data/apache/html/sites/all/themes <br/> git submodule add -b 7.x-3.x https://github.com/drupalprojects/bootstrap.git <br/> mkdir -p ~/GitHub/dg-isle/data/apache/html/sites/default/themes <br/> cd ~/GitHub/dg-isle/data/apache/html/sites/default/themes <br/> git submodule add https://github.com/DigitalGrinnell/digital\_grinnell\_bootstrap.git |

Then inside the Apache container...

| Apache Container Commands |
| --- |
| cd /var/www/html/sites/all/themes <br/> chown -R islandora:www-data * <br/> cd /var/www/html/sites/default/themes <br/> chown -R islandora:www-data * <br/> drush -y pm-enable bootstrap digital\_grinnell\_bootstrap <br/> drush vset theme\_default digital\_grinnell\_bootstrap |


Success! The theme is in place and active on my [dg.localdomain](https://dg.localdomain/) site.  Just one more tweak here...

I visited [#overlay=admin/appearance/settings/digital\_grinnell\_bootstrap](https://dg.localdomain/#overlay=admin/appearance/settings/digital\_grinnell\_bootstrap) and made sure ONLY the following boxes are checked:

  - Logo
  - Shortcut Icon
  - Use the default logo
  - Use the default shortcut icon

All other theme settings should be default values and need not be changed.

A visit to [the site](https://dg.localdomain/) with a refresh showed that this worked!







# Content Below This Point Has Been Commented Out

<!-- Progress Marker

## Connecting to FEDORA

The `docker-compose.override.yml` file in the `local-dg-fedora` branch of my [dg-isle](https://github.com/Digital-Grinnell/dg-isle) project includes 3 lines that direct _FEDORA_ and _FGSearch_ to use the mounted and pre-configured `/Volumes/DG-FEDORA` USB stick for object storage. The commands and process required to use the USB stick are presented in [post 046, "DG-FEDORA: A Portable Object Repository"](https://static.grinnell.edu/blogs/McFateM/posts/046-dg-fedora-a-portable-object-repository/).


## Restarting the Stack

Moving to [Step 7](https://github.com/Digital-Grinnell/dg-isle/blob/master/docs/install/install-local-new.md#step-7-launch-process) in the install [documentation](https://github.com/Digital-Grinnell/dg-isle/blob/master/docs/install/) produced [this gist](@TODO:add-missing-link-here).

| Workstation Commands |
| --- |
| cd ~/Projects/GitHub/dg-isle <br/> time docker-compose up -d |

## Running the Drupal Installer Script

Moving on to [Step 8 according to the documentation](https://github.com/Digital-Grinnell/dg-isle/blob/master/docs/install/install-local-new.md#step-8-run-islandora-drupal-site-install-script)...

| Workstation Commands |
| --- |
| cd ~/Projects/GitHub/dg-isle <br/> time docker exec -it isle-apache-ld bash /utility-scripts/isle\_drupal\_build\_tools/isle\_islandora\_installer.sh |

It was at this point I discovered a new gem in `iTerm2`:  If you hit `Command + shift + A` the terminal will select/highlight all of the output from the last command.  Exactly what I was hoping for.  I've copied all that output and stuck it in [this gist](https://gist.github.com/Digital-Grinnell/dbdc3a2f46dc5c3bbf7176e1384202d5) rather than pasting it all here.

## Testing the Site

Moving on to [Step 9 in the documentation](https://github.com/Digital-Grinnell/dg-isle/blob/master/docs/install/install-local-new.md#step-9-test-the-site)...

A web browser visit to [https://dg.localdomain/](https://dg.localdomain/) shows that the standard _ISLE_ stack is working~, and I was able to successfully login as `admin` with my super-secret password.

## Installing the DG Theme

[Step 10 in the documentation](https://github.com/Digital-Grinnell/dg-isle/blob/master/docs/install/install-local-new.md#step-10-ingest-sample-objects) calls for ingest of some sample objects, but this is where I depart from the script since I've done this a number of times before.

So my focus here turned to installing the [digital_grinnell_bootstrap](https://github.com/DigitalGrinnell/digital_grinnell_bootstrap) theme instead.  Initially I did this with a pair of `git clone...` commands, but later in this process I'm tasked with saving my _Islandora / Drupal_ code as-a-whole into a larger _Git_ repository that will include these themes.  Cloning a _Git_ repository inside another can lead to significant workflow problems, so lets use _Git_ `submodules` instead.

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/themes <br/> git submodule add -b 7.x-3.x https://github.com/drupalprojects/bootstrap.git <br/> chown -R islandora:www-data * <br/> mkdir -p /var/www/html/sites/default/themes <br/> cd /var/www/html/sites/default/themes <br/> git submodule add https://github.com/DigitalGrinnell/digital\_grinnell\_bootstrap.git <br/> chown -R islandora:www-data * <br/> cd /var/www/html/sites/default <br/> drush -y pm-enable bootstrap digital\_grinnell\_bootstrap <br/> drush vset theme\_default digital\_grinnell\_bootstrap |

Success! The theme is in place and active on my [dg.localdomain](https://dg.localdomain/) site.  Just one more tweak here...

I visited [#overlay=admin/appearance/settings/digital\_grinnell\_bootstrap](https://dg.localdomain/#overlay=admin/appearance/settings/digital\_grinnell\_bootstrap) and made sure ONLY the following boxes are checked:

  - Logo
  - Shortcut Icon
  - Use the default logo
  - Use the default shortcut icon

All other theme settings should be default values and need not be changed.

A visit to [the site](https://dg.localdomain/) with a refresh showed that this worked!

## Install the Islandora Multi-Importer (IMI)

It's important that we take this step BEFORE any that follow, otherwise the module will not install properly for reasons unknown.  Note that I'm installing a _Digital.Grinnell_-specific fork of the module here, and the process is this:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> git submodule add https://github.com/DigitalGrinnell/islandora\_multi\_importer.git <br/> chown -R islandora:www-data * <br/> cd islandora\_multi\_importer <br/> composer install <br/> drush -y en islandora\_multi\_importer |

## Install the Missing *Backup and Migrate* Module

The *Backup and Migrate* module will be needed to quickly get our new _ISLE_ configured as we'd like.  Install it like so:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/contrib <br/> drush dl backup\_migrate <br/> drush -y en backup\_migrate |

## Backup and Restore the Database Using *Backup and Migrate*

From the [https://digital.grinnell.edu](https://digital.grinnell.edu) production site...

  - Login as `System Admin`
  - From the `Development` menu (on the right) select `Clear Cache`
  - On the home page (https://digital.grinnell.edu), scroll to the bottom of the right-hand column.
  - Use the `Quick Backup` dialog, with all the defaults, to create and download a fresh backup.

Alternatively, you could...

  - Navigate to [https://digital.grinnell.edu/admin/config/system/backup_migrate/export/advanced](https://digital.grinnell.edu/admin/config/system/backup_migrate/export/advanced)
  - In the `Load Settings` box select `Default Settings w/ Users`
  - Click `Backup now` to backup the site
  - Click `Save` to save the file to your workstation `Downloads` folder

In the [https://dg.localdomain](https://dg.localdomain) site...

  - Visit [#overlay=admin/config/system/backup_migrate/restore](https://dg.localdomain/#overlay=admin/config/system/backup_migrate/restore)
  - Click the `Restore` tab
  - Select the `Restore from an uploaded file` option
  - Click `Browse` in the `Upload a Backup File`
  - Navigate to your workstation `Downloads` folder and choose the backup file created moments ago
  - Click `Restore now`
  - Navigate your browser back to [https://dg.localdomain/](https://dg.localdomain/)
  - Take note of any warnings or errors that may be present.

## Restore Results...Lots of Warnings

OK, so when I did all of the above backup/restore process what I got back in the "Navigate your browser..." step was an unreadable host of warnings. Without panic I very calmly returned to my terminal and the shell open in the _Apache_ container and:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/default <br/> drush cc all |

This returned a number of warnings about missing modules and such.  No matter, that was to be expected and the full list of warnings is captured in [this gist](https://gist.github.com/Digital-Grinnell/bc47f4528e702f1afeb58ceaab66b28c).

The remedy for most of these missing bits was to do the following while still in my open *Apache* terminal/shell:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/default <br/> drush dl masquerade announcements email git\_deploy maillog r4032login smtp views\_bootstrap admin\_theme google\_analytics\_counter <br/> drush cc all |

Visiting the [site](https://dg.localdomain/) again shows that most of the *Drupal* missing modules are happy now, but there are still a number of *Islandora* bits missing, so I was left with the output as shown in [this gist](https://gist.github.com/Digital-Grinnell/353fc06917db78d904a084b94d9b9982).

Next steps and sections, still working "off-script", will install all of these missing parts.

## Installing the Missing Islandora and Custom Modules

If I recall correctly, all of the missing _Islandora_ and custom modules listed above can be found in the *Apache* container on *DGDocker1*, our production instance of _ISLE_, at `/var/www/html/sites/all/modules/islandora`.  So I started this process by opening a new shell in the aforementioned container on *DGDocker1* like so:

```
╭─mcfatem@dgdocker1 ~
╰─$ docker exec -it isle-apache-dg bash
root@90ae0691e764:/# cd /var/www/html/sites/all/modules/islandora
root@90ae0691e764:/var/www/html/sites/all/modules/islandora# l
dg7/                                    islandora_multi_importer/            islandora_solution_pack_compound/
idu/                                    islandora_oai/                       islandora_solution_pack_disk_image/
islandora/                              islandora_object_lock/               islandora_solution_pack_entities/
islandora_bagit/                        islandora_ocr/                       islandora_solution_pack_image/
islandora_batch/                        islandora_openseadragon/             islandora_solution_pack_large_image/
islandora_binary_object/                islandora_paged_content/             islandora_solution_pack_newspaper/
islandora_book_batch/                   islandora_pathauto/                  islandora_solution_pack_oralhistories/
islandora_bookmark/                     islandora_pdfjs/                     islandora_solution_pack_pdf/
islandora_checksum/                     islandora_pdfjs_reader/              islandora_solution_pack_video/
islandora_checksum_checker/             islandora_premis/                    islandora_solution_pack_web_archive/
islandora_collection_search/            islandora_scholar/                   islandora_sync/
islandora_context/                      islandora_simple_workflow/           islandora_videojs/
islandora_feeds/                        islandora_solr_collection_view/      islandora_webform/
islandora_fits/                         islandora_solr_facet_pages/          islandora_xacml_editor/
islandora_image_annotation/             islandora_solr_metadata/             islandora_xml_forms/
islandora_importer/                     islandora_solr_search/               islandora_xmlsitemap/
islandora_internet_archive_bookreader/  islandora_solr_views/                islandora_xquery/
islandora_jwplayer/                     islandora_solution_pack_audio/       objective_forms/
islandora_marcxml/                      islandora_solution_pack_book/        php_lib/
```

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> ls |

My recollection has been confirmed!  So the next step was to visit each missing module's folder to see what *git* `remote` each is tied to, like so:

```
root@90ae0691e764:/var/www/html/sites/all/modules/islandora# cd dg7; git remote -v
origin	https://github.com/DigitalGrinnell/dg7.git (fetch)
origin	https://github.com/DigitalGrinnell/dg7.git (push)
root@90ae0691e764:/var/www/html/sites/all/modules/islandora/dg7# cd ../idu; git remote -v
origin	https://github.com/DigitalGrinnell/idu.git (fetch)
origin	https://github.com/DigitalGrinnell/idu.git (push)
root@90ae0691e764:/var/www/html/sites/all/modules/islandora/idu# cd ../islandora_binary_object/; git remote -v
origin	git://github.com/discoverygarden/islandora_binary_object.git (fetch)
origin	git://github.com/discoverygarden/islandora_binary_object.git (push)
root@90ae0691e764:/var/www/html/sites/all/modules/islandora/islandora_binary_object# cd ../islandora_collection_search/; git remote -v
origin	https://github.com/discoverygarden/islandora_collection_search (fetch)
origin	https://github.com/discoverygarden/islandora_collection_search (push)
root@90ae0691e764:/var/www/html/sites/all/modules/islandora/islandora_collection_search# cd ../islandora_mods_display/; git remote -v
origin	https://github.com/DigitalGrinnell/islandora_mods_display.git (fetch)
origin	https://github.com/DigitalGrinnell/islandora_mods_display.git (push)
root@90ae0691e764:/var/www/html/sites/all/modules/islandora/islandora_mods_display# cd ../islandora_solution_pack_oralhistories/; git remote -v
origin	https://github.com/Islandora-Labs/islandora_solution_pack_oralhistories.git (fetch)
origin	https://github.com/Islandora-Labs/islandora_solution_pack_oralhistories.git (push)
root@90ae0691e764:/var/www/html/sites/all/modules/islandora/islandora_solution_pack_oralhistories# cd ../islandora_pdfjs_reader/; git remote -v
origin	git://github.com/nhart/islandora_pdfjs_reader.git (fetch)
origin	git://github.com/nhart/islandora_pdfjs_reader.git (push)
root@90ae0691e764:/var/www/html/sites/all/modules/islandora/islandora_pdfjs_reader# cd ../islandora_solr_collection_view/; git remote -v
origin	https://github.com/Islandora-Labs/islandora_solr_collection_view.git (fetch)
origin	https://github.com/Islandora-Labs/islandora_solr_collection_view.git (push)

```
| Apache Container Commands (on **PRODUCTION** _ISLE_ only!)* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> cd dg7; git remote -v <br/> cd ../idu; git remote -v <br/> cd ../islandora\_binary\_object/; git remote -v <br/> cd ../islandora\_collection\_search/; git remote -v <br/> cd ../islandora\_mods\_display/; git remote -v <br/> cd ../islandora\_solution\_pack\_oralhistories/; git remote -v <br/> cd ../islandora\_pdfjs\_reader/; git remote -v <br/> cd ../islandora\_solr\_collection_view/; git remote -v |

Note that I did NOT bother with the `islandora_multi_importer` (IMI) directory since I know for a fact that IMI requires installation via *Composer*. I also didn't bother looking for `transcript_ui` because it is a known sub-module of `islandora_solution_pack_oralhistories`.

It looks like all of the others can just be added as _Git_ submodules like so:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/all/modules/islandora <br/> git submodule add https://github.com/DigitalGrinnell/dg7.git <br/> git submodule add https://github.com/DigitalGrinnell/idu.git <br/> # git submodule add git://github.com/discoverygarden/islandora\_binary\_object.git <br/> git submodule add https://github.com/discoverygarden/islandora\_collection\_search <br/> git submodule add https://github.com/DigitalGrinnell/islandora\_mods\_display.git <br/> git submodule add https://github.com/Islandora-Labs/islandora\_solution\_pack\_oralhistories.git <br/> # git submodule add git://github.com/nhart/islandora\_pdfjs\_reader.git <br/> git submodule add https://github.com/Islandora-Labs/islandora\_solr\_collection_view.git <br/> chown -R islandora:www-data * <br/> cd /var/www/html/sites/default <br/> drush cc all |

The `chown` command line above was required to bring ALL of the new modules' ownership into line with everything else in [dg.localdomain](https://dg.localdomain/).  Also note that two of the lines, for `islandora_binary_object` and `islandora_pdfjs_reader`, are commented out because of known issues with installation of those modules.

## Temporarily Eliminate Warnings

So my site, [https://dg.localdomain/](https://dg.localdomain/), is still issuing a few annoying warnings about missing pieces.  It's a safe bet that we don't need these modules, at least not right now, so just do this:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/default <br/> drush -y dis islandora\_binary\_object islandora\_pdfjs\_reader <br/> drush sqlq "DELETE FROM system WHERE name = 'islandora\_binary\_object' AND type = 'module';" <br/> drush sqlq "DELETE FROM system WHERE name = 'islandora\_pdfjs\_reader' AND type = 'module';" <br/> drush sqlq "DELETE FROM system WHERE name = 'islandora\_google\_scholar' AND type = 'module';" <br/> drush sqlq "DELETE FROM system WHERE name = 'phpexcel' AND type = 'module';" <br/> drush sqlq "DELETE FROM system WHERE name = 'ldap\_servers' AND type = 'module';" <br/> drush sqlq "DELETE FROM system WHERE name = 'ihc' AND type = 'module';" <br/> drush cc all <br/> drush cc all |

You saw that correctly, I did `drush cc all` twice, just for good measure.  Now, just a couple more issues to deal with...

## Need a `private` File System

At this point the system is still issuing some warnings, and the most annoying is:

```
Warning: file_put_contents(private:///.htaccess): failed to open stream: &quot;DrupalPrivateStreamWrapper::stream_open&quot; call failed in file_put_contents() (line 496 of /var/www/html/includes/file.inc).
```

A visit in my browser to [https://dg.localdomain/#overlay=admin/reports/status](https://dg.localdomain/#overlay=admin/reports/status) helps to pinpoint the problem... we don't yet have a `private` file system.  Let's create one like so:

| Apache Container Commands* |
| --- |
| cd /var/www <br/> mkdir private <br/> chown islandora:www-data private <br/> chmod 774 private <br/> cd /var/www/html/sites/default <br/> drush cc all |

Now that same status report, [https://dg.localdomain/#overlay=admin/reports/status](https://dg.localdomain/#overlay=admin/reports/status), shows that we are still operating in `maintenance mode`, and some of our newest modules may require database updates.  To remedy those two conditions:

| Apache Container Commands* |
| --- |
| cd /var/www/html/sites/default <br/> drush updatedb -y <br/> drush vset maintenance\_mode 0 <br/> drush cc all |

## Solr Schema is NOT Right

Ok, at this point I believe that I have a good _Drupal_ database, a working _Fedora_ repository, and a solid _Islandora/Drupal_ codebase; but the _Solr_ schema associated with this configuration is **NOT** up-to-speed with _Digital.Grinnell's_ so the `dg7` code and the `dg7_collection` view are expecting _Solr_ fields that do not yet exist here.  What to do?

1. Save the current database using _Backup and Migrate_.
2. Save the current codebase to the host using `mkdir -p ../dg-islandora; docker cp isle-apache-ld:/var/www/html/. ../dg-islandora` and putting all of it into a new [Digital-Grinnell/dg-islandora](https://github.com/Digital-Grinnell/dg-islandora) repository on _GitHub_ for safe-keeping.
3. Update the _FEDORA_ and _Solr_ schema and configuration using the guidance found in https://github.com/Digital-Grinnell/ISLE-DG-Essentials/blob/master/README.md
4. Try pulling up the [site](https://dg.localdomain/) again.

# Huzzah! It works!

## Final Step...Capture the Working Code in `dg-islandora`

To wrap this up I followed [Step 11 in the install-local-new.md](https://github.com/Islandora-Collaboration-Group/ISLE/blob/ISLE-1.3.0/docs/install/install-local-new.md#step-11-check-in-the-newly-created-islandora-drupal-site-code-into-is-git-repository) document to capture the state of my _Islandora/Drupal_ code.  In doing so I created my PRIVATE code repository, [dg-islandora](https://github.com/Digital-Grinnell/dg-islandora).

And that's a wrap.  Until next time...

-->
