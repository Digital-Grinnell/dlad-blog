---
title: "Exporting, Editing, & Replacing MODS Datastreams: Technical Details"
publishdate: 2020-04-23
draft: false
tags:
  - MODS
  - Export
  - Replace
  - Twig
  - Islandora Multi-Importer
  - islandora_datastream_export
  - islandora_datastream_replace
  - islandora_mods_via_twig
  - Map-MODS-to-MASTER
  - islandora_mods_post_processing
---

> Attention: On 21-May-2020 an optional, but recommended, sixth step was added to this workflow in the form of a new _Drush_ command: _islandora\_mods_post\_processing_, an addition to my previous work in [islandora_mods_via_twig](https://github.com/DigitalGrinnell/islandora_mods_via_twig). See my new post, [Islandora MODS Post Processing](/posts/075-islandora-mods-post-processing) for complete details.

# A 5-Step Workflow

This document is follow-up, with technical details, to [Exporting, Editing, & Replacing MODS Datastreams](/posts/069-exporting-editing-replacing-mods-datastreams/), post 069, in my blog.  In case you missed it, the aforementioned post was written specifically for metadata editors working on the 2020 _Grinnell College Libraries_ review of _Digital Grinnell_ MODS metadata.

Attention: This document uses a shorthand `./` in place of the frequently referenced `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/` directory.  For example, `./social-justice` is equivalent to the _Social Justice_ collection sub-directory at `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/social-justice`.

Briefly, the five steps in this workflow are:

  1. Export of all `grinnell:*` _MODS_ datastreams using `drush islandora_datastream_export`.  This step, last performed on April 14, 2020, was responsible for creating all of the `grinnell_<PID>_MODS.xml` exports found in `./<collection-PID>`.

  2. Execute my _Map-MODS-to-MASTER_ _Python 3_ script on iMac _MA8660_ to create a `mods.tsv` file for each collection, along with associated `grinnell_<PID>_MODS.log` and `grinnell_<PID>_MODS.remainder` files for each object. The resultant `./<collection-PID>/mods.tsv` files are tab-seperated-value (.tsv) files, and they are **key** to this process.

  3. Edit the MODS .tsv files.  Refer [Exporting, Editing, & Replacing MODS Datastreams](/posts/069-exporting-editing-replacing-mods-datastreams/) for details and guidance.

  4. Use `drush islandora_mods_via_twig` in each ready-for-update collection to generate new .xml MODS datastream files. For a specified collection, this command will find and read the `./<collection-PID>/mods-imvt.tsv` and create one `./<collection-PID>/ready-for-datastream-replace/grinnell_<PID>_MODS.xml` file for each object.

  5. Execute the `drush islandora_datastream_replace` command once for each collection.  This command will process each `./<collection-PID>/ready-for-datastream-replace/grinnell_<PID>_MODS.xml` file and replace the corresponding object's MODS datastream with the contents of the .xml file.  The _digital_grinnell_ branch version of the `islandora_datastream_replace` command also performs an implicit update of the object's "Title", a transform of the new MODS to DC (_Dublin Core_), and a re-indexing of the new metadata in _Solr_.

The remainder of this document provides technical details, frequently in the form of command lines used to build and use the aforementioned tools.

## Step 1a - Installation of Drush `islandora_datastream_export` and `islandora_datastream_replace` Commands

To help implement this process efficiently and effectively I first turned to [Exporting, Editing, & Replacing MODS Datastreams](https://github.com/calhist/documentation/wiki/Exporting,-Editing,-&-Replacing-MODS-Datastreams), a workflow developed by the good folks at [The California Historical Society](https://californiahistoricalsociety.org/).  I initiated the workflow by installing two _Drush_ tools on my [local/development instance](https://dg.localdomain) of [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE) on my Mac workstation.

The command line process in my local host/workstation terminal looked like this:

```bash
Apache=isle-apache-ld
docker exec -w /var/www/html/sites/all/modules/islandora/ ${Apache} git clone https://github.com/Islandora-Labs/islandora_datastream_exporter.git --recursive
docker exec -w /var/www/html/sites/all/modules/islandora/ ${Apache} git clone https://github.com/pc37utn/islandora_datastream_replace.git --recursive
docker exec -w /var/www/html/sites/all/modules/islandora/ ${Apache} chown -R islandora:www-data *
docker exec -w /var/www/html/sites/default ${Apache} drush en islandora_datastream_exporter islandora_datastream_replace -y
docker exec -w /var/www/html/sites/default ${Apache} drush cc drush -y
```

Local tests of these commands were successful so I proceeded to install them in the production instance of _Digital Grinnell_ at _dgdocker1.grinnell.edu_. Before doing that I needed to change the definition of `Apache` to reflect the production instance of our _Apache_ container, like so `Apache=isle-apache-dg`.

### Created a Fork of _Islandora Datastream Replace_

I also chose to "fork" the _islandora_datastream_replace_ project so that I could do a little _Digital.Grinnell_ customization of it.  The fork I'm working with is [here](https:/github.com/DigitalGrinnell/islandora_datastream_replace) and my work is limited to the [digital_grinnell](https://github.com/DigitalGrinnell/islandora_datastream_replace/tree/digital_grinnell) branch of that fork.

In the [digital_grinnell](https://github.com/DigitalGrinnell/islandora_datastream_replace/tree/digital_grinnell) branch I modified the behavior of the _islandora_datastream_replace_ command so that it implicitly performs an `UpdateFromMODS` operation that lives in our [idu, or Islandora Drush Utilities](https:/github.com/DigitalGrinnell/idu) module.  The `UpdateFromMODS`, performed immediately after each datastream replace operation does the following:

  - Updates the object "Title", one of its properties, to match the new value of `/mods:mods/mods:titleInfo[not(@type)]/mods:title`.
  - Invokes the `iduF DCTransform` operation which runs the default XSLT transform of the new MODS to DC (_Dublin Core_) and creates a new "DC" datastream for the object.
  - The `iduF DCTransform` operation also concludes with an implicit `iduF IndexSolr` operation to ensure that the new object metadata is properly indexed in _Solr_.

## Step 1b - Installation of Drush `islandora_datastream_export` and `islandora_datastream_replace` Commands in Production

To install the commands in production I opened a terminal to _dgdocker1.grinnell.edu_ as user _islandora_ and executed the following commands there:

```bash
Apache=isle-apache-dg
docker exec -w /var/www/html/sites/all/modules/islandora/ ${Apache} git clone https://github.com/Islandora-Labs/islandora_datastream_exporter.git --recursive
docker exec -w /var/www/html/sites/all/modules/islandora/ ${Apache} git clone https://github.com/DigitalGrinnell/islandora_datastream_replace.git --recursive
docker exec -w /var/www/html/sites/all/modules/islandora/ ${Apache} chown -R islandora:www-data *
docker exec -w /var/www/html/sites/all/modules/islandora/islandora_datastream_replace ${Apache} git checkout -b digital_grinnell
docker exec -w /var/www/html/sites/default ${Apache} drush en islandora_datastream_exporter islandora_datastream_replace -y
docker exec -w /var/www/html/sites/default ${Apache} drush cc drush -y
```

## Step 1c - Mounting //STORAGE to DGDocker1

Attention! This step, and some that come later, will require that the network storage path `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1` be accessible to our production instance of _Digital.Grinnell_.  To make that possible I had to run this sequence on _DGDocker1_:

> docker exec -it isle-apache-dg bash
> mount -t cifs -o username=mcfatem /storage.grinnell.edu/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1 /mnt/metadata-review /mnt/metadata-review

## Step 1d - Using Drush `islandora_datastream_export`

Unfortunately, the `islandora_datastream_export` results in my local test were woefully incomplete... NONE of the child objects with a compound parent were exported.  I'm still not entirely sure why child obejcts were omitted since the query I used should have captured all objects.  In testing I did find that this seems to be a flaw in the _islandora_datastream_export_ command, and specifically in its implementation of any _Solr_ query.

Fortunately, the aforementioned command also has a _SPARQL_ query option, and after some trial-and-error I got it to work properly.  To do so I created an `export.sh` _bash_ script, shown below, and used it on _dgdocker1.grinnell.edu_ like so:

```bash
docker exec -it isle-apache-dg bash
source export.sh
```

The `export.sh` script is:

```export.sh
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
    echo Processing collection '${collection}'; Query is '${q}'...
    docker exec -w ${Target} ${Apache} mkdir -p /mnt/metadata-review/${collection}
    docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 islandora_datastream_export --export_target=/mnt/metadata-review/${collection} --query=${q} --query_type=islandora_datastream_exporter_ri_query  --dsid=MODS
done < collections.list
```

In the case of the _Digital Grinnell_ _social-justice_ collection, for example, this script produced 32 _.xml_ files, the correct number.  Each collection's set of exported _.xml_ files can be found in the collection-specific subdirectory of `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/` and all have filenames of the form: `grinnell_<PID>_MODS.xml`.  Note that objects which have no MODS datastream were not exported.

## Step 2 - _Map-MODS-to-MASTER_ _Python 3_ Script

The _Map-MODS-to-MASTER_ script was developed, in _Python 3_, on iMac _MA8660_ at `~/GitHub/Map-MODS-to-MASTER` to facilitate generation of `mods.tsv` and accompanying `.log` files for each _Digital Grinnell_ collection from the `.xml` files found in subdirectories of `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/`.

The _Map-MODS-to-MASTER_ project can be found in the _master_ branch of https://github.com/DigitalGrinnell/Map-MODS-to-MASTER. I choose to execute it using _PyCharm_ from iMac _MA8660_ since the directory holding all of the `.xml` files and folders is already mapped to `/Volumes/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1` on that iMac.  Note that this `//STORAGE` location was choosen because the `./ALLSTAFF` directory, and its subordinates, are accessible to all staff in the _Grinnell College Libraries_.

It should not be necessary to run this script ever again...NEVER.  However, if it becomes necessary to look back at this code and process, details can be found in [Map-MODS-to-MASTER](https://github.com/DigitalGrinnell/Map-MODS-to-MASTER).  Note: If it should ever become necessary to repeat the _Map-MODS-to-MASTER_ process it might be wise to look at replacing the _Python 3_ script with a new _Drush_ command, maybe `islandora_map_mods_to_master`, written in PHP and installed directly into the production instance of _Digital.Grinnell_.

## Step 3 - Editing the MODS .tsv Files

Please refer to   Refer to [Exporting, Editing, & Replacing MODS Datastreams](/posts/069-exporting-editing-replacing-mods-datastreams/), post 069 in my blog, for details and guidance.

## Step 4 - Run `drush islandora_mods_via_twig`

As each individual collection `mods-imvt.tsv` file is made ready-for-update, it will be necessary to run a `drush islandora_mods_via_twig` command to process the .tsv data.  Running `--help` with that command produces:

```
[islandora@dgdocker1 ~]$ docker exec -it isle-apache-dg bash
root@122092fe8182:/# cd /var/www/html/sites/default/
root@122092fe8182:/var/www/html/sites/default# drush -u 1 islandora_mods_via_twig --help
Generate MODS .xml files from the mods-imvt.tsv file for a specified collection.

Examples:
 drush -u 1 islandora_mods_via_twig social-justice   Process ../social-justice/mods-imvt.tsv, for example.

Arguments:
 collection             The name of the collection to be processed.  Defaults to "social-justice".

Aliases: imvt
```

So, my command sequence to run `islandora_mods_via_twig` for the "Social Justice" collection, as an example, was:

```
[islandora@dgdocker1 ~]$ docker exec -it isle-apache-dg bash
root@122092fe8182:/# cd /var/www/html/sites/default/
root@122092fe8182:/var/www/html/sites/default# drush -u 1 islandora_mods_via_twig social-justice
```

When the `islandora_mods_via_twig` command is run, it processes the corresponding `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/<collection-PID>/mods-imvt.tsv` file and creates one `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/<collection-PID>/ready-for-datastream-replace/grinnell_<PID>_MODS.xml` file for each object.

## Step 5 - Run `drush islandora_datastream_replace`

The whole point of this entire process is to get us back to this point with a set of reviewed and modified _.xml_ files in a `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/<collection-PID>/ready-for-datastream-replace/` collection-specific subdirectory so that we can replace existing object MODS datastreams with new data, and we use the `drush islandora_datastream_replace` command to do this.

Running `--help` for the aformentioned command produced this:

```
root@122092fe8182:/var/www/html/sites/default# drush -u 1 islandora_datastream_replace --help
Replaces a datastream in all objects given a file list in a directory.

Examples:
 drush -u 1 islandora_datastream_replace --source=/mnt/metadata-review/social-justice/ready-for-datastream-replace
 --dsid=MODS --namespace=grinnell

   Replacing MODS datastream for objects in --source using the digital_grinnell branch of code.

Options:
 --dsid                                    The datastream id of the datastream. Required.
 --namespace                               The namespace of the pids. Required.
 --source                                  The directory to get the datastreams and pid# from. Required.

Aliases: idre
```

It's worth noting that this command looks for any files named _*MODS*_ in whatever *ABSOLUTE* directory is named with the `--source` parameter.  The command shown below was executed inside the _Apache_ container, _isle-apache-dg_, on node _DGDocker1_, in order to process _Digital Grinnell_'s _social-justice_ collection.

```
root@122092fe8182:drush -u 1 islandora_datastream_replace --source=/mnt/metadata-review/social-justice/ready-for-datastream-replace --dsid=MODS --namespace=grinnell
```

The same command could have been executed directly from node _DGDocker1_ like so:

```
docker exec isle-apache-dg drush -u 1 -w /var/www/html/sites/default drush -u 1 islandora_datastream_replace --source=mnt/metadata-review/social-justice/ready-for-datastream-replace --dsid=MODS --namespace=grinnell
```

<!--

## Part 6 - The _mods-via-twig_ Script in _lando-d8_

My original intent was to use the _Islandora Multi-Importer_, or _IMI_, to import our edited `<collection>.csv` files back into _Digital Grinnell_; however, I found that even using _IMI_'s "replace" option with no intended _RELS-EXT_ changes did damage to the object relationships in our repository.  To leverage the robust _Twig_ template found in our [Digital_Grinnell_MODS_Master](https://docs.google.com/spreadsheets/d/1G_pQgKJwtgBZYDAHcMC7dCTOnwexIYGHjarHPFKaAOg/edit#gid=791993009) worksheet I elected to create a new _Drush_ command called `mods-via-twig`, or `mvt`, to mimic what _IMI_ does to create new _MODS_ datastreams.

To implement this as quickly as possible I found it easiest to work in a local _Drupal 8_ environment, since _Drupal 8_ has native _Twig_ libraries already at its disposal.  I also chose to use _Lando_ to facilitate the local development since it is quick and easy.

A chronicle documenting the creation of _mods-via-twig_ can be found in [this gist](https://gist.github.com/McFateM/291c29ce411493801e2b72a8d2ce9e6a).

## Part 7 - Copying Modified `<collection>.csv` Files to _lando-d8_

A small set of `rsync` and associated commands that I use to copy files to and from the _mvt_ process can be found in [this gist](https://gist.github.com/McFateM/2f0b7a725cafeb767da59581d2b58852).

## Part 8 - Executing _mods-via-twig_, the _drush mvt_ Command

Another [gist](https://gist.github.com/McFateM/6da051df1da4b3613194e34c41b5d65b) provides guidance for running the _drush mods-via-twig_ command in the _lando-d8_ environment.

## Part 9 - Copying New _.xml_ Files for Import Back Into _Digital Grinnell_

Like _Part 7_ above, this is also addressed in a [gist](https://gist.github.com/McFateM/2f0b7a725cafeb767da59581d2b58852).

## Part 10 - Executing _islandora\_datastream\_replace_

This needs to happen in the _isle-apache-dg_ container on the production instance of _Digital Grinnell_ at _dgdocker1.grinnell.edu:/opt/ISLE/_ and once again, the command is documented in a [gist](https://gist.github.com/McFateM/6da051df1da4b3613194e34c41b5d65b).

## Part 11 - Follow-up

Since objects in _Digital Grinnell_ display _Solr_ data, not raw _MODS_, it may be necessary to take steps to regenerate new _DC_ datastreams and perform susequent _Solr_ indexing for all modified objects.  I'm still working out the details of that portion of this process...

<!--
## Editing the MODS Metadata

I found a simple and effective process for editing the `.xml` files that were produced, using [Atom](https://atom.io). For testing purposes I made changes in a few of the objects listed above: 3246, 11569, 20575, and 25497.  These changes included removing some empty XML tags, changing student/alumni graduation class years from ` '64` notation to `, Class of 1964`, as well as eliminiation of trailing whitespace and whitespace lines.  Now I'll push them back into the repository to confirm that the workflow does indeed "work".

## Importing the Changes

My command line "test" import of all the exported objects goes like this:

```
Apache=isle-apache-ld
docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 islandora_datastream_replace --dsid=MODS --source=/var/www/private/ --namespace=grinnell
```

And the output from that command, with whitelines removed, is:

```
╭─mark@Marks-Mac-Mini ~/GitHub/dg-isle ‹master*›
╰─$ docker exec -w /var/www/html/sites/default/ isle-apache-ld drush -u 1 islandora_datastream_replace --dsid=MODS --source=/var/www/private/ --namespace=grinnell
dsid=MODS  filename=
 dsid is not in filename!
dsid=MODS  filename=.
 dsid is not in filename!
dsid=MODS  filename=
 dsid is not in filename!
 file = grinnell_11569_MODS
pidnum=11569
Datastream replacement succeeded for grinnell:11569.                   [success]
 file = grinnell_20575_MODS
pidnum=20575
 file = grinnell_25482_MODS
pidnum=25482
Datastream replacement succeeded for grinnell:20575.                   [success]
 file = grinnell_25483_MODS
pidnum=25483
Datastream replacement succeeded for grinnell:25482.                   [success]
Datastream replacement succeeded for grinnell:25483.                   [success]
 file = grinnell_25484_MODS
pidnum=25484
Datastream replacement succeeded for grinnell:25484.                   [success]
 file = grinnell_25493_MODS
pidnum=25493
Datastream replacement succeeded for grinnell:25493.                   [success]
 file = grinnell_25494_MODS
pidnum=25494
Datastream replacement succeeded for grinnell:25494.                   [success]
 file = grinnell_25495_MODS
pidnum=25495
Datastream replacement succeeded for grinnell:25495.                   [success]
 file = grinnell_25497_MODS
pidnum=25497
Datastream replacement succeeded for grinnell:25497.                   [success]
 file = grinnell_25510_MODS
pidnum=25510
Datastream replacement succeeded for grinnell:25510.                   [success]
 file = grinnell_3246_MODS
pidnum=3246
Datastream replacement succeeded for grinnell:3246.                    [success]
```

Note that some replacment operations clearly took longer than others, and in some cases they report back in the "wrong order", but it looks like all the legitimate object MODS records got updated.  It's also worth noting that after import each processed `.xml` file name is changed to `.xml.used` so that the file is not processed again unless its name is modified beforehand.  Now to check up on one or two of them...

## Test Results

Clearly, the changes I made to the four MODS `.xml` files are present in the repository.  However, they are NOT reflected in the objects' MODS display, presumably because _Digital.Grinnell_ uses a _Solr_ display of MODS data, and _Solr_ has not been re-indexed.

So, I elected to validate and enable an old feature of my [IDU - Islandora Drush Utilities](https://github.com/DigitalGrinnell/idu) module, the "DCTransform" command. Coupling "DCTransform" with the previously validated "SelfTransform" command and the "--reorder" option appears clean things up as expected.

```
docker exec -w /var/www/html/sites/default/ isle-apache-ld drush cc all
```

```
Apache=isle-apache-ld
docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 iduF grinnell:25497 DCTransform
docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 iduF grinnell:25497 SelfTransform --reorder
docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 iduF grinnell:3246 DCTransform
docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 iduF grinnell:3246 SelfTransform --reorder
docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 iduF grinnell:11569 DCTransform
docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 iduF grinnell:11569 SelfTransform --reorder
docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 iduF grinnell:20575 DCTransform
docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 iduF grinnell:20575 SelfTransform --reorder
docker exec -w /var/www/html/sites/default/ isle-apache-ld drush cc all
```

# Woot!

It works. However, it's worth noting that changes made to objects' `title` field were NOT reflected in the object titles, presumably because the title becomes a "property" of the object itself, held apart from either the MODS or DC datastreams.

Next step, repeat the installation in production and export ALL of the objects in preparation for review and editing.

# Exporting By Collection

After the successful tests docmented above, I repeated this process for _Digital.Grinnell_ production on host _DGDocker1_.  The export worked nicely; however, the process produces so many _MODS_ .xml files (9,084 is the count) that I can't easily work with them, there are too many to "glob" using a single wildcard spec.  So, I'm going to try to formulate an export that isolates objects into their primary collections.  A test of this process on my local/dev instance of _ISLE_ looks likes this:

```
Collection=jimmy-ley
Apache=isle-apache-ld
Target=/tmp
docker exec -w ${Target} ${Apache} mkdir -p grinnell/${Collection}
docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 islandora_datastream_export --export_target=${Target}/grinnell/${Collection} --query=RELS_EXT_isMemberOfCollection_uri_mlt:\"info:fedora/grinnell:${Collection}\" --dsid=MODS
```

## In Production

The same export in production on _DGDocker1_ looks like this:

```
Collection=jimmy-ley
Apache=isle-apache-dg
Target=/utility-scripts
docker exec -w ${Target} ${Apache} mkdir -p grinnell/${Collection}
docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 islandora_datastream_export --export_target=${Target}/grinnell/${Collection} --query=RELS_EXT_isMemberOfCollection_uri_mlt:\"info:fedora/grinnell:${Collection}\" --dsid=MODS
```

This command set produced a total of 210 MODS .xml files in the _Apache_ container's new `/utility-scripts/grinnell/jimmy-ley` directory.  All that's required to repeat it for other collections in the `grinnell:` namespace is to repeat the command set changing the value of `Collection=` as needed.

There is a list of ALL _Digital.Grinnell_ collections in [this public gist](https://gist.github.com/McFateM/5bd7e5b0fa5d2928b2799d039a4c0fab), making it possible to loop the aforementioned command set like so:

```
Apache=isle-apache-dg
Target=/utility-scripts
wget https://gist.github.com/McFateM/5bd7e5b0fa5d2928b2799d039a4c0fab/raw/collections.list
while read collection
do
    q=RELS_EXT_isMemberOfCollection_uri_mlt:*${collection}
    echo Processing collection '${collection}'; Query is '${q}'...
    docker exec -w ${Target} ${Apache} mkdir -p exported-MODS/${collection}
    docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 islandora_datastream_export --export_target=${Target}/exported-MODS/${Collection} --query=${q} --dsid=MODS
done < collections.list
```

# Next Steps

I'll open another post so that I can document the process of collecting and processing all the dumped _MODS_ records presumably using [OpenRefine](https://openrefine.org/).

# rsync - Fetch All mods.csv

With the Grinnell College _//STORAGE_ server mounted to iMac _MA8660_ you can run the following `rsync` command to fetch all of the latest _mods.csv_ files and directories after they have been created using the `Map-MODS-to-MASTER` Python 3 script on _MA8660_...

```
╭─mark@Marks-Mac-Mini ~/GitHub/lando-d8/sites/default/files/collections ‹8.6.x*›
╰─$ rsync -aruvi --exclude '*.xml' --exclude '*.log' --exclude '*.remainder' --progress markmcfate@132.161.216.145:/Volumes/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/. ~/GitHub/lando-d8/sites/default/files/collections/.
```

The command alone is:

```
rsync -aruvi --exclude '*.xml' --exclude '*.log' --exclude '*.remainder' --progress markmcfate@132.161.216.145:/Volumes/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/. ~/GitHub/lando-d8/sites/default/files/collections/.
```

# rsync - Pushing New .xml Files Back for Update

Once a new set of .xml files has been generated, they need to be copied to node _DGDocker1_ so they can be imported into the _Digital Grinnell_ repository. Specifically, they should be copied to a collection-named directory at _dgdocker1.grinnell.edu:/opt/ISLE/persistent/html/sites/default/files/DG-Metadata-Review-2020-r1/Ready-to-Process/_.  The _social-justice_ collection, for example, would occupy _dgdocker1.grinnell.edu:/opt/ISLE/persistent/html/sites/default/files/DG-Metadata-Review-2020-r1/Ready-to-Process/social-justice_.

An example for the _social-justice_ collection is shown here:

```
╭─mark@Marks-Mac-Mini ~/GitHub/lando-d8/sites/default/files/collections ‹8.6.x*›
╰─$ collection=social-justice
╭─mark@Marks-Mac-Mini ~/GitHub/lando-d8/sites/default/files/collections ‹8.6.x*›
╰─$ rsync -aruvi --progress ~/GitHub/lando-d8/sites/default/files/collections/${collection}/. islandora@dgdocker1.grinnell.edu:/opt/ISLE/persistent/html/sites/default/files/DG-Metadata-Review-2020-r1/Ready-to-Process/${collection}/.
```

You must define the _collection_ variable before running the _rsync_ command and both commands are:

```
collection=
rsync -aruvi --progress ~/GitHub/lando-d8/sites/default/files/collections/${collection}/. islandora@dgdocker1.grinnell.edu:/opt/ISLE/persistent/html/sites/default/files/DG-Metadata-Review-2020-r1/Ready-to-Process/${collection}/.
```

# Importing the New .xml Using Drush


--->

<!--     processes the aforementioned _mods-via-twig_ command in my _mods-via-twig_ local platform to generate updated `grinnell_<PID>_MODS.xml` files on a collection-by-collection basis.
9. Copying via `rsync` of all generated `grinnell_<PID>_MODS.xml` files back to _Digital Grinnell_ at _dgdocker1.grinnell.edu:/opt/ISLE/_.
10. Execution of _islandora\_datastream\_replace_ in the _isle-apache-dg_ container on the production instance of _Digital Grinnell_ at _dgdocker1.grinnell.edu:/opt/ISLE/_.
11. Follow-up to reindex modified objects in _Solr_ and generate new _DC_ (_Dublin Core_) datastreams.

Note that parts 5, 7, 8, 9, and 10 must be repeated, but parts 1-4 and part 6 were performed only once.

   1. Installation of _Drush_ modules _islandora\_datastream\_export_ and _islandora\_datastream\_replace_ in the _isle-apache-dg_ container on the production instance of _Digital Grinnell_ at _dgdocker1.grinnell.edu:/opt/ISLE/_.
   2. Execution of the _islandora\_datastream\_export_ command inside the aforementioned _isle-apache-dg_ container to generate individual `grinnell_<PID>_MODS.xml` exports for all _Digital Grinnell_ objects that have a _MODS_ datastream.
   3. Copying of exported `grinnell_<PID>_MODS.xml` files to shared _//STORAGE_ space to make them accessible on iMac _MA8660_.
   4. Creation and execution of the _Map-MODS-to-MASTER_ _Python 3_ script on iMac _MA8660_ to create a `<collection>.csv` and accompanying `.log` and `.remainder` files for each _Digital Grinnell_ collection.
   5. Editing `<collection>.csv` files found in subdirectories of `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1` to conform with documented metadata practices.
   6. Creation of the _Drupal 8_ local _Lando_-based _mods-via-twig_ platform and the new _mods-via-twig_ _Drush_ command on my MacBook Air _MA7053_.
   7. Copying via `rsync` of all modified `<collection>.csv` files from `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1` to my local _mods-via-twig_ platform.
   8. Execution of the aforementioned _mods-via-twig_ command in my _mods-via-twig_ local platform to generate updated `grinnell_<PID>_MODS.xml` files on a collection-by-collection basis.
   9. Copying via `rsync` of all generated `grinnell_<PID>_MODS.xml` files back to _Digital Grinnell_ at _dgdocker1.grinnell.edu:/opt/ISLE/_.
  10. Execution of _islandora\_datastream\_replace_ in the _isle-apache-dg_ container on the production instance of _Digital Grinnell_ at _dgdocker1.grinnell.edu:/opt/ISLE/_.
  11. Follow-up to reindex modified objects in _Solr_ and generate new _DC_ (_Dublin Core_) datastreams.

Note that parts 5, 7, 8, 9, and 10 must be repeated, but parts 1-4 and part 6 were performed only once.

## Part 1 - Installing _islandora\_datastream..._ Modules

To help implement this process efficiently and effectively I'm first turning to "[Exporting, Editing, & Replacing MODS Datastreams](https://github.com/calhist/documentation/wiki/Exporting,-Editing,-&-Replacing-MODS-Datastreams)", a workflow developed by the good folks at [The California Historical Society](https://californiahistoricalsociety.org/).  I'll initiate the workflow with installation of two _Drush_ tools on my [local/development instance](https://dg.localdomain) of [ISLE](https://github.com/Islandora-Collaboration-Group/ISLE) on my Mac workstation.

The command line process in my local host/workstation terminal looks like this:

```
Apache=isle-apache-ld
docker exec -w /var/www/html/sites/all/modules/islandora/ ${Apache} git clone https://github.com/Islandora-Labs/islandora_datastream_exporter.git --recursive
docker exec -w /var/www/html/sites/all/modules/islandora/ ${Apache} git clone https://github.com/pc37utn/islandora_datastream_replace.git --recursive
docker exec -w /var/www/html/sites/all/modules/islandora/ ${Apache} chown -R islandora:www-data *
docker exec -w /var/www/html/sites/default ${Apache} drush en islandora_datastream_exporter islandora_datastream_replace -y
docker exec -w /var/www/html/sites/default ${Apache} drush cc drush -y
```

Local tests of these commands were successful so I proceeded to install them in the production instance of _Digital Grinnell_ at _dgdocker1.grinnell.edu_ and only had to change the definition of `Apache` to do so:

```
Apache=isle-apache-dg
```

## Part 2a - Execution of _islandora\_datastream\_export_ to Dump MODS Datastreams

I've elected to test the export of all of the "grinnell:" namespace objects to my _private:_ filesystem which resides on my host at `~/GitHub/dg-isle/private` and maps into my _Apache_ container as `/var/www/private`.  The commands are:

```
Apache=isle-apache-ld
docker exec -w /var/www/ ${Apache} chown -R islandora:www-data private
docker exec -w /var/www/ ${Apache} chmod 775 private
docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 islandora_datastream_export --export_target=/var/www/private --query=PID:grinnell* --dsid=MODS
```

The last command in the above set populated the _export\_target_ directory mentioned above, and the result looked like this:

```
╭─mark@Marks-Mac-Mini ~/GitHub/dg-isle/private ‹master*›
╰─$ ls -alh
total 128
drwxrwxr-x@ 14 mark  staff   448B Mar 17 15:37 .
drwxr-xr-x  30 mark  staff   960B Mar 12 19:40 ..
-rw-r--r--@  1 mark  staff   675B Mar 10 14:01 .htaccess
-rw-r--r--   1 mark  staff   2.4K Mar 17 15:48 grinnell_11569_MODS.xml
-rw-r--r--   1 mark  staff   2.5K Mar 17 15:50 grinnell_20575_MODS.xml
-rw-r--r--   1 mark  staff   7.8K Mar 17 15:38 grinnell_25482_MODS.xml
-rw-r--r--   1 mark  staff   7.4K Mar 17 15:38 grinnell_25483_MODS.xml
-rw-r--r--   1 mark  staff   7.3K Mar 17 15:38 grinnell_25484_MODS.xml
-rw-r--r--   1 mark  staff   1.3K Mar 17 15:38 grinnell_25493_MODS.xml
-rw-r--r--   1 mark  staff   1.3K Mar 17 15:38 grinnell_25494_MODS.xml
-rw-r--r--   1 mark  staff   1.1K Mar 17 15:38 grinnell_25495_MODS.xml
-rw-r--r--   1 mark  staff   1.3K Mar 17 15:38 grinnell_25497_MODS.xml
-rw-r--r--   1 mark  staff   4.8K Mar 17 15:38 grinnell_25510_MODS.xml
-rw-r--r--   1 mark  staff   2.7K Mar 17 15:48 grinnell_3246_MODS.xml
```

Note that objects, like collections in the "grinnell:" namespace, which have no MODS datastream were reported as such, and were automatically excluded from populating the _export\_target_ directory.

## Part 2b - Local Export Was Incomplete, but Corrected in Production

Unfortunately, the export results in my local test were woefully incomplete... NONE of the child objects with a compound parent were exported.  I'm still not entirely sure why child obejcts were omitted since the query I used should have captured all objects.  In testing I did find that this seems to be a flaw in the _islandora\_datastream\_export_ command, and specifically in its implementation of any _Solr_ query.

Fortunately, the aforementioned command also has a _SPARQL_ query option, and after some trial-and-error I got it to work properly.  To do so I created an `export.sh` _bash_ script, shown below, and used it on _dgdocker1.grinnell.edu_ like so:

```export.sh
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
    echo Processing collection '${collection}'; Query is '${q}'...
    docker exec -w ${Target} ${Apache} mkdir -p exported-MODS/${collection}
    docker exec -w /var/www/html/sites/default/ ${Apache} drush -u 1 islandora_datastream_export --export_target=${Target}/exported-MODS/${collection} --query=${q} --query_type=islandora_datastream_exporter_ri_query  --dsid=MODS
done < collections.list
```

In the case of the _Digital Grinnell_ _social-justice_ collection, for example, this script produced 32 _.xml_ files, the correct number.

## Part 3 - Copying Exported `grinnell_<PID>_MODS.xml` Files to _//STORAGE_

I used a short series of `docker cp` and `rsync` commands, executed on _dgdocker1,grinnell.edu_ and _MA8660_, to copy the `grinnell_<PID>_MODS.xml` files from `isle-apache-dg:/utility-scripts/exported-MODS/*` to `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/`.
-->

And that's a wrap.  Until next time, stay safe and wash your hands! :smile:
