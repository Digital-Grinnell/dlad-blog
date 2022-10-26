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

## Dealing with the Children

Under normal circumstances all of the child objects belonging to a compound or book would be part of the parent's collection(s) so subsequent operations that identify objects by-collection would work on both the parent and it's children.  However, our child objects are not yet part of the new `migration-test` collection, so let's remedy that now.

The `drush` commands I used to migrate the child objects were:

```sh
drush -u 1 iduF grinnell:1001-1014 MigrateObject --share --source="grinnell:college-buildings" --replace="grinnell:migration-test"
drush -u 1 iduF grinnell:10020-10027 MigrateObject --share --source="grinnell:faculty-scholarship" --replace="grinnell:migration-test"
```

Note: The above examples show why it's always nice to keep a parent object's children together with consecutive PIDs!

### Book Pages Did NOT Migrate

Unfortunately, the first of the two commands shown in the previous section did NOT work, presumably because book pages belong ONLY to their parent book object, and not to any "collection".  So, the `MigrateObject` command won't work.  No worries, we will deal with this wrinkle near the end of this process.

## The Collection

I subsequently visited the new collection at https://isle-stage.grinnell.edu/islandora/object/grinnell:migration-test/manage where I found this summary of the results to confirm:

{{% figure title="Summary of Objects in `grinnell:migration-test`" src="/images/post-129/migration-test-collection.png" %}} 

Note that the children of `grinnell:10001` are NOT listed in this view, but I visited https://isle-stage.grinnell.edu/islandora/object/grinnell%3Amigration-test/manage/collection to confirm that they ARE a part of the new collection.

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
Processing results 1 to 10                                                  [ok]
Datastream exported succeeded for grinnell:1000.                       [success]
Datastream exported succeeded for grinnell:19423.                      [success]
Datastream exported succeeded for grinnell:17289.                      [success]
Datastream exported succeeded for grinnell:23345.                      [success]
Datastream exported succeeded for grinnell:10001.                      [success]
Datastream exported succeeded for grinnell:10020.                      [success]
Datastream exported succeeded for grinnell:5593.                       [success]
Datastream exported succeeded for grinnell:10024.                      [success]
Datastream exported succeeded for grinnell:16934.                      [success]
Datastream exported succeeded for grinnell:13273.                      [success]
Processing results 11 to 17                                                 [ok]
Datastream exported succeeded for grinnell:23517.                      [success]
Datastream exported succeeded for grinnell:10021.                      [success]
Datastream exported succeeded for grinnell:10022.                      [success]
Datastream exported succeeded for grinnell:10025.                      [success]
Datastream exported succeeded for grinnell:10023.                      [success]
Datastream exported succeeded for grinnell:10026.                      [success]
Datastream exported succeeded for grinnell:10027.                      [success]
```

So, the above results should be found in our `Apache` container's `/utility-scripts/exported-MODS/migration-test/` directory, like so...

```sh
╭─islandora@dgdockerx ~
╰─$ docker exec -it isle-apache-dgs bash
root@db16bc9ff4c3:/# cd /utility-scripts/exported-MODS/migration-test/
root@db16bc9ff4c3:/utility-scripts/exported-MODS/migration-test# ll
total 80
drwxr-xr-x. 2 root root 4096 Oct 18 14:56 ./
drwxr-xr-x. 3 root root 4096 Oct 13 14:41 ../
-rw-r--r--. 1 root root 3339 Oct 18 14:56 grinnell_10001_MODS.xml
-rw-r--r--. 1 root root 3003 Oct 18 14:56 grinnell_1000_MODS.xml
-rw-r--r--. 1 root root 3482 Oct 18 14:56 grinnell_10020_MODS.xml
-rw-r--r--. 1 root root 3475 Oct 18 14:56 grinnell_10021_MODS.xml
-rw-r--r--. 1 root root 3503 Oct 18 14:56 grinnell_10022_MODS.xml
-rw-r--r--. 1 root root 3496 Oct 18 14:56 grinnell_10023_MODS.xml
-rw-r--r--. 1 root root 3482 Oct 18 14:56 grinnell_10024_MODS.xml
-rw-r--r--. 1 root root 3483 Oct 18 14:56 grinnell_10025_MODS.xml
-rw-r--r--. 1 root root 3488 Oct 18 14:56 grinnell_10026_MODS.xml
-rw-r--r--. 1 root root 3526 Oct 18 14:56 grinnell_10027_MODS.xml
-rw-r--r--. 1 root root 3696 Oct 18 14:56 grinnell_13273_MODS.xml
-rw-r--r--. 1 root root 3099 Oct 18 14:56 grinnell_16934_MODS.xml
-rw-r--r--. 1 root root 2168 Oct 18 14:56 grinnell_17289_MODS.xml
-rw-r--r--. 1 root root 3425 Oct 18 14:56 grinnell_19423_MODS.xml
-rw-r--r--. 1 root root 3580 Oct 18 14:56 grinnell_23345_MODS.xml
-rw-r--r--. 1 root root 2047 Oct 18 14:56 grinnell_23517_MODS.xml
-rw-r--r--. 1 root root 5308 Oct 18 14:56 grinnell_5593_MODS.xml
```

Note that book pages, like `grinnell:1001` through `grinnell:1014` have no MODS records so we are not really missing anything here.

Next, lets copy the MODS `.xml` files that we have back to the `DGDockerX` host.

```sh
╭─islandora@dgdockerx ~
╰─$ mkdir migration-test
╭─islandora@dgdockerx ~
╰─$ docker cp isle-apache-dgs:/utility-scripts/exported-MODS/migration-test/. migration-test/.
╭─islandora@dgdockerx ~
╰─$ ll migration-test
total 80K
drwxrwxr-x.  2 islandora islandora 4.0K Oct 18 11:45 .
drwx------. 22 islandora islandora 4.0K Oct 18 11:46 ..
-rw-r--r--.  1 islandora islandora 3.3K Oct 18 09:56 grinnell_10001_MODS.xml
-rw-r--r--.  1 islandora islandora 3.0K Oct 18 09:56 grinnell_1000_MODS.xml
-rw-r--r--.  1 islandora islandora 3.5K Oct 18 09:56 grinnell_10020_MODS.xml
-rw-r--r--.  1 islandora islandora 3.4K Oct 18 09:56 grinnell_10021_MODS.xml
-rw-r--r--.  1 islandora islandora 3.5K Oct 18 09:56 grinnell_10022_MODS.xml
-rw-r--r--.  1 islandora islandora 3.5K Oct 18 09:56 grinnell_10023_MODS.xml
-rw-r--r--.  1 islandora islandora 3.5K Oct 18 09:56 grinnell_10024_MODS.xml
-rw-r--r--.  1 islandora islandora 3.5K Oct 18 09:56 grinnell_10025_MODS.xml
-rw-r--r--.  1 islandora islandora 3.5K Oct 18 09:56 grinnell_10026_MODS.xml
-rw-r--r--.  1 islandora islandora 3.5K Oct 18 09:56 grinnell_10027_MODS.xml
-rw-r--r--.  1 islandora islandora 3.7K Oct 18 09:56 grinnell_13273_MODS.xml
-rw-r--r--.  1 islandora islandora 3.1K Oct 18 09:56 grinnell_16934_MODS.xml
-rw-r--r--.  1 islandora islandora 2.2K Oct 18 09:56 grinnell_17289_MODS.xml
-rw-r--r--.  1 islandora islandora 3.4K Oct 18 09:56 grinnell_19423_MODS.xml
-rw-r--r--.  1 islandora islandora 3.5K Oct 18 09:56 grinnell_23345_MODS.xml
-rw-r--r--.  1 islandora islandora 2.0K Oct 18 09:56 grinnell_23517_MODS.xml
-rw-r--r--.  1 islandora islandora 5.2K Oct 18 09:56 grinnell_5593_MODS.xml
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
18 files to consider
.d..t.... ./
>f..t.... grinnell_10001_MODS.xml
        3339 100%    3.18MB/s    0:00:00 (xfer#1, to-check=16/18)
>f..t.... grinnell_1000_MODS.xml
        3003 100%    2.86MB/s    0:00:00 (xfer#2, to-check=15/18)
>f+++++++ grinnell_10020_MODS.xml
        3482 100%    1.66MB/s    0:00:00 (xfer#3, to-check=14/18)
>f+++++++ grinnell_10021_MODS.xml
        3475 100%    1.10MB/s    0:00:00 (xfer#4, to-check=13/18)
>f+++++++ grinnell_10022_MODS.xml
        3503 100%  855.22kB/s    0:00:00 (xfer#5, to-check=12/18)
>f+++++++ grinnell_10023_MODS.xml
        3496 100%  682.81kB/s    0:00:00 (xfer#6, to-check=11/18)
>f+++++++ grinnell_10024_MODS.xml
        3482 100%  566.73kB/s    0:00:00 (xfer#7, to-check=10/18)
>f+++++++ grinnell_10025_MODS.xml
        3483 100%  485.91kB/s    0:00:00 (xfer#8, to-check=9/18)
>f+++++++ grinnell_10026_MODS.xml
        3488 100%  486.61kB/s    0:00:00 (xfer#9, to-check=8/18)
>f+++++++ grinnell_10027_MODS.xml
        3526 100%  430.42kB/s    0:00:00 (xfer#10, to-check=7/18)
>f..t.... grinnell_13273_MODS.xml
        3696 100%  401.04kB/s    0:00:00 (xfer#11, to-check=6/18)
>f..t.... grinnell_16934_MODS.xml
        3099 100%  302.64kB/s    0:00:00 (xfer#12, to-check=5/18)
>f..t.... grinnell_17289_MODS.xml
        2168 100%  176.43kB/s    0:00:00 (xfer#13, to-check=4/18)
>f..t.... grinnell_19423_MODS.xml
        3425 100%  257.29kB/s    0:00:00 (xfer#14, to-check=3/18)
>f..t.... grinnell_23345_MODS.xml
        3580 100%  249.72kB/s    0:00:00 (xfer#15, to-check=2/18)
>f..t.... grinnell_23517_MODS.xml
        2047 100%  142.79kB/s    0:00:00 (xfer#16, to-check=1/18)
>f..t.... grinnell_5593_MODS.xml
        5308 100%  323.97kB/s    0:00:00 (xfer#17, to-check=0/18)

sent 678 bytes  received 29316 bytes  19996.00 bytes/sec
total size is 57600  speedup is 1.92
╭─mcfatem@MAC02FK0XXQ05Q ~/migration-test
╰─$ ll
total 144
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.3K Oct 18 09:56 grinnell_10001_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   2.9K Oct 18 09:56 grinnell_1000_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 09:56 grinnell_10020_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 09:56 grinnell_10021_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 09:56 grinnell_10022_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 09:56 grinnell_10023_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 09:56 grinnell_10024_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 09:56 grinnell_10025_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 09:56 grinnell_10026_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 09:56 grinnell_10027_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.6K Oct 18 09:56 grinnell_13273_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.0K Oct 18 09:56 grinnell_16934_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   2.1K Oct 18 09:56 grinnell_17289_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.3K Oct 18 09:56 grinnell_19423_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.5K Oct 18 09:56 grinnell_23345_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   2.0K Oct 18 09:56 grinnell_23517_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   5.2K Oct 18 09:56 grinnell_5593_MODS.xml
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
total 552
-rw-r--r--  1 mcfatem  GRIN\Domain Users    30K Oct 18 11:55 collection.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.6K Oct 18 11:55 grinnell_10001_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   270B Oct 18 11:55 grinnell_10001_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.3K Oct 18 11:54 grinnell_10001_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.3K Oct 18 11:55 grinnell_1000_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   125B Oct 18 11:55 grinnell_1000_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   2.9K Oct 18 11:54 grinnell_1000_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.3K Oct 18 11:55 grinnell_10020_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   180B Oct 18 11:55 grinnell_10020_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 11:54 grinnell_10020_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.3K Oct 18 11:55 grinnell_10021_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   180B Oct 18 11:55 grinnell_10021_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 11:54 grinnell_10021_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 11:55 grinnell_10022_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   254B Oct 18 11:55 grinnell_10022_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 11:54 grinnell_10022_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 11:55 grinnell_10023_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   247B Oct 18 11:55 grinnell_10023_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 11:54 grinnell_10023_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 11:55 grinnell_10024_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   247B Oct 18 11:55 grinnell_10024_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 11:54 grinnell_10024_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 11:55 grinnell_10025_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   247B Oct 18 11:55 grinnell_10025_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 11:54 grinnell_10025_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.3K Oct 18 11:55 grinnell_10026_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   180B Oct 18 11:55 grinnell_10026_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 11:54 grinnell_10026_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 11:55 grinnell_10027_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   259B Oct 18 11:55 grinnell_10027_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 11:54 grinnell_10027_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.0K Oct 18 11:55 grinnell_13273_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   225B Oct 18 11:55 grinnell_13273_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.6K Oct 18 11:54 grinnell_13273_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.4K Oct 18 11:55 grinnell_16934_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   495B Oct 18 11:55 grinnell_16934_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.0K Oct 18 11:54 grinnell_16934_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   4.2K Oct 18 11:55 grinnell_17289_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   970B Oct 18 11:55 grinnell_17289_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   2.1K Oct 18 11:54 grinnell_17289_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.5K Oct 18 11:55 grinnell_19423_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   594B Oct 18 11:55 grinnell_19423_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.3K Oct 18 11:54 grinnell_19423_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.2K Oct 18 11:55 grinnell_23345_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   190B Oct 18 11:55 grinnell_23345_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   3.5K Oct 18 11:54 grinnell_23345_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   2.3K Oct 18 11:55 grinnell_23517_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users    37B Oct 18 11:55 grinnell_23517_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   2.0K Oct 18 11:54 grinnell_23517_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users   4.8K Oct 18 11:55 grinnell_5593_MODS.log
-rw-r--r--  1 mcfatem  GRIN\Domain Users   314B Oct 18 11:55 grinnell_5593_MODS.remainder
-rw-r--r--  1 mcfatem  GRIN\Domain Users   5.2K Oct 18 11:54 grinnell_5593_MODS.xml
-rw-r--r--  1 mcfatem  GRIN\Domain Users    26K Oct 18 11:55 mods.csv
```

Note that there's an overall `collection.log` file and the all-important `mods.csv` file which is what we came here for.  Also, each object has an original `.xml` export file, a new `.log` file, and a `.remainder` file which lists those elements of the corresponding `.xml` that were NOT copied into `mods.csv`.

The `mods.csv` file was to be shared with others who will assist with future migration efforts so I've copied it to a new shared folder on network storage at `//storage/library/all-staff/DG-migration-test`.  I made the copy using `Finder` on MA10713 where that folder was mounted using a `Connect to Server...` specification of `smb://storage/library/allstaff`.  

## Extracting the OBJ Datastreams

This step was a piece-of-cake since I'd already done this for all of the MODS datastreams.  So, I repeated [Step 1d - Using Drush islandora_datastream_export](posts/129-creating-a-migration-collection/#step-1d---using-drush-islandora_datastream_export) changing `dsid=MODS` to `dsid=OBJ`, and `exported-MODS` to `exported-OBJ`, in the `export.sh` script.  In order to preserve `export.sh` as-is, I made a new `export-OBJ.sh` script from it on _DGDockerX_.

Having created the new script with edits specified above, I ran it producing the output you see here.

```sh
╭─islandora@dgdockerx ~
╰─$ cat export-OBJ.sh
Apache=isle-apache-dgs
Target=/utility-scripts
collection=migration-test
#
docker cp query.sparql ${Apache}:${Target}/${collection}.sparql
q=${Target}/${collection}.sparql
echo "Processing collection '${collection}'; Query is '${q}'..."
docker exec -w ${Target} ${Apache} mkdir -p exported-OBJ/${collection}
docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 islandora_datastream_export --export_target=${Target}/exported-OBJ/${collection} --query=${q} --query_type=islandora_datastream_exporter_ri_query  --dsid=OBJ

╭─islandora@dgdockerx ~
╰─$ source export-OBJ.sh
Processing collection 'migration-test'; Query is '/utility-scripts/migration-test.sparql'...
Processing results 1 to 10                                                  [ok]
Datastream export failed for grinnell:1000. The object does not          [error]
contain the OBJ datastream.
Datastream exported succeeded for grinnell:19423.                      [success]
Datastream exported succeeded for grinnell:17289.                      [success]
Datastream exported succeeded for grinnell:23345.                      [success]
Datastream export failed for grinnell:10001. The object does not         [error]
contain the OBJ datastream.
Datastream exported succeeded for grinnell:10020.                      [success]
Datastream exported succeeded for grinnell:5593.                       [success]
Datastream exported succeeded for grinnell:10024.                      [success]
Datastream exported succeeded for grinnell:16934.                      [success]
Datastream exported succeeded for grinnell:13273.                      [success]
Processing results 11 to 17                                                 [ok]
Datastream exported succeeded for grinnell:23517.                      [success]
Datastream exported succeeded for grinnell:10021.                      [success]
Datastream exported succeeded for grinnell:10022.                      [success]
Datastream exported succeeded for grinnell:10025.                      [success]
Datastream exported succeeded for grinnell:10023.                      [success]
Datastream exported succeeded for grinnell:10026.                      [success]
Datastream exported succeeded for grinnell:10027.                      [success]
```

As you can see, two of our objects, `grinnell:1000` and `grinnell:10001` had no OBJ to export; this is because the first is a "book" object and the other is a compound "parent".  Those CModel types have no OBJ's of their own, they have only child objects.  Also, you may recall that the pages of our book, `grinnell:1000` are not part of the `migration-test` collection, but they have valid `OBJ` datastreams.  So, how can we collect the OBJs of those pages?

### A New SPARQL Query

That's how... we need to modifiy our SPARQL query (currently it exists as `/home/islandora/query.sparql` on _DGDockerX_) to return children, in this case "pages", of our book object rather than children of a particular collection.  The RELS-EXT datastreams of the children we want look something like this:

```
<rdf:RDF>
<rdf:Description rdf:about="info:fedora/grinnell:1001">
<hasModel rdf:resource="info:fedora/islandora:pageCModel"/>
<isSequenceNumber rdf:datatype="http://www.w3.org/2001/XMLSchema#int">1</isSequenceNumber>
<isPageNumber rdf:datatype="http://www.w3.org/2001/XMLSchema#int">1</isPageNumber>
<isPageOf rdf:resource="info:fedora/grinnell:1000"/>
<isSection rdf:datatype="http://www.w3.org/2001/XMLSchema#int">1</isSection>
<isMemberOf rdf:resource="info:fedora/grinnell:1000"/>
<islandora:isManageableByUser>fedoraAdmin</islandora:isManageableByUser>
<islandora:isManageableByUser>System Admin</islandora:isManageableByUser>
<islandora:isManageableByRole>Administrator</islandora:isManageableByRole>
<islandora:isManageableByRole>Faulconer Admin</islandora:isManageableByRole>
<islandora:isManageableByRole>Workflow Administrator</islandora:isManageableByRole>
<islandora:isManageableByRole>administrator</islandora:isManageableByRole>
<islandora:hasLanguage>eng</islandora:hasLanguage>
</rdf:Description>
</rdf:RDF>
```

So I created a new SPARQL query as you see below and executed the new `export-OBJ.sh` script like so:

```sh
╭─islandora@dgdockerx ~ 
╰─$ cat export-OBJ.sh                                                                    1 ↵
SELECT ?pid
FROM <#ri>
WHERE {
  ?pid <fedora-rels-ext:isMemberOf> <info:fedora/grinnell:1000>
}
OFFSET %offset%

╭─islandora@dgdockerx ~ 
╰─$ source export-OBJ.sh                                                                    1 ↵
Processing collection 'migration-test'; Query is '/utility-scripts/migration-test.sparql'...
Processing results 1 to 10                                                  [ok]
Datastream exported succeeded for grinnell:1009.                       [success]
Datastream exported succeeded for grinnell:1008.                       [success]
Datastream exported succeeded for grinnell:1014.                       [success]
Datastream exported succeeded for grinnell:1012.                       [success]
Datastream exported succeeded for grinnell:1007.                       [success]
Datastream exported succeeded for grinnell:1011.                       [success]
Datastream exported succeeded for grinnell:1005.                       [success]
Datastream exported succeeded for grinnell:1013.                       [success]
Datastream exported succeeded for grinnell:1002.                       [success]
Datastream exported succeeded for grinnell:1001.                       [success]
Processing results 11 to 14                                                 [ok]
Datastream exported succeeded for grinnell:1003.                       [success]
Datastream exported succeeded for grinnell:1010.                       [success]
Datastream exported succeeded for grinnell:1006.                       [success]
Datastream exported succeeded for grinnell:1004.                       [success]
```

As before, since `/mnt/storage` isn't accessible from _DGDockerX_ I copied all of the `OBJ` datastream files from our _Apache_ container to the _DGDockerX_ host, then to my Mac workstation, MA10713.

```sh
╭─islandora@dgdockerx ~
╰─$ cd migration-test
╭─islandora@dgdockerx ~/migration-test
╰─$ docker cp isle-apache-dgs:/utility-scripts/exported-OBJ/migration-test/. .
╭─islandora@dgdockerx ~/migration-test
╰─$ ll
total 726M
drwxrwxr-x.  2 islandora islandora 4.0K Oct 18 12:40 .
drwx------. 22 islandora islandora 4.0K Oct 18 12:40 ..
-rw-r--r--.  1 islandora islandora 3.3K Oct 18 09:56 grinnell_10001_MODS.xml
-rw-r--r--.  1 islandora islandora 3.0K Oct 18 09:56 grinnell_1000_MODS.xml
-rw-r--r--.  1 islandora islandora  32M Oct 18 12:31 grinnell_1001_OBJ.tiff
-rw-r--r--.  1 islandora islandora 3.5K Oct 18 09:56 grinnell_10020_MODS.xml
-rw-r--r--.  1 islandora islandora 217K Oct 18 12:07 grinnell_10020_OBJ.pdf
-rw-r--r--.  1 islandora islandora 3.4K Oct 18 09:56 grinnell_10021_MODS.xml
-rw-r--r--.  1 islandora islandora  62K Oct 18 12:07 grinnell_10021_OBJ.pdf
-rw-r--r--.  1 islandora islandora 3.5K Oct 18 09:56 grinnell_10022_MODS.xml
-rw-r--r--.  1 islandora islandora  19M Oct 18 12:07 grinnell_10022_OBJ.bin
-rw-r--r--.  1 islandora islandora 3.5K Oct 18 09:56 grinnell_10023_MODS.xml
-rw-r--r--.  1 islandora islandora  25M Oct 18 12:07 grinnell_10023_OBJ.bin
-rw-r--r--.  1 islandora islandora 3.5K Oct 18 09:56 grinnell_10024_MODS.xml
-rw-r--r--.  1 islandora islandora  30K Oct 18 12:07 grinnell_10024_OBJ.tar
-rw-r--r--.  1 islandora islandora 3.5K Oct 18 09:56 grinnell_10025_MODS.xml
-rw-r--r--.  1 islandora islandora  11K Oct 18 12:07 grinnell_10025_OBJ.bin
-rw-r--r--.  1 islandora islandora 3.5K Oct 18 09:56 grinnell_10026_MODS.xml
-rw-r--r--.  1 islandora islandora 451K Oct 18 12:07 grinnell_10026_OBJ.pdf
-rw-r--r--.  1 islandora islandora 3.5K Oct 18 09:56 grinnell_10027_MODS.xml
-rw-r--r--.  1 islandora islandora 485K Oct 18 12:07 grinnell_10027_OBJ.ppt
-rw-r--r--.  1 islandora islandora  32M Oct 18 12:31 grinnell_1002_OBJ.tiff
-rw-r--r--.  1 islandora islandora  32M Oct 18 12:31 grinnell_1003_OBJ.tiff
-rw-r--r--.  1 islandora islandora  32M Oct 18 12:31 grinnell_1004_OBJ.tiff
-rw-r--r--.  1 islandora islandora  32M Oct 18 12:31 grinnell_1005_OBJ.tiff
-rw-r--r--.  1 islandora islandora  32M Oct 18 12:31 grinnell_1006_OBJ.tiff
-rw-r--r--.  1 islandora islandora  32M Oct 18 12:31 grinnell_1007_OBJ.tiff
-rw-r--r--.  1 islandora islandora  32M Oct 18 12:31 grinnell_1008_OBJ.tiff
-rw-r--r--.  1 islandora islandora  32M Oct 18 12:31 grinnell_1009_OBJ.tiff
-rw-r--r--.  1 islandora islandora  32M Oct 18 12:31 grinnell_1010_OBJ.tiff
-rw-r--r--.  1 islandora islandora  32M Oct 18 12:31 grinnell_1011_OBJ.tiff
-rw-r--r--.  1 islandora islandora  32M Oct 18 12:31 grinnell_1012_OBJ.tiff
-rw-r--r--.  1 islandora islandora  32M Oct 18 12:31 grinnell_1013_OBJ.tiff
-rw-r--r--.  1 islandora islandora  32M Oct 18 12:31 grinnell_1014_OBJ.tiff
-rw-r--r--.  1 islandora islandora 3.7K Oct 18 09:56 grinnell_13273_MODS.xml
-rw-r--r--.  1 islandora islandora  36M Oct 18 12:07 grinnell_13273_OBJ.mp4
-rw-r--r--.  1 islandora islandora 3.1K Oct 18 09:56 grinnell_16934_MODS.xml
-rw-r--r--.  1 islandora islandora 229K Oct 18 12:07 grinnell_16934_OBJ.jpg
-rw-r--r--.  1 islandora islandora 2.2K Oct 18 09:56 grinnell_17289_MODS.xml
-rw-r--r--.  1 islandora islandora 5.4M Oct 18 12:07 grinnell_17289_OBJ.warc
-rw-r--r--.  1 islandora islandora 3.4K Oct 18 09:56 grinnell_19423_MODS.xml
-rw-r--r--.  1 islandora islandora  16M Oct 18 12:07 grinnell_19423_OBJ.mp3
-rw-r--r--.  1 islandora islandora 3.5K Oct 18 09:56 grinnell_23345_MODS.xml
-rw-r--r--.  1 islandora islandora 1.2M Oct 18 12:07 grinnell_23345_OBJ.pdf
-rw-r--r--.  1 islandora islandora 2.0K Oct 18 09:56 grinnell_23517_MODS.xml
-rw-r--r--.  1 islandora islandora  16M Oct 18 12:07 grinnell_23517_OBJ.tiff
-rw-r--r--.  1 islandora islandora 5.2K Oct 18 09:56 grinnell_5593_MODS.xml
-rw-r--r--.  1 islandora islandora 163M Oct 18 12:07 grinnell_5593_OBJ.mp3
```

```sh
╭─mcfatem@MAC02FK0XXQ05Q ~
╰─$ cd migration-test
╭─mcfatem@MAC02FK0XXQ05Q ~/migration-test
╰─$ rsync -aruvi islandora@dgdockerx.grinnell.edu:/home/islandora/migration-test/. . --progress
receiving file list ...
47 files to consider
.d..t.... ./
>f+++++++ grinnell_1001_OBJ.tiff
    33349912 100%   18.41MB/s    0:00:01 (xfer#1, to-check=43/47)
>f+++++++ grinnell_10020_OBJ.pdf
      222174 100%  293.60kB/s    0:00:00 (xfer#2, to-check=41/47)
>f+++++++ grinnell_10021_OBJ.pdf
       62947 100%   82.85kB/s    0:00:00 (xfer#3, to-check=39/47)
>f+++++++ grinnell_10022_OBJ.bin
    19144317 100%   11.38MB/s    0:00:01 (xfer#4, to-check=37/47)
>f+++++++ grinnell_10023_OBJ.bin
    25843886 100%   14.05MB/s    0:00:01 (xfer#5, to-check=35/47)
>f+++++++ grinnell_10024_OBJ.tar
       30720 100%   39.68kB/s    0:00:00 (xfer#6, to-check=33/47)
>f+++++++ grinnell_10025_OBJ.bin
       11032 100%   14.23kB/s    0:00:00 (xfer#7, to-check=31/47)
>f+++++++ grinnell_10026_OBJ.pdf
      461189 100%  579.64kB/s    0:00:00 (xfer#8, to-check=29/47)
>f+++++++ grinnell_10027_OBJ.ppt
      496640 100%  607.01kB/s    0:00:00 (xfer#9, to-check=27/47)
>f+++++++ grinnell_1002_OBJ.tiff
    33356688 100%   13.93MB/s    0:00:02 (xfer#10, to-check=26/47)
>f+++++++ grinnell_1003_OBJ.tiff
    33349840 100%   17.93MB/s    0:00:01 (xfer#11, to-check=25/47)
>f+++++++ grinnell_1004_OBJ.tiff
    33354720 100%   14.07MB/s    0:00:02 (xfer#12, to-check=24/47)
>f+++++++ grinnell_1005_OBJ.tiff
    33350900 100%   18.11MB/s    0:00:01 (xfer#13, to-check=23/47)
>f+++++++ grinnell_1006_OBJ.tiff
    33352664 100%   14.12MB/s    0:00:02 (xfer#14, to-check=22/47)
>f+++++++ grinnell_1007_OBJ.tiff
    33353120 100%   18.26MB/s    0:00:01 (xfer#15, to-check=21/47)
>f+++++++ grinnell_1008_OBJ.tiff
    33352888 100%   14.27MB/s    0:00:02 (xfer#16, to-check=20/47)
>f+++++++ grinnell_1009_OBJ.tiff
    33353256 100%   18.54MB/s    0:00:01 (xfer#17, to-check=19/47)
>f+++++++ grinnell_1010_OBJ.tiff
    33349940 100%   14.43MB/s    0:00:02 (xfer#18, to-check=18/47)
>f+++++++ grinnell_1011_OBJ.tiff
    33351652 100%   18.68MB/s    0:00:01 (xfer#19, to-check=17/47)
>f+++++++ grinnell_1012_OBJ.tiff
    33353972 100%   14.54MB/s    0:00:02 (xfer#20, to-check=16/47)
>f+++++++ grinnell_1013_OBJ.tiff
    33352848 100%   18.91MB/s    0:00:01 (xfer#21, to-check=15/47)
>f+++++++ grinnell_1014_OBJ.tiff
    33349120 100%   14.60MB/s    0:00:02 (xfer#22, to-check=14/47)
>f+++++++ grinnell_13273_OBJ.mp4
    37367789 100%   19.45MB/s    0:00:01 (xfer#23, to-check=12/47)
>f+++++++ grinnell_16934_OBJ.jpg
      233941 100%  271.01kB/s    0:00:00 (xfer#24, to-check=10/47)
>f+++++++ grinnell_17289_OBJ.warc
     5593634 100%    4.89MB/s    0:00:01 (xfer#25, to-check=8/47)
>f+++++++ grinnell_19423_OBJ.mp3
    16448993 100%   19.13MB/s    0:00:00 (xfer#26, to-check=6/47)
>f+++++++ grinnell_23345_OBJ.pdf
     1227513 100%    1.34MB/s    0:00:00 (xfer#27, to-check=4/47)
>f+++++++ grinnell_23517_OBJ.tiff
    16394056 100%    9.75MB/s    0:00:01 (xfer#28, to-check=2/47)
>f+++++++ grinnell_5593_OBJ.mp3
   169971589 100%   19.76MB/s    0:00:08 (xfer#29, to-check=0/47)

sent 660 bytes  received 760629901 bytes  21426212.99 bytes/sec
total size is 760499540  speedup is 1.00
```

I subsequently used _Finder_ on my Mac to copy all of these files to `//storage/library/all-staff/DG-migration-test`.

## Azure Storage

Two weeks ago I wrote this... 

"Very soon I hope to have _Azure Storage Explorer_ access to some new network, actually _Azure_, shares from my MacBook.  When that happens I'll take steps to copy all of the above files to a new web-accessible home there, I hope."

Well, that hasn't happened yet so I've taken steps to create an _Azure Blog Storage_ container without the benefit of the new _ASE_ capability.  The process of copying our `migrgation-test` collection objects and metadata to _Azure_ is documented in another of my blog posts, [Managing Azure](/posts/130-managing-azure). 

## Migration Target: JSTOR

This morning I imported the `mods.csv` metadata into _Excel_ where I added two new columns, `FILE_OBJECT` and `FILE_EXTENSION`.  These columns, intended for use with [JSTOR](https://www.jstor.org/), document the name and extension of the object's content file.  

The result, `mods-JSTOR.xlsx` is stored both in _Azure_ and in `//storage/library/all-staff/DG-migration-test`.  

---

I'm sure there will be more here soon, but for now... that's a wrap.
