---
title: "Exporting, Editing & Replacing MODS Datastreams: Updated Technical Details"
publishdate: 2021-12-14
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
  - reduce-MODS-remainders
supersedes: posts/070-Exporting-Editing-Replacing-MODS-Datastreams-Technical-Details
---
<p>
{{< annotation >}}
<b>Attention:</b> On 21-May-2020 an optional, but recommended, sixth step was added to this workflow in the form of a new _Drush_ command: _islandora\_mods_post\_processing_, an addition to my previous work in [islandora_mods_via_twig](https://github.com/DigitalGrinnell/islandora_mods_via_twig). See my new post, [Islandora MODS Post Processing](/posts/075-islandora-mods-post-processing/) for complete details.
{{< /annotation >}}
</p>

<p>
{{< annotation >}}
<b>Attention:</b> In November 2021 a recommended seventh step was added to this workflow.  That addition is documented in the final section of this document.
{{< /annotation >}}
</p>

# A 7-Step Workflow

This document is follow-up, with technical details, to [Exporting, Editing & Replacing MODS Datastreams](/posts/069-exporting-editing-replacing-mods-datastreams/), post 069, in my blog.  In case you missed it, the aforementioned post was written specifically for metadata editors working on the 2020 _Grinnell College Libraries_ review of _Digital Grinnell_ MODS metadata.

Attention: This document uses a shorthand `./` in place of the frequently referenced `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/` directory.  For example, `./social-justice` is equivalent to the _Social Justice_ collection sub-directory at `//STORAGE/LIBRARY/ALLSTAFF/DG-Metadata-Review-2020-r1/social-justice`.

Briefly, the seven steps in this workflow are:

  1. Export of all `grinnell:*` _MODS_ datastreams using `drush islandora_datastream_export`.  This step, last performed on April 14, 2020, was responsible for creating all of the `grinnell_<PID>_MODS.xml` exports found in `./<collection-PID>`.

  2. Execute my _Map-MODS-to-MASTER_ _Python 3_ script on iMac _MA8660_ to create a `mods.tsv` file for each collection, along with associated `grinnell_<PID>_MODS.log` and `grinnell_<PID>_MODS.remainder` files for each object. The resultant `./<collection-PID>/mods.tsv` files are tab-seperated-value (.tsv) files, and they are **key** to this process.

  3. Edit the MODS .tsv files.  Refer [Exporting, Editing, & Replacing MODS Datastreams](/posts/069-exporting-editing-replacing-mods-datastreams/) for details and guidance.

  4. Use `drush islandora_mods_via_twig` in each ready-for-update collection to generate new .xml MODS datastream files. For a specified collection, this command will find and read the `./<collection-PID>/mods-imvt.tsv` and create one `./<collection-PID>/ready-for-datastream-replace/grinnell_<PID>_MODS.xml` file for each object.

  5. Execute the `drush islandora_datastream_replace` command once for each collection.  This command will process each `./<collection-PID>/ready-for-datastream-replace/grinnell_<PID>_MODS.xml` file and replace the corresponding object's MODS datastream with the contents of the .xml file.  The _digital_grinnell_ branch version of the `islandora_datastream_replace` command also performs an implicit update of the object's "Title", a transform of the new MODS to DC (_Dublin Core_), and a re-indexing of the new metadata in _Solr_.

  6. Execute an optional follow-up `drush` command as documented in [Islandora MODS Post Processing](/posts/075-islandora-mods-post-processing/).  This portion of the workflow will help to reduce duplication of effort for objects that are shared between two or more collections.

  7. Configure and run the `main.py` script as described in the `README.md` file at my [reduce-MODS-remainders](https://github.com/Digital-Grinnell/reduce-MODS-remainders) repository. This portion of the workflow will analyze all of the `*.remainders` files left behind by worflow _Step 2_ for objects in a given collection.

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

## Step 6 - Reduce Duplicates

As mentioned in the summary above, this is an optional but recommended follow-up `drush` command described in [Islandora MODS Post Processing](/posts/075-islandora-mods-post-processing/).  

## Step 7 - Analyze and Restore "remainder" Fields

As mentioned in the summary above, this step is designed to analyze all of the `*.remainder` files left behind by workflow _Step 2_ for objects in a given collection, and provide commands to restore legitimate elements after review.  Follow instructions found in the `README.md` file at my [reduce-MODS-remainders](https://github.com/Digital-Grinnell/reduce-MODS-remainders) repository.

And that's a wrap.  Until next time, stay safe and wash your hands! :smile:
