---
title: "Export Rootstalk OBJs from Digital.Grinnell"
publishdate: 2022-01-24
draft: false
tags:
  - Rootstalk
  - islandora_datastream_exporter
  - export
---

Today's endeavor... begin the process of moving hundreds of _Rootstalk_ digital objects out of _Digital.Grinnell_ to _Azure_ storage.

## Digital.Grinnell Objects

Over the last couple of years I have deposited some 477 digital objects, mostly JPEG images and PDFs, into _Digital.Grinnell_ so they could be "served" up for [_Rootstalk_](https://rootstalk.grinnell.edu).  I did this because at the time _Digital.Grinnell's_ FEDORA repository was available and relatively easy to use.  Unfortunately, _DG_ isn't as reliable or responsive as it once was since its FEDORA is due to be retired in a year or two.  Also, the objects had to be made available to the public so they are "visible" to _Rootstalk_, but that also makes them discoverable by the public, even though they are essentially out-of-context in _DG_.

## First Step - Download All the Objects

This would seem like a simple thing, download a bunch of digital objects from a public repo; easy, right?  It's simple enough for a few objects, but doing this for 400+ objects via the public web interface would require a awful lot of clicking and could take a week or more!

### Islandora Datastream Exporter to the Rescue

At the onset of the COVID-19 pandemic in 2020 I managed to install and successfully implement the [Islandora Datastream Exporter](https://github.com/Islandora-Labs/islandora_datastream_exporter) module and corresponding `drush` commands. So, I choose to revisit it again for this effort.

Looking back at my notes from 2020, specifically [Exporting, Editing & Replacing MODS Datastreams: Updated Technical Details](/posts/115-exporting-editing-replacing-mods-datastreams-updated-technical-details/), I found guidance that helped a great deal.  Based on that guidance I crafted a _SPARQL_ query text file named `query.txt` and parked a copy of it in the `/var/www/html/sites/default/files` directory of the _Apache_ container on node _DGDocker1_.  

#### The Query

The contents of `query.txt` was:

```
SELECT ?pid
FROM <#ri>
WHERE {
  ?pid <fedora-rels-ext:isMemberOfCollection> <info:fedora/grinnell:rootstalk>
}
OFFSET %offset%
```

I copied that file from `DGDocker1:/home/islandora/query.txt` into the _Apache_ container using:

```
docker cp /home/islandora/query.txt isle-apache-dg:/var/www/html/sites/default/files/query.txt
```

#### Invoked via Drush

To engage this query I executed the following _drush_ command from within the _Apache_ container's `/var/www/html/sites/default` directory:

```
root@7611e19c4663:/var/www/html/sites/default# drush -u 1 islandora_datastream_export --export_target=/tmp --dsid=OBJ --query=/var/www/html/sites/default/files/query.txt --query_type=islandora_datastream_exporter_ri_query
```

#### Results

The abridged output of the command looked like this:

```
Processing results 1 to 10 [ok]
Datastream exported succeeded for grinnell:28575. [success]
Datastream export failed for grinnell:28471. The object does not contain the OBJ datastream. [error]
Datastream export failed for grinnell:28464. The object does not contain the OBJ datastream. [error]
Datastream export failed for grinnell:28401. The object does not contain the OBJ datastream. [error]
Datastream export failed for grinnell:28287. The object does not contain the OBJ datastream. [error]
Datastream exported succeeded for grinnell:29595. [success]
Datastream exported succeeded for grinnell:29561. [success]
Datastream exported succeeded for grinnell:29548. [success]
Datastream exported succeeded for grinnell:29641. [success]
Datastream exported succeeded for grinnell:29647. [success]
Processing results 11 to 20 [ok]
...
```

The entire operation took about 5 minutes and ultimately produced a series of files in the _Apache_ container's `/tmp` directory with names of the form:  `grinnell_<PID>_OBJ.<extension>`.  In this format `<PID>` is the numeric portion of the object's PID, and `<extension>` indicates the object type, such as `jpg`, `pdf`, `mp3` and so on.

The complete list of `385` exported files is:

```
-rw-r--r--.  1 islandora islandora  189529191 Jan 24 14:14 grinnell_28047_OBJ.pdf
-rw-r--r--.  1 islandora islandora   53042574 Jan 24 14:13 grinnell_28048_OBJ.pdf
-rw-r--r--.  1 islandora islandora     168264 Jan 24 14:13 grinnell_28269_OBJ.jpg
-rw-r--r--.  1 islandora islandora     402055 Jan 24 14:14 grinnell_28270_OBJ.jpg
-rw-r--r--.  1 islandora islandora      40413 Jan 24 14:14 grinnell_28271_OBJ.jpg
-rw-r--r--.  1 islandora islandora     182145 Jan 24 14:13 grinnell_28272_OBJ.jpg
-rw-r--r--.  1 islandora islandora    6415449 Jan 24 14:13 grinnell_28273_OBJ.mp3
-rw-r--r--.  1 islandora islandora    9727484 Jan 24 14:14 grinnell_28279_OBJ.pdf
-rw-r--r--.  1 islandora islandora   12126841 Jan 24 14:13 grinnell_28280_OBJ.pdf
-rw-r--r--.  1 islandora islandora   32999945 Jan 24 14:14 grinnell_28281_OBJ.pdf
-rw-r--r--.  1 islandora islandora   60368718 Jan 24 14:14 grinnell_28282_OBJ.pdf
-rw-r--r--.  1 islandora islandora  165232161 Jan 24 14:14 grinnell_28283_OBJ.pdf
-rw-r--r--.  1 islandora islandora   45447390 Jan 24 14:14 grinnell_28284_OBJ.pdf
-rw-r--r--.  1 islandora islandora   79899993 Jan 24 14:14 grinnell_28285_OBJ.pdf
-rw-r--r--.  1 islandora islandora  189529191 Jan 24 14:14 grinnell_28286_OBJ.pdf
-rw-r--r--.  1 islandora islandora     265445 Jan 24 14:14 grinnell_28479_OBJ.pdf
-rw-r--r--.  1 islandora islandora    2011631 Jan 24 14:13 grinnell_28480_OBJ.pdf
-rw-r--r--.  1 islandora islandora    1459883 Jan 24 14:13 grinnell_28481_OBJ.pdf
-rw-r--r--.  1 islandora islandora     361093 Jan 24 14:14 grinnell_28482_OBJ.pdf
-rw-r--r--.  1 islandora islandora     569211 Jan 24 14:14 grinnell_28483_OBJ.pdf
-rw-r--r--.  1 islandora islandora     345109 Jan 24 14:14 grinnell_28484_OBJ.pdf
-rw-r--r--.  1 islandora islandora     553469 Jan 24 14:14 grinnell_28485_OBJ.pdf
-rw-r--r--.  1 islandora islandora    1123278 Jan 24 14:13 grinnell_28486_OBJ.pdf
-rw-r--r--.  1 islandora islandora     745100 Jan 24 14:13 grinnell_28487_OBJ.pdf
-rw-r--r--.  1 islandora islandora     599550 Jan 24 14:14 grinnell_28488_OBJ.pdf
-rw-r--r--.  1 islandora islandora    1118135 Jan 24 14:13 grinnell_28489_OBJ.pdf
-rw-r--r--.  1 islandora islandora     784343 Jan 24 14:13 grinnell_28490_OBJ.pdf
-rw-r--r--.  1 islandora islandora    1200440 Jan 24 14:13 grinnell_28491_OBJ.pdf
-rw-r--r--.  1 islandora islandora   58333365 Jan 24 14:13 grinnell_28492_OBJ.pdf
-rw-r--r--.  1 islandora islandora     989470 Jan 24 14:13 grinnell_28493_OBJ.pdf
-rw-r--r--.  1 islandora islandora    1218880 Jan 24 14:13 grinnell_28494_OBJ.pdf
-rw-r--r--.  1 islandora islandora     556383 Jan 24 14:13 grinnell_28495_OBJ.pdf
-rw-r--r--.  1 islandora islandora    2139710 Jan 24 14:13 grinnell_28496_OBJ.pdf
-rw-r--r--.  1 islandora islandora     905503 Jan 24 14:14 grinnell_28497_OBJ.pdf
-rw-r--r--.  1 islandora islandora  288485490 Jan 24 14:14 grinnell_28498_OBJ.pdf
-rw-r--r--.  1 islandora islandora    1032147 Jan 24 14:14 grinnell_28499_OBJ.pdf
-rw-r--r--.  1 islandora islandora    1233748 Jan 24 14:14 grinnell_28500_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1278758 Jan 24 14:14 grinnell_28501_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1537364 Jan 24 14:14 grinnell_28502_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3992245 Jan 24 14:14 grinnell_28503_OBJ.jpg
-rw-r--r--.  1 islandora islandora   29239041 Jan 24 14:14 grinnell_28504_OBJ.jpg
-rw-r--r--.  1 islandora islandora    4692821 Jan 24 14:13 grinnell_28505_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2807762 Jan 24 14:14 grinnell_28506_OBJ.jpg
-rw-r--r--.  1 islandora islandora    4175998 Jan 24 14:13 grinnell_28507_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1235389 Jan 24 14:14 grinnell_28508_OBJ.jpg
-rw-r--r--.  1 islandora islandora      60089 Jan 24 14:14 grinnell_28509_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3890455 Jan 24 14:14 grinnell_28510_OBJ.jpg
-rw-r--r--.  1 islandora islandora     155792 Jan 24 14:14 grinnell_28511_OBJ.jpg
-rw-r--r--.  1 islandora islandora    4066227 Jan 24 14:13 grinnell_28512_OBJ.jpg
-rw-r--r--.  1 islandora islandora     747320 Jan 24 14:13 grinnell_28513_OBJ.jpg
-rw-r--r--.  1 islandora islandora     863793 Jan 24 14:14 grinnell_28514_OBJ.jpg
-rw-r--r--.  1 islandora islandora     219187 Jan 24 14:14 grinnell_28515_OBJ.jpg
-rw-r--r--.  1 islandora islandora     173334 Jan 24 14:14 grinnell_28516_OBJ.jpg
-rw-r--r--.  1 islandora islandora    5864773 Jan 24 14:14 grinnell_28517_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3694400 Jan 24 14:14 grinnell_28518_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1055157 Jan 24 14:14 grinnell_28519_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3564515 Jan 24 14:13 grinnell_28520_OBJ.jpg
-rw-r--r--.  1 islandora islandora    5873511 Jan 24 14:14 grinnell_28521_OBJ.jpg
-rw-r--r--.  1 islandora islandora    5252623 Jan 24 14:14 grinnell_28522_OBJ.jpg
-rw-r--r--.  1 islandora islandora    5403727 Jan 24 14:14 grinnell_28523_OBJ.jpg
-rw-r--r--.  1 islandora islandora    8419857 Jan 24 14:14 grinnell_28524_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2940094 Jan 24 14:13 grinnell_28525_OBJ.jpg
-rw-r--r--.  1 islandora islandora    4066325 Jan 24 14:14 grinnell_28526_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1626294 Jan 24 14:13 grinnell_28527_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1899558 Jan 24 14:14 grinnell_28528_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3688802 Jan 24 14:13 grinnell_28529_OBJ.jpg
-rw-r--r--.  1 islandora islandora     224078 Jan 24 14:14 grinnell_28530_OBJ.jpg
-rw-r--r--.  1 islandora islandora    4771307 Jan 24 14:14 grinnell_28531_OBJ.jpg
-rw-r--r--.  1 islandora islandora    5428927 Jan 24 14:13 grinnell_28532_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1475134 Jan 24 14:14 grinnell_28533_OBJ.jpg
-rw-r--r--.  1 islandora islandora     691223 Jan 24 14:14 grinnell_28534_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1060982 Jan 24 14:14 grinnell_28535_OBJ.jpg
-rw-r--r--.  1 islandora islandora     985012 Jan 24 14:13 grinnell_28536_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2917311 Jan 24 14:13 grinnell_28537_OBJ.jpg
-rw-r--r--.  1 islandora islandora   10698112 Jan 24 14:14 grinnell_28538_OBJ.jpg
-rw-r--r--.  1 islandora islandora     214384 Jan 24 14:14 grinnell_28539_OBJ.jpg
-rw-r--r--.  1 islandora islandora     413505 Jan 24 14:13 grinnell_28540_OBJ.jpg
-rw-r--r--.  1 islandora islandora     261332 Jan 24 14:14 grinnell_28541_OBJ.jpg
-rw-r--r--.  1 islandora islandora     247717 Jan 24 14:14 grinnell_28542_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3004933 Jan 24 14:14 grinnell_28543_OBJ.jpg
-rw-r--r--.  1 islandora islandora     264530 Jan 24 14:14 grinnell_28544_OBJ.jpg
-rw-r--r--.  1 islandora islandora     224951 Jan 24 14:14 grinnell_28545_OBJ.jpg
-rw-r--r--.  1 islandora islandora     813840 Jan 24 14:13 grinnell_28546_OBJ.jpg
-rw-r--r--.  1 islandora islandora     879137 Jan 24 14:13 grinnell_28547_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1428387 Jan 24 14:14 grinnell_28548_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1263554 Jan 24 14:13 grinnell_28549_OBJ.jpg
-rw-r--r--.  1 islandora islandora     631142 Jan 24 14:14 grinnell_28550_OBJ.jpg
-rw-r--r--.  1 islandora islandora    5551881 Jan 24 14:14 grinnell_28551_OBJ.jpg
-rw-r--r--.  1 islandora islandora    7622250 Jan 24 14:14 grinnell_28552_OBJ.jpg
-rw-r--r--.  1 islandora islandora    4990577 Jan 24 14:14 grinnell_28553_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2783439 Jan 24 14:14 grinnell_28554_OBJ.jpg
-rw-r--r--.  1 islandora islandora     283291 Jan 24 14:14 grinnell_28555_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1181684 Jan 24 14:14 grinnell_28556_OBJ.jpg
-rw-r--r--.  1 islandora islandora   12989497 Jan 24 14:14 grinnell_28557_OBJ.jpg
-rw-r--r--.  1 islandora islandora    7109537 Jan 24 14:13 grinnell_28558_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1560014 Jan 24 14:14 grinnell_28559_OBJ.jpg
-rw-r--r--.  1 islandora islandora    4765653 Jan 24 14:13 grinnell_28560_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2471008 Jan 24 14:14 grinnell_28561_OBJ.jpg
-rw-r--r--.  1 islandora islandora     272052 Jan 24 14:14 grinnell_28562_OBJ.jpg
-rw-r--r--.  1 islandora islandora     112147 Jan 24 14:14 grinnell_28563_OBJ.jpg
-rw-r--r--.  1 islandora islandora    5280648 Jan 24 14:14 grinnell_28564_OBJ.jpg
-rw-r--r--.  1 islandora islandora     877880 Jan 24 14:14 grinnell_28565_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1342770 Jan 24 14:14 grinnell_28566_OBJ.jpg
-rw-r--r--.  1 islandora islandora     723041 Jan 24 14:13 grinnell_28567_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1187536 Jan 24 14:14 grinnell_28568_OBJ.jpg
-rw-r--r--.  1 islandora islandora    4678584 Jan 24 14:13 grinnell_28569_OBJ.jpg
-rw-r--r--.  1 islandora islandora     511099 Jan 24 14:14 grinnell_28570_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3998823 Jan 24 14:14 grinnell_28571_OBJ.jpg
-rw-r--r--.  1 islandora islandora    4741153 Jan 24 14:14 grinnell_28572_OBJ.jpg
-rw-r--r--.  1 islandora islandora   11276920 Jan 24 14:13 grinnell_28573_OBJ.jpg
-rw-r--r--.  1 islandora islandora     219601 Jan 24 14:14 grinnell_28574_OBJ.jpg
-rw-r--r--.  1 islandora islandora     233057 Jan 24 14:13 grinnell_28575_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2596685 Jan 24 14:14 grinnell_28576_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1088314 Jan 24 14:13 grinnell_28577_OBJ.jpg
-rw-r--r--.  1 islandora islandora     960350 Jan 24 14:13 grinnell_28578_OBJ.jpg
-rw-r--r--.  1 islandora islandora     145333 Jan 24 14:14 grinnell_28579_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1665649 Jan 24 14:14 grinnell_28580_OBJ.jpg
-rw-r--r--.  1 islandora islandora     127494 Jan 24 14:14 grinnell_28581_OBJ.jpg
-rw-r--r--.  1 islandora islandora     967060 Jan 24 14:13 grinnell_28582_OBJ.jpg
-rw-r--r--.  1 islandora islandora    6212429 Jan 24 14:14 grinnell_28583_OBJ.jpg
-rw-r--r--.  1 islandora islandora      65834 Jan 24 14:13 grinnell_28584_OBJ.jpg
-rw-r--r--.  1 islandora islandora     562790 Jan 24 14:14 grinnell_28585_OBJ.jpg
-rw-r--r--.  1 islandora islandora     210500 Jan 24 14:14 grinnell_28586_OBJ.jpg
-rw-r--r--.  1 islandora islandora     121443 Jan 24 14:13 grinnell_28587_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3281372 Jan 24 14:14 grinnell_28588_OBJ.jpg
-rw-r--r--.  1 islandora islandora     262220 Jan 24 14:13 grinnell_28589_OBJ.jpg
-rw-r--r--.  1 islandora islandora    6153646 Jan 24 14:14 grinnell_28590_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1284628 Jan 24 14:14 grinnell_28591_OBJ.jpg
-rw-r--r--.  1 islandora islandora   14118040 Jan 24 14:14 grinnell_28592_OBJ.jpg
-rw-r--r--.  1 islandora islandora      70560 Jan 24 14:14 grinnell_28593_OBJ.jpg
-rw-r--r--.  1 islandora islandora     484276 Jan 24 14:13 grinnell_28594_OBJ.jpg
-rw-r--r--.  1 islandora islandora     428055 Jan 24 14:14 grinnell_28595_OBJ.jpg
-rw-r--r--.  1 islandora islandora    8888853 Jan 24 14:14 grinnell_28596_OBJ.jpg
-rw-r--r--.  1 islandora islandora     854220 Jan 24 14:14 grinnell_28597_OBJ.jpg
-rw-r--r--.  1 islandora islandora    5521699 Jan 24 14:14 grinnell_28598_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1197383 Jan 24 14:14 grinnell_28599_OBJ.jpg
-rw-r--r--.  1 islandora islandora    9394607 Jan 24 14:13 grinnell_28600_OBJ.jpg
-rw-r--r--.  1 islandora islandora    5395750 Jan 24 14:14 grinnell_28601_OBJ.jpg
-rw-r--r--.  1 islandora islandora    5220523 Jan 24 14:14 grinnell_28602_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3540877 Jan 24 14:14 grinnell_28603_OBJ.jpg
-rw-r--r--.  1 islandora islandora     579768 Jan 24 14:13 grinnell_28604_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2896806 Jan 24 14:13 grinnell_28605_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3050759 Jan 24 14:14 grinnell_28606_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2554044 Jan 24 14:14 grinnell_28607_OBJ.jpg
-rw-r--r--.  1 islandora islandora     556946 Jan 24 14:14 grinnell_28608_OBJ.jpg
-rw-r--r--.  1 islandora islandora      24781 Jan 24 14:14 grinnell_28609_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1398411 Jan 24 14:13 grinnell_28610_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3974308 Jan 24 14:13 grinnell_28611_OBJ.jpg
-rw-r--r--.  1 islandora islandora   57152190 Jan 24 14:14 grinnell_28743_OBJ.mp4
-rw-r--r--.  1 islandora islandora  215027175 Jan 24 14:13 grinnell_28744_OBJ.mp4
-rw-r--r--.  1 islandora islandora    3644620 Jan 24 14:13 grinnell_28771_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2927416 Jan 24 14:14 grinnell_28772_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2356352 Jan 24 14:14 grinnell_28773_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1723094 Jan 24 14:14 grinnell_28774_OBJ.jpg
-rw-r--r--.  1 islandora islandora   57152190 Jan 24 14:13 grinnell_29432_OBJ.mp4
-rw-r--r--.  1 islandora islandora   36176455 Jan 24 14:13 grinnell_29539_OBJ.pdf
-rw-r--r--.  1 islandora islandora    1038414 Jan 24 14:14 grinnell_29540_OBJ.png
-rw-r--r--.  1 islandora islandora      58008 Jan 24 14:13 grinnell_29541_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1342770 Jan 24 14:14 grinnell_29542_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1776219 Jan 24 14:13 grinnell_29543_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1276257 Jan 24 14:14 grinnell_29544_OBJ.jpg
-rw-r--r--.  1 islandora islandora     660354 Jan 24 14:14 grinnell_29546_OBJ.jpg
-rw-r--r--.  1 islandora islandora   29363953 Jan 24 14:14 grinnell_29547_OBJ.mp3
-rw-r--r--.  1 islandora islandora    1106625 Jan 24 14:13 grinnell_29548_OBJ.jpg
-rw-r--r--.  1 islandora islandora      53385 Jan 24 14:13 grinnell_29549_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2221876 Jan 24 14:13 grinnell_29550_OBJ.jpg
-rw-r--r--.  1 islandora islandora    5654154 Jan 24 14:13 grinnell_29551_OBJ.png
-rw-r--r--.  1 islandora islandora    4480841 Jan 24 14:14 grinnell_29552_OBJ.png
-rw-r--r--.  1 islandora islandora     446463 Jan 24 14:13 grinnell_29553_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1458312 Jan 24 14:13 grinnell_29554_OBJ.jpg
-rw-r--r--.  1 islandora islandora      18413 Jan 24 14:13 grinnell_29556_OBJ.jpg
-rw-r--r--.  1 islandora islandora      44960 Jan 24 14:14 grinnell_29557_OBJ.png
-rw-r--r--.  1 islandora islandora     176080 Jan 24 14:13 grinnell_29558_OBJ.jpg
-rw-r--r--.  1 islandora islandora      95087 Jan 24 14:14 grinnell_29559_OBJ.png
-rw-r--r--.  1 islandora islandora     293734 Jan 24 14:13 grinnell_29560_OBJ.jpg
-rw-r--r--.  1 islandora islandora      77891 Jan 24 14:13 grinnell_29561_OBJ.jpg
-rw-r--r--.  1 islandora islandora     145603 Jan 24 14:14 grinnell_29562_OBJ.jpg
-rw-r--r--.  1 islandora islandora      60765 Jan 24 14:13 grinnell_29563_OBJ.png
-rw-r--r--.  1 islandora islandora    1304503 Jan 24 14:14 grinnell_29564_OBJ.png
-rw-r--r--.  1 islandora islandora     496411 Jan 24 14:14 grinnell_29565_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2680272 Jan 24 14:14 grinnell_29566_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3347257 Jan 24 14:13 grinnell_29567_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1233120 Jan 24 14:14 grinnell_29568_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2832162 Jan 24 14:13 grinnell_29569_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3632645 Jan 24 14:14 grinnell_29570_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3483326 Jan 24 14:14 grinnell_29571_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3667752 Jan 24 14:13 grinnell_29572_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2628051 Jan 24 14:14 grinnell_29573_OBJ.jpg
-rw-r--r--.  1 islandora islandora     183546 Jan 24 14:14 grinnell_29574_OBJ.jpg
-rw-r--r--.  1 islandora islandora      39872 Jan 24 14:13 grinnell_29575_OBJ.jpg
-rw-r--r--.  1 islandora islandora     115714 Jan 24 14:14 grinnell_29576_OBJ.jpg
-rw-r--r--.  1 islandora islandora     170528 Jan 24 14:14 grinnell_29577_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1471118 Jan 24 14:14 grinnell_29578_OBJ.jpg
-rw-r--r--.  1 islandora islandora     685359 Jan 24 14:14 grinnell_29579_OBJ.jpg
-rw-r--r--.  1 islandora islandora    5536862 Jan 24 14:14 grinnell_29580_OBJ.png
-rw-r--r--.  1 islandora islandora    2484265 Jan 24 14:14 grinnell_29581_OBJ.jpg
-rw-r--r--.  1 islandora islandora     814620 Jan 24 14:14 grinnell_29582_OBJ.jpg
-rw-r--r--.  1 islandora islandora     158536 Jan 24 14:14 grinnell_29583_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3606487 Jan 24 14:13 grinnell_29584_OBJ.mp3
-rw-r--r--.  1 islandora islandora     713351 Jan 24 14:13 grinnell_29585_OBJ.png
-rw-r--r--.  1 islandora islandora     701049 Jan 24 14:14 grinnell_29586_OBJ.png
-rw-r--r--.  1 islandora islandora    1240492 Jan 24 14:14 grinnell_29587_OBJ.png
-rw-r--r--.  1 islandora islandora    2416253 Jan 24 14:13 grinnell_29588_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1112190 Jan 24 14:14 grinnell_29589_OBJ.png
-rw-r--r--.  1 islandora islandora      27081 Jan 24 14:13 grinnell_29590_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1119347 Jan 24 14:14 grinnell_29591_OBJ.png
-rw-r--r--.  1 islandora islandora     186698 Jan 24 14:14 grinnell_29592_OBJ.jpg
-rw-r--r--.  1 islandora islandora      10037 Jan 24 14:14 grinnell_29593_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1765488 Jan 24 14:14 grinnell_29594_OBJ.jpg
-rw-r--r--.  1 islandora islandora     495776 Jan 24 14:13 grinnell_29595_OBJ.jpg
-rw-r--r--.  1 islandora islandora     729579 Jan 24 14:14 grinnell_29596_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1098258 Jan 24 14:14 grinnell_29597_OBJ.jpg
-rw-r--r--.  1 islandora islandora     501682 Jan 24 14:14 grinnell_29599_OBJ.jpg
-rw-r--r--.  1 islandora islandora     946809 Jan 24 14:14 grinnell_29600_OBJ.jpg
-rw-r--r--.  1 islandora islandora     200609 Jan 24 14:14 grinnell_29601_OBJ.jpg
-rw-r--r--.  1 islandora islandora     495197 Jan 24 14:14 grinnell_29602_OBJ.jpg
-rw-r--r--.  1 islandora islandora     941181 Jan 24 14:14 grinnell_29603_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1021954 Jan 24 14:14 grinnell_29604_OBJ.mp3
-rw-r--r--.  1 islandora islandora     198719 Jan 24 14:14 grinnell_29605_OBJ.jpg
-rw-r--r--.  1 islandora islandora     739537 Jan 24 14:13 grinnell_29606_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1992991 Jan 24 14:13 grinnell_29612_OBJ.jpg
-rw-r--r--.  1 islandora islandora     696587 Jan 24 14:14 grinnell_29613_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1840034 Jan 24 14:14 grinnell_29614_OBJ.jpg
-rw-r--r--.  1 islandora islandora     622656 Jan 24 14:14 grinnell_29615_OBJ.jpg
-rw-r--r--.  1 islandora islandora   17886716 Jan 24 14:13 grinnell_29616_OBJ.jpg
-rw-r--r--.  1 islandora islandora    5122519 Jan 24 14:14 grinnell_29617_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2017009 Jan 24 14:14 grinnell_29618_OBJ.jpg
-rw-r--r--.  1 islandora islandora    4204300 Jan 24 14:13 grinnell_29619_OBJ.jpg
-rw-r--r--.  1 islandora islandora     577832 Jan 24 14:14 grinnell_29620_OBJ.jpg
-rw-r--r--.  1 islandora islandora     937652 Jan 24 14:14 grinnell_29621_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2396914 Jan 24 14:14 grinnell_29622_OBJ.jpg
-rw-r--r--.  1 islandora islandora      23052 Jan 24 14:14 grinnell_29623_OBJ.jpg
-rw-r--r--.  1 islandora islandora    4917737 Jan 24 14:14 grinnell_29624_OBJ.jpg
-rw-r--r--.  1 islandora islandora     782889 Jan 24 14:14 grinnell_29625_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1671519 Jan 24 14:14 grinnell_29627_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3706466 Jan 24 14:14 grinnell_29628_OBJ.jpg
-rw-r--r--.  1 islandora islandora     412724 Jan 24 14:13 grinnell_29629_OBJ.jpg
-rw-r--r--.  1 islandora islandora  323358816 Jan 24 14:13 grinnell_29632_OBJ.mp4
-rw-r--r--.  1 islandora islandora   33359673 Jan 24 14:14 grinnell_29633_OBJ.mp4
-rw-r--r--.  1 islandora islandora    8838186 Jan 24 14:13 grinnell_29638_OBJ.jpg
-rw-r--r--.  1 islandora islandora     217621 Jan 24 14:14 grinnell_29639_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2184474 Jan 24 14:14 grinnell_29640_OBJ.jpg
-rw-r--r--.  1 islandora islandora    7919140 Jan 24 14:13 grinnell_29641_OBJ.jpg
-rw-r--r--.  1 islandora islandora     173325 Jan 24 14:14 grinnell_29642_OBJ.jpg
-rw-r--r--.  1 islandora islandora     559959 Jan 24 14:13 grinnell_29643_OBJ.jpg
-rw-r--r--.  1 islandora islandora     169325 Jan 24 14:13 grinnell_29644_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1683146 Jan 24 14:14 grinnell_29645_OBJ.png
-rw-r--r--.  1 islandora islandora    3436024 Jan 24 14:14 grinnell_29646_OBJ.jpg
-rw-r--r--.  1 islandora islandora     851840 Jan 24 14:13 grinnell_29647_OBJ.jpg
-rw-r--r--.  1 islandora islandora   13633772 Jan 24 14:14 grinnell_29648_OBJ.jpg
-rw-r--r--.  1 islandora islandora   14439157 Jan 24 14:14 grinnell_29649_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2417870 Jan 24 14:14 grinnell_29650_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1814392 Jan 24 14:13 grinnell_29651_OBJ.jpg
-rw-r--r--.  1 islandora islandora     454503 Jan 24 14:14 grinnell_29652_OBJ.jpg
-rw-r--r--.  1 islandora islandora   22508355 Jan 24 14:14 grinnell_29653_OBJ.jpg
-rw-r--r--.  1 islandora islandora   24676426 Jan 24 14:14 grinnell_29654_OBJ.jpg
-rw-r--r--.  1 islandora islandora   20417653 Jan 24 14:14 grinnell_29655_OBJ.jpg
-rw-r--r--.  1 islandora islandora    6694759 Jan 24 14:14 grinnell_29656_OBJ.jpg
-rw-r--r--.  1 islandora islandora    6573281 Jan 24 14:14 grinnell_29657_OBJ.jpg
-rw-r--r--.  1 islandora islandora    7518511 Jan 24 14:14 grinnell_29658_OBJ.jpg
-rw-r--r--.  1 islandora islandora    8350328 Jan 24 14:13 grinnell_29659_OBJ.jpg
-rw-r--r--.  1 islandora islandora    7322834 Jan 24 14:14 grinnell_29660_OBJ.jpg
-rw-r--r--.  1 islandora islandora    7207438 Jan 24 14:13 grinnell_29661_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1100220 Jan 24 14:13 grinnell_29662_OBJ.jpg
-rw-r--r--.  1 islandora islandora     508157 Jan 24 14:14 grinnell_29663_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2071947 Jan 24 14:14 grinnell_29664_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2759519 Jan 24 14:14 grinnell_29665_OBJ.jpg
-rw-r--r--.  1 islandora islandora     363051 Jan 24 14:14 grinnell_29666_OBJ.jpg
-rw-r--r--.  1 islandora islandora     912831 Jan 24 14:14 grinnell_29667_OBJ.png
-rw-r--r--.  1 islandora islandora     471499 Jan 24 14:14 grinnell_29668_OBJ.png
-rw-r--r--.  1 islandora islandora     665821 Jan 24 14:14 grinnell_29669_OBJ.png
-rw-r--r--.  1 islandora islandora     135748 Jan 24 14:14 grinnell_29670_OBJ.jpg
-rw-r--r--.  1 islandora islandora     164252 Jan 24 14:14 grinnell_29672_OBJ.jpg
-rw-r--r--.  1 islandora islandora    4399381 Jan 24 14:14 grinnell_29673_OBJ.jpg
-rw-r--r--.  1 islandora islandora    4337360 Jan 24 14:14 grinnell_29674_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1585421 Jan 24 14:14 grinnell_29675_OBJ.png
-rw-r--r--.  1 islandora islandora     575147 Jan 24 14:14 grinnell_29676_OBJ.jpg
-rw-r--r--.  1 islandora islandora     431125 Jan 24 14:14 grinnell_29677_OBJ.jpg
-rw-r--r--.  1 islandora islandora     258614 Jan 24 14:14 grinnell_29678_OBJ.jpg
-rw-r--r--.  1 islandora islandora     154479 Jan 24 14:14 grinnell_29679_OBJ.jpg
-rw-r--r--.  1 islandora islandora     314038 Jan 24 14:14 grinnell_29680_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1665650 Jan 24 14:14 grinnell_29681_OBJ.jpg
-rw-r--r--.  1 islandora islandora     659540 Jan 24 14:14 grinnell_29682_OBJ.jpg
-rw-r--r--.  1 islandora islandora     862621 Jan 24 14:14 grinnell_29694_OBJ.jpg
-rw-r--r--.  1 islandora islandora   10973119 Jan 24 14:14 grinnell_29706_OBJ.jpg
-rw-r--r--.  1 islandora islandora     265414 Jan 24 14:13 grinnell_29707_OBJ.jpg
-rw-r--r--.  1 islandora islandora    9387200 Jan 24 14:13 grinnell_29708_OBJ.jpg
-rw-r--r--.  1 islandora islandora    4705731 Jan 24 14:14 grinnell_29709_OBJ.png
-rw-r--r--.  1 islandora islandora    2778937 Jan 24 14:14 grinnell_29710_OBJ.jpg
-rw-r--r--.  1 islandora islandora     791528 Jan 24 14:14 grinnell_29711_OBJ.jpg
-rw-r--r--.  1 islandora islandora     547133 Jan 24 14:14 grinnell_29712_OBJ.jpg
-rw-r--r--.  1 islandora islandora     757581 Jan 24 14:14 grinnell_29713_OBJ.jpg
-rw-r--r--.  1 islandora islandora     253847 Jan 24 14:14 grinnell_29714_OBJ.jpg
-rw-r--r--.  1 islandora islandora     312735 Jan 24 14:14 grinnell_29715_OBJ.jpg
-rw-r--r--.  1 islandora islandora     733347 Jan 24 14:14 grinnell_29716_OBJ.png
-rw-r--r--.  1 islandora islandora     538614 Jan 24 14:14 grinnell_29717_OBJ.png
-rw-r--r--.  1 islandora islandora    4322467 Jan 24 14:14 grinnell_29891_OBJ.jpg
-rw-r--r--.  1 islandora islandora    4503431 Jan 24 14:14 grinnell_29892_OBJ.jpg
-rw-r--r--.  1 islandora islandora    4565245 Jan 24 14:14 grinnell_29893_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2553837 Jan 24 14:13 grinnell_29894_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2989592 Jan 24 14:13 grinnell_29895_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1083196 Jan 24 14:14 grinnell_29896_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1342770 Jan 24 14:14 grinnell_29897_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3135291 Jan 24 14:14 grinnell_29898_OBJ.pdf
-rw-r--r--.  1 islandora islandora   32332233 Jan 24 14:14 grinnell_29899_OBJ.pdf
-rw-r--r--.  1 islandora islandora    1655225 Jan 24 14:14 grinnell_29900_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2610725 Jan 24 14:13 grinnell_29901_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2627201 Jan 24 14:14 grinnell_29902_OBJ.jpg
-rw-r--r--.  1 islandora islandora      82443 Jan 24 14:14 grinnell_29903_OBJ.jpg
-rw-r--r--.  1 islandora islandora     448352 Jan 24 14:14 grinnell_29904_OBJ.pdf
-rw-r--r--.  1 islandora islandora     356461 Jan 24 14:13 grinnell_29905_OBJ.jpg
-rw-r--r--.  1 islandora islandora     197721 Jan 24 14:14 grinnell_29906_OBJ.jpg
-rw-r--r--.  1 islandora islandora     213512 Jan 24 14:14 grinnell_29907_OBJ.jpg
-rw-r--r--.  1 islandora islandora     232116 Jan 24 14:14 grinnell_29908_OBJ.jpg
-rw-r--r--.  1 islandora islandora     199208 Jan 24 14:14 grinnell_29909_OBJ.jpg
-rw-r--r--.  1 islandora islandora     257597 Jan 24 14:14 grinnell_29910_OBJ.jpg
-rw-r--r--.  1 islandora islandora     475470 Jan 24 14:14 grinnell_29911_OBJ.jpg
-rw-r--r--.  1 islandora islandora     572720 Jan 24 14:14 grinnell_29912_OBJ.pdf
-rw-r--r--.  1 islandora islandora    2094880 Jan 24 14:14 grinnell_29913_OBJ.jpg
-rw-r--r--.  1 islandora islandora     175535 Jan 24 14:14 grinnell_29914_OBJ.jpg
-rw-r--r--.  1 islandora islandora     225942 Jan 24 14:14 grinnell_29915_OBJ.jpg
-rw-r--r--.  1 islandora islandora     523212 Jan 24 14:14 grinnell_29916_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1144732 Jan 24 14:13 grinnell_29917_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1144371 Jan 24 14:14 grinnell_29918_OBJ.pdf
-rw-r--r--.  1 islandora islandora     103825 Jan 24 14:13 grinnell_29919_OBJ.jpg
-rw-r--r--.  1 islandora islandora      98025 Jan 24 14:14 grinnell_29920_OBJ.jpg
-rw-r--r--.  1 islandora islandora     327135 Jan 24 14:14 grinnell_29921_OBJ.jpg
-rw-r--r--.  1 islandora islandora     312303 Jan 24 14:14 grinnell_29922_OBJ.jpg
-rw-r--r--.  1 islandora islandora     304871 Jan 24 14:13 grinnell_29923_OBJ.jpg
-rw-r--r--.  1 islandora islandora    5174838 Jan 24 14:13 grinnell_29924_OBJ.jpg
-rw-r--r--.  1 islandora islandora     476889 Jan 24 14:14 grinnell_29925_OBJ.pdf
-rw-r--r--.  1 islandora islandora     259385 Jan 24 14:14 grinnell_29926_OBJ.pdf
-rw-r--r--.  1 islandora islandora     485865 Jan 24 14:13 grinnell_29927_OBJ.jpg
-rw-r--r--.  1 islandora islandora    5923442 Jan 24 14:13 grinnell_29928_OBJ.jpg
-rw-r--r--.  1 islandora islandora    3748237 Jan 24 14:14 grinnell_29929_OBJ.jpg
-rw-r--r--.  1 islandora islandora     129223 Jan 24 14:14 grinnell_29930_OBJ.jpg
-rw-r--r--.  1 islandora islandora     974964 Jan 24 14:14 grinnell_29931_OBJ.pdf
-rw-r--r--.  1 islandora islandora     200122 Jan 24 14:14 grinnell_29932_OBJ.jpg
-rw-r--r--.  1 islandora islandora    2941639 Jan 24 14:14 grinnell_29933_OBJ.jpg
-rw-r--r--.  1 islandora islandora     762691 Jan 24 14:14 grinnell_29934_OBJ.pdf
-rw-r--r--.  1 islandora islandora     660118 Jan 24 14:14 grinnell_29935_OBJ.jpg
-rw-r--r--.  1 islandora islandora     113295 Jan 24 14:14 grinnell_29936_OBJ.jpg
-rw-r--r--.  1 islandora islandora     313891 Jan 24 14:14 grinnell_29937_OBJ.jpg
-rw-r--r--.  1 islandora islandora     312598 Jan 24 14:14 grinnell_29938_OBJ.jpg
-rw-r--r--.  1 islandora islandora     235405 Jan 24 14:13 grinnell_29939_OBJ.jpg
-rw-r--r--.  1 islandora islandora     226884 Jan 24 14:13 grinnell_29940_OBJ.jpg
-rw-r--r--.  1 islandora islandora     197907 Jan 24 14:14 grinnell_29941_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1080193 Jan 24 14:14 grinnell_29942_OBJ.pdf
-rw-r--r--.  1 islandora islandora     383448 Jan 24 14:14 grinnell_29943_OBJ.pdf
-rw-r--r--.  1 islandora islandora   20893613 Jan 24 14:13 grinnell_29944_OBJ.jpg
-rw-r--r--.  1 islandora islandora   19886578 Jan 24 14:14 grinnell_29945_OBJ.jpg
-rw-r--r--.  1 islandora islandora   20512936 Jan 24 14:14 grinnell_29946_OBJ.jpg
-rw-r--r--.  1 islandora islandora     500146 Jan 24 14:14 grinnell_29947_OBJ.jpg
-rw-r--r--.  1 islandora islandora   23448497 Jan 24 14:14 grinnell_29948_OBJ.jpg
-rw-r--r--.  1 islandora islandora   23288954 Jan 24 14:14 grinnell_29949_OBJ.jpg
-rw-r--r--.  1 islandora islandora   13714481 Jan 24 14:14 grinnell_29950_OBJ.jpg
-rw-r--r--.  1 islandora islandora   16059786 Jan 24 14:14 grinnell_29951_OBJ.jpg
-rw-r--r--.  1 islandora islandora   21244099 Jan 24 14:14 grinnell_29952_OBJ.jpg
-rw-r--r--.  1 islandora islandora   27823934 Jan 24 14:14 grinnell_29953_OBJ.jpg
-rw-r--r--.  1 islandora islandora   15356115 Jan 24 14:13 grinnell_29954_OBJ.jpg
-rw-r--r--.  1 islandora islandora   17418047 Jan 24 14:14 grinnell_29955_OBJ.jpg
-rw-r--r--.  1 islandora islandora   16084117 Jan 24 14:14 grinnell_29956_OBJ.jpg
-rw-r--r--.  1 islandora islandora   14767707 Jan 24 14:13 grinnell_29957_OBJ.jpg
-rw-r--r--.  1 islandora islandora   23264211 Jan 24 14:14 grinnell_29958_OBJ.pdf
-rw-r--r--.  1 islandora islandora     573091 Jan 24 14:13 grinnell_29959_OBJ.pdf
-rw-r--r--.  1 islandora islandora     664199 Jan 24 14:14 grinnell_29960_OBJ.png
-rw-r--r--.  1 islandora islandora      16564 Jan 24 14:14 grinnell_29961_OBJ.jpg
-rw-r--r--.  1 islandora islandora      50323 Jan 24 14:14 grinnell_29962_OBJ.jpg
-rw-r--r--.  1 islandora islandora     154960 Jan 24 14:13 grinnell_29963_OBJ.jpg
-rw-r--r--.  1 islandora islandora      54601 Jan 24 14:14 grinnell_29964_OBJ.jpg
-rw-r--r--.  1 islandora islandora     257685 Jan 24 14:14 grinnell_29965_OBJ.jpg
-rw-r--r--.  1 islandora islandora      30762 Jan 24 14:13 grinnell_29966_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1048423 Jan 24 14:14 grinnell_29967_OBJ.pdf
-rw-r--r--.  1 islandora islandora    5685915 Jan 24 14:14 grinnell_29968_OBJ.jpg
-rw-r--r--.  1 islandora islandora    6447406 Jan 24 14:14 grinnell_29969_OBJ.jpg
-rw-r--r--.  1 islandora islandora    6300238 Jan 24 14:14 grinnell_29970_OBJ.jpg
-rw-r--r--.  1 islandora islandora     390766 Jan 24 14:14 grinnell_29971_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1863608 Jan 24 14:13 grinnell_29972_OBJ.jpg
-rw-r--r--.  1 islandora islandora     892697 Jan 24 14:14 grinnell_29973_OBJ.jpg
-rw-r--r--.  1 islandora islandora    1824278 Jan 24 14:14 grinnell_29974_OBJ.pdf
-rw-r--r--.  1 islandora islandora     166963 Jan 24 14:14 grinnell_29975_OBJ.png
-rw-r--r--.  1 islandora islandora   32394967 Jan 24 14:14 grinnell_29976_OBJ.pdf
-rw-r--r--.  1 islandora islandora     288904 Jan 24 14:14 grinnell_29990_OBJ.jpg
-rw-r--r--.  1 islandora islandora    8733861 Jan 24 14:13 grinnell_29997_OBJ.jpg
-rw-r--r--.  1 islandora islandora     132374 Jan 24 14:14 grinnell_29999_OBJ.jpg
```

The `/tmp` directory inside the _Apache_ container is purged of old files every hour, so quickly I copied them all to a safe directory on _DGDocker1_ like so:

```
[islandora@dgdocker1 ~]$ docker cp isle-apache-dg:/tmp/. /home/islandora/.
```

#### Errors

So, there were 477 _Rootstalk_ objects listed in _DG_, why did we only export 385?  The errors reported above lend a clue... many of the _Rootstalk_ objects are children of a compound object parent, and the parent object has no OBJ datastream of its own.  As a result, 92 _Rootstalk_ objects were not exported and they should not be missed.


And that's a wrap.  Until next time, stay safe and wash your hands! :smile:
