---
title: "Creating a Migration Collection"
publishdate: 2022-10-12
draft: false
tags:
  - migration
  - collection
  - Digital.Grinnell
  - iduf
  - JSTOR
  - Collection Builder
---

As we continue to look at potential migration paths for our [Digital.Grinnell](https://digital.grinnell.edu) (DG) content, it's become apparent that it would be nice to have a small "test" or "migration" collection of objects to play with.  The collection should have a small, but diverse, set of objects covering all of the popular content, or `CModel`, types that we currently have in DG. 

Since _Slack_ now imposes a 90-day lifespan for posts (we are using only free-tier _Slack_ services at this time) I thought I had better create this blog post to capture key parts of a relevant _Slack_ conversation...  

```slack
Mark M.  September 13, 2022 @ 11:49 AM

I modified my iduF MigrateObject command yesterday and now have it working on our staging server, https://isle-stage.grinnell.edu.  I’ve successfully created a new `grinnell:migration-test` collection there and have 42 objects shared into it via the new command.  I plan to add a few more, up to 50 total objects, this afternoon, but all of this is taking place only in isle-stage thus far.

I have a plan to repeat the process in digital.grinnell.edu if all goes well in staging, but before I do that I’d like to push isle-stage as far as I can.  That will include at least one export of the objects and metadata, probably using the same process I created for our  metadata review in 2020.  

I might also re-bag all of the objects and hold those bags in a dedicated network storage location apart from our traditional backup storage.

Any other ideas/suggestions how I might “export” these objects?  Maybe a better question… What target platforms should I plan to provide exports for so that test objects can be ingested as part of migration testing/evaluation?
```

## The `MigrateObject` Command

As mentioned above, I elected to use the `iduF` command named `MigrateObject` to populate a new collection named `grinnell:migration-test`.  The command's abridged help text says...

```
╭─islandora@dgdockerx ~
╰─$ docker exec -it isle-apache-dgs bash
root@db16bc9ff4c3:/# cd /var/www/html/sites/default/
root@db16bc9ff4c3:/var/www/html/sites/default# drush -u 1 iduF MigrateObject --help
...
    MigrateObject -
      Migrates an object from its --source (or --source=None) collection to --replace.  See also --share option. [Verified 31-Aug-2018]
...
```

The `MigrateObject` command was executed a total of 9 times to populate the `migration-test` collection using the script shown here:

```sh
drush -u 1 iduF grinnell:1000 MigrateObject --share --source="grinnell:college-life" --replace="grinnell:migration-test"
drush -u 1 iduF grinnell:5593 MigrateObject --share --source="grinnell:student-scholarship" --replace="grinnell:migration-test"
drush -u 1 iduF grinnell:10001 MigrateObject --share --source="grinnell:faculty-scholarship" --replace="grinnell:migration-test"
drush -u 1 iduF grinnell:13273 MigrateObject --share --source="grinnell:student-scholarship" --replace="grinnell:migration-test"
drush -u 1 iduF grinnell:16394 MigrateObject --share --source="grinnell:postcards" --replace="grinnell:migration-test"
drush -u 1 iduF grinnell:17289 MigrateObject --share --source="grinnell:archives-suppressed" --replace="grinnell:migration-test"
drush -u 1 iduF grinnell:19423 MigrateObject --share --source="grinnell:alumni-oral-histories" --replace="grinnell:migration-test"
drush -u 1 iduF grinnell:23345 MigrateObject --share --source="grinnell:faculty-scholarship" --replace="grinnell:migration-test"
drush -u 1 iduF grinnell:23517 MigrateObject --share --source="grinnell:college-life" --replace="grinnell:migration-test"
```

The following is a simple list of the objects, not including pages and children, and their corresponding `CModel`.

PID            | CModel                          | Details
---            | ---                             | ---
grinnell:1000  | islandora:bookCModel            | A 14-page book
grinnell:5593  | islandora:sp-audioCModel        | A very large audio recording
grinnell:10001 | islandora:compoundCModel        | A compound parent object with 8 children including some binary CModel objects
grinnell:13273 | islandora:sp_videoCModel        | A short video
grinnell:16394 | islandora:sp_basic_image        | A JPG basic image
grinnell:17289 | islandora:sp_web_archive        | A WARC (web-archive) of a small website
grinnell:19423 | islandora:oralhistoriesCModel   | An alumni oral history
grinnell:23345 | islandora:sp_pdf                | A multi-page PDF
grinnell:23517 | islandora:sp_large_image_cmodel | A TIFF large image

## The Collection

I subsequently visited the new collection at https://isle-stage.grinnell.edu/islandora/object/grinnell:migration-test/manage where I found this summary of the results to confirm:

{{% figure title="Summary of Objects in `grinnell:migration-test`" src="/images/post-129/migration-test-collection.png" %}} 

## My Bag of Tricks

This is not my first rodeo, so I turned to [my blog](https://static.grinnell.edu/dlad-blog/) in order to export the new collection.  Specifically, I turned to [Exporting, Editing & Replacing MODS Datastreams: Updated Technical Details](https://static.grinnell.edu/dlad-blog/posts/115-exporting-editing-replacing-mods-datastreams-updated-technical-details/).  Only steps 1 and 2 would be necessary.  `Step 1a` and `1b` were done long ago on the staging server that I'm using, and `Step 1c` currently isn't even possible (another story) so here's what I did starting with `Step 1d`, step-by-step.

<!--

## Step 1c - Mounting //STORAGE to DGDockerX

This step in the blog post is designed to mount a specific location in our `//Storage` server to the `DGDocker1` host, but I need `DGDockerX` in this instance AND `//Storage` is currently NOT accessible to either of these nodes.  However, there is still a directory mounted at `/mnt/storage` and it's accessible to our `Apache` containter (`isle-apache-dgs`) there; it's just not "network" storage. 

So, I did this on `DGDockerX` instead, with intent to modify subsequent steps to work properly.

```sh
╭─islandora@dgdockerx /mnt/storage
╰─$ mkdir migration-test-collection
╭─islandora@dgdockerx /mnt/storage
╰─$ ll
total 24K
drwxr-xr-x.  6 islandora islandora 4.0K Oct 13 09:05 .
drwxr-xr-x. 13 root      root      4.0K Jul 21 10:11 ..
drwxr-xr-x.  3 islandora islandora 4.0K Jan 21  2020 Bag-grinnell_5219
drwxr-xr-x.  3 islandora islandora 4.0K Jan 21  2020 Bag-grinnell_6809
drwxr-xr-x.  3 islandora islandora 4.0K Jan 21  2020 Bag-grinnell_6810
drwxrwxr-x.  2 islandora islandora 4.0K Oct 13 09:05 migration-test-collection
```

Now, if I open a shell into the `Apache` container let's see what we have.

```sh
╭─islandora@dgdockerx /mnt/storage
╰─$ docker exec -it isle-apache-dgs bash
root@db16bc9ff4c3:/# cd /mnt/storage
root@db16bc9ff4c3:/mnt/storage# ll
total 28
drwxr-xr-x. 6 islandora islandora 4096 Oct 13 14:05 ./
drwxr-xr-x. 1 root      root      4096 Sep 19 15:06 ../
drwxr-xr-x. 3 islandora islandora 4096 Jan 21  2020 Bag-grinnell_5219/
drwxr-xr-x. 3 islandora islandora 4096 Jan 21  2020 Bag-grinnell_6809/
drwxr-xr-x. 3 islandora islandora 4096 Jan 21  2020 Bag-grinnell_6810/
drwxrwxr-x. 2 islandora islandora 4096 Oct 13 14:05 migration-test-collection/
```

Just what the doctor ordered!  -->

## Step 1d - Using Drush islandora_datastream_export

To execute this step I needed to copy the `export.sh` script and `ri-query.txt` from `DGDocker1`, modify them a little, and make them available inside the `Apache` container on `DGDockerX`, something like this:

```sh
╭─islandora@dgdockerx ~
╰─$ rsync -aruvi islandora@dgdocker1.grinnell.edu:/home/islandora/export.sh .                                                              23 ↵
receiving incremental file list
>f+++++++++ export.sh

sent 43 bytes  received 894 bytes  624.67 bytes/sec
total size is 782  speedup is 0.83
╭─islandora@dgdockerx ~
╰─$ rsync -aruvi islandora@dgdocker1.grinnell.edu:/home/islandora/ri-query.txt .
receiving incremental file list
>f+++++++++ ri-query.txt

sent 43 bytes  received 245 bytes  192.00 bytes/sec
total size is 130  speedup is 0.45
```

Let's have a look at the script and the SPARQL query...

```sh
╭─islandora@dgdockerx ~
╰─$ cat export.sh ri-query.txt
Apache=isle-apache-dg
Target=/utility-scripts
# wget https://gist.github.com/McFateM/5bd7e5b0fa5d2928b2799d039a4c0fab/raw/collections.list
while read collection
do
    cp -f ri-query.txt query.sparql
    sed -i 's|COLLECTION|'${collection}'|g' query.sparql
    docker cp query.sparql ${Apache}:${Target}/${collection}.sparql
    rm -f query.sparql
    q=${Target}/${collection}.sparql
    echo "Processing collection '${collection}'; Query is '${q}'..."
    docker exec -w ${Target} ${Apache} mkdir -p exported-MODS/${collection}
    docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 islandora_datastream_export --export_target=${Target}/exported-MODS/${collection} --query=${q} --query_type=islandora_datastream_exporter_ri_query  --dsid=MODS
done < collections.list
```

```sh
╭─islandora@dgdockerx ~
╰─$ cp ri-query.txt query.sparql
╭─islandora@dgdockerx ~
╰─$ cat query.sparql
SELECT ?pid
FROM <#ri>
WHERE {
  ?pid <fedora-rels-ext:isMemberOfCollection> <info:fedora/grinnell:COLLECTION>
}
OFFSET %offset%
```

...and make some modifications to our instances to produce these...

```sh
╭─islandora@dgdockerx ~
╰─$ cat export.sh
Apache=isle-apache-dgs
Target=/utility-scripts
collection=migration-test
#
docker cp query.sparql ${Apache}:${Target}/${collection}.sparql
q=${Target}/${collection}.sparql
echo "Processing collection '${collection}'; Query is '${q}'..."
docker exec -w ${Target} ${Apache} mkdir -p exported-MODS/${collection}
docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 islandora_datastream_export --export_target=${Target}/exported-MODS/${collection} --query=${q} --query_type=islandora_datastream_exporter_ri_query  --dsid=MODS

╭─islandora@dgdockerx ~
╰─$ cat query.sparql
SELECT ?pid
FROM <#ri>
WHERE {
  ?pid <fedora-rels-ext:isMemberOfCollection> <info:fedora/grinnell:migration-test>
}
OFFSET %offset%
```

Now, let's run the `export.sh` script...

```sh
╭─islandora@dgdockerx ~
╰─$ source export.sh
Processing collection 'migration-test'; Query is '/utility-scripts/migration-test.sparql'...
Processing results 1 to 9                                                   [ok]
Datastream exported succeeded for grinnell:1000.                       [success]
Datastream exported succeeded for grinnell:19423.                      [success]
Datastream exported succeeded for grinnell:17289.                      [success]
Datastream exported succeeded for grinnell:23345.                      [success]
Datastream exported succeeded for grinnell:10001.                      [success]
Datastream exported succeeded for grinnell:5593.                       [success]
Datastream exported succeeded for grinnell:16934.                      [success]
Datastream exported succeeded for grinnell:13273.                      [success]
Datastream exported succeeded for grinnell:23517.                      [success]
```

So, the above results should be found in our `Apache` container's `/utility-scripts/exported-MODS/migration-test/` directory, like so...

```sh
╭─islandora@dgdockerx ~
╰─$ docker exec -it isle-apache-dgs bash
root@db16bc9ff4c3:/# cd /utility-scripts/exported-MODS/migration-test/
root@db16bc9ff4c3:/utility-scripts/exported-MODS/migration-test# ll
total 48
drwxr-xr-x. 2 root root 4096 Oct 13 14:41 ./
drwxr-xr-x. 3 root root 4096 Oct 13 14:41 ../
-rw-r--r--. 1 root root 3339 Oct 13 14:43 grinnell_10001_MODS.xml
-rw-r--r--. 1 root root 3003 Oct 13 14:43 grinnell_1000_MODS.xml
-rw-r--r--. 1 root root 3696 Oct 13 14:43 grinnell_13273_MODS.xml
-rw-r--r--. 1 root root 3099 Oct 13 14:43 grinnell_16934_MODS.xml
-rw-r--r--. 1 root root 2168 Oct 13 14:43 grinnell_17289_MODS.xml
-rw-r--r--. 1 root root 3425 Oct 13 14:43 grinnell_19423_MODS.xml
-rw-r--r--. 1 root root 3580 Oct 13 14:43 grinnell_23345_MODS.xml
-rw-r--r--. 1 root root 2047 Oct 13 14:43 grinnell_23517_MODS.xml
-rw-r--r--. 1 root root 5308 Oct 13 14:43 grinnell_5593_MODS.xml
```

Next, lets copy these back to the `DGDockerX` host.

```sh
╭─islandora@dgdockerx ~
╰─$ mkdir migration-test
╭─islandora@dgdockerx ~
╰─$ docker cp isle-apache-dgs:/utility-scripts/exported-MODS/migration-test/. migration-test/.
╭─islandora@dgdockerx ~
╰─$ ll migration-test
total 48K
drwxrwxr-x.  2 islandora islandora 4.0K Oct 13 09:54 .
drwx------. 22 islandora islandora 4.0K Oct 13 09:54 ..
-rw-r--r--.  1 islandora islandora 3.3K Oct 13 09:43 grinnell_10001_MODS.xml
-rw-r--r--.  1 islandora islandora 3.0K Oct 13 09:43 grinnell_1000_MODS.xml
-rw-r--r--.  1 islandora islandora 3.7K Oct 13 09:43 grinnell_13273_MODS.xml
-rw-r--r--.  1 islandora islandora 3.1K Oct 13 09:43 grinnell_16934_MODS.xml
-rw-r--r--.  1 islandora islandora 2.2K Oct 13 09:43 grinnell_17289_MODS.xml
-rw-r--r--.  1 islandora islandora 3.4K Oct 13 09:43 grinnell_19423_MODS.xml
-rw-r--r--.  1 islandora islandora 3.5K Oct 13 09:43 grinnell_23345_MODS.xml
-rw-r--r--.  1 islandora islandora 2.0K Oct 13 09:43 grinnell_23517_MODS.xml
-rw-r--r--.  1 islandora islandora 5.2K Oct 13 09:43 grinnell_5593_MODS.xml
```

And since `/mnt/storage` isn't accessible* let's copy them to my Mac workstation, MA10713, which will be taking the place of iMac 8660 in the next step.  So, on my Mac workstation...

 \**Yes, I have an open ticket for ITS to remedy that...someday, maybe?*

```sh
╭─mcfatem@MAC02FK0XXQ05Q ~
╰─$ mkdir migration-test
╭─mcfatem@MAC02FK0XXQ05Q ~
╰─$ cd migration-test
╭─mcfatem@MAC02FK0XXQ05Q ~/migration-test
╰─$ rsync -aruvi islandora@dgdockerx.grinnell.edu:/home/islandora/migration-test/. . --progress
receiving file list ...
10 files to consider
.d..tp... ./
>f+++++++ grinnell_10001_MODS.xml
        3339 100%    3.18MB/s    0:00:00 (xfer#1, to-check=8/10)
>f+++++++ grinnell_1000_MODS.xml
        3003 100%    2.86MB/s    0:00:00 (xfer#2, to-check=7/10)
>f+++++++ grinnell_13273_MODS.xml
        3696 100%    1.76MB/s    0:00:00 (xfer#3, to-check=6/10)
>f+++++++ grinnell_16934_MODS.xml
        3099 100%    1.48MB/s    0:00:00 (xfer#4, to-check=5/10)
>f+++++++ grinnell_17289_MODS.xml
        2168 100%  705.73kB/s    0:00:00 (xfer#5, to-check=4/10)
>f+++++++ grinnell_19423_MODS.xml
        3425 100%  836.18kB/s    0:00:00 (xfer#6, to-check=3/10)
>f+++++++ grinnell_23345_MODS.xml
        3580 100%  874.02kB/s    0:00:00 (xfer#7, to-check=2/10)
>f+++++++ grinnell_23517_MODS.xml
        2047 100%  399.80kB/s    0:00:00 (xfer#8, to-check=1/10)
>f+++++++ grinnell_5593_MODS.xml
        5308 100%    1.01MB/s    0:00:00 (xfer#9, to-check=0/10)

sent 220 bytes  received 30369 bytes  20392.67 bytes/sec
total size is 29665  speedup is 0.97
╭─mcfatem@MAC02FK0XXQ05Q ~/migration-test
╰─$ ll
total 80
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.3K Oct 13 09:43 grinnell_10001_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   2.9K Oct 13 09:43 grinnell_1000_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.6K Oct 13 09:43 grinnell_13273_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.0K Oct 13 09:43 grinnell_16934_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   2.1K Oct 13 09:43 grinnell_17289_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.3K Oct 13 09:43 grinnell_19423_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.5K Oct 13 09:43 grinnell_23345_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   2.0K Oct 13 09:43 grinnell_23517_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   5.2K Oct 13 09:43 grinnell_5593_MODS.xml
```

## Finally... Step 2 - Map-MODS-to-MASTER Python 3 Script

iMac 8660 is due to be retired/removed any day now, so I'm moving all components of this step to my Mac workstation, MA10713.  Since the project is stored in _GitHub_ I was able to do this:

```sh
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub
╰─$ git clone https://github.com/DigitalGrinnell/Map-MODS-to-MASTER
Cloning into 'Map-MODS-to-MASTER'...
remote: Enumerating objects: 597, done.
remote: Counting objects: 100% (597/597), done.
remote: Compressing objects: 100% (528/528), done.
remote: Total 597 (delta 49), reused 587 (delta 42), pack-reused 0
Receiving objects: 100% (597/597), 5.07 MiB | 8.50 MiB/s, done.
Resolving deltas: 100% (49/49), done.
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub
╰─$ ll
total 32
drwxr-xr-x  21 mcfatem  GRIN\Domain Users   672B Oct 12  2021 Digital-Grinnell.github.io
drwxr-xr-x  12 mcfatem  GRIN\Domain Users   384B Oct 13 10:20 Map-MODS-to-MASTER
...
```

### Houston, We Have a Problem

So, the `main.py` script in the `Map-MODS-to-MASTER` project does a lot of heavy lifting, and it's got lots of problems as a result.  Namely:

  1) It's very tightly tied to a couple of `//storage` directories that I currently can't access,
  2) It's meant to process a list of collections with very specific locations, not a single list of .xml documents, and
  3) It was written using _PyCharm_ which I hardly use anymore because it promotes bad Python habits.

### Houston, We Have a Solution

Fortunately, the `process_collection` function inside `main.py` has all that we need.  So, I'm going to make a local copy of the project on MA10713 at `~/GitHub/migrate-MODS-xml` and keep just the parts of `process_collection` that I need.  It's also worth noting that I plan to do this using _VSCode_ instead of _PyCharm_ and I'll follow [Proper Python](https://blog.summittdweller.com/posts/2022/09/proper-python/) guidance too.

## migrate-MODS-xml

See the new project's [README.md](https://github.com/Digital-Grinnell/migrate-MODS-xml/blob/main/README.md) file for details.

## Running the Script

After some necessary modifications the script was easy to run.  From start to finish the process involved the command line sequence listed below.

  - Copied the MODS `.xml` directory and files from `~/migration-test` to the new project like so:

```sh
╭─mcfatem@MAC02FK0XXQ05Q ~
╰─$ cp -fr migration-test ~/GitHub/migrate-MODS-xml/.
```

  - Changed working directory to the project and activated the Python virtual environment there:

```sh
╭─mcfatem@MAC02FK0XXQ05Q ~
╰─$ cd ~/GitHub/migrate-MODS-xml
╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/migrate-MODS-xml
╰─$ source .venv/bin/activate
```

  - Changed the working directory to the new copy of the `migration-test` directory and ran the script there:

```
(.venv) ╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/migrate-MODS-xml/migration-test
╰─$ python3 ../main.py
```

## Outcomes

After the first run of the script the `migration-test` directory looked like this:

```sh
(.venv) ╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/migrate-MODS-xml/migration-test ‹main›
╰─$ ll
total 312
-rw-r--r--  1 mcfatem  1278142703    16K Oct 17 13:02 collection.log
-rw-r--r--  1 mcfatem  1278142703   3.6K Oct 17 13:02 grinnell_10001_MODS.log
-rw-r--r--  1 mcfatem  1278142703   270B Oct 17 13:02 grinnell_10001_MODS.remainder
-rw-r--r--  1 mcfatem  1278142703   3.3K Oct 17 12:48 grinnell_10001_MODS.xml
-rw-r--r--  1 mcfatem  1278142703   3.3K Oct 17 13:02 grinnell_1000_MODS.log
-rw-r--r--  1 mcfatem  1278142703   125B Oct 17 13:02 grinnell_1000_MODS.remainder
-rw-r--r--  1 mcfatem  1278142703   2.9K Oct 17 12:48 grinnell_1000_MODS.xml
-rw-r--r--  1 mcfatem  1278142703   3.0K Oct 17 13:02 grinnell_13273_MODS.log
-rw-r--r--  1 mcfatem  1278142703   225B Oct 17 13:02 grinnell_13273_MODS.remainder
-rw-r--r--  1 mcfatem  1278142703   3.6K Oct 17 12:48 grinnell_13273_MODS.xml
-rw-r--r--  1 mcfatem  1278142703   3.4K Oct 17 13:02 grinnell_16934_MODS.log
-rw-r--r--  1 mcfatem  1278142703   495B Oct 17 13:02 grinnell_16934_MODS.remainder
-rw-r--r--  1 mcfatem  1278142703   3.0K Oct 17 12:48 grinnell_16934_MODS.xml
-rw-r--r--  1 mcfatem  1278142703   4.2K Oct 17 13:02 grinnell_17289_MODS.log
-rw-r--r--  1 mcfatem  1278142703   970B Oct 17 13:02 grinnell_17289_MODS.remainder
-rw-r--r--  1 mcfatem  1278142703   2.1K Oct 17 12:48 grinnell_17289_MODS.xml
-rw-r--r--  1 mcfatem  1278142703   3.5K Oct 17 13:02 grinnell_19423_MODS.log
-rw-r--r--  1 mcfatem  1278142703   594B Oct 17 13:02 grinnell_19423_MODS.remainder
-rw-r--r--  1 mcfatem  1278142703   3.3K Oct 17 12:48 grinnell_19423_MODS.xml
-rw-r--r--  1 mcfatem  1278142703   3.2K Oct 17 13:02 grinnell_23345_MODS.log
-rw-r--r--  1 mcfatem  1278142703   190B Oct 17 13:02 grinnell_23345_MODS.remainder
-rw-r--r--  1 mcfatem  1278142703   3.5K Oct 17 12:48 grinnell_23345_MODS.xml
-rw-r--r--  1 mcfatem  1278142703   2.3K Oct 17 13:02 grinnell_23517_MODS.log
-rw-r--r--  1 mcfatem  1278142703    37B Oct 17 13:02 grinnell_23517_MODS.remainder
-rw-r--r--  1 mcfatem  1278142703   2.0K Oct 17 12:48 grinnell_23517_MODS.xml
-rw-r--r--  1 mcfatem  1278142703   4.8K Oct 17 13:02 grinnell_5593_MODS.log
-rw-r--r--  1 mcfatem  1278142703   314B Oct 17 13:02 grinnell_5593_MODS.remainder
-rw-r--r--  1 mcfatem  1278142703   5.2K Oct 17 12:48 grinnell_5593_MODS.xml
-rw-r--r--  1 mcfatem  1278142703    13K Oct 17 13:02 mods.csv
```

Note that there's an overall `collection.log` file and the all-important `mods.csv` file which is what we came here for.  Also, each object has an original `.xml` export file, a new `.log` file, and a `.remainder` file which lists those elements of the corresponding `.xml` that were NOT copied into `mods.csv`.

The `mods.csv` file was to be shared with others who will assist with future migration efforts so I've copied it to a new shared folder on network storage at `//storage/library/all-staff/DG-migration-test`.  I made the copy using `Finder` on MA10713 where that folder was mounted using a `Connect to Server...` specification of `smb://storage/library/allstaff`.  

That's all for now.  Soon I'll drop copies of the corresponding `OBJ` datastreams in the same directory and continue this document with additional migration test details.
