---
title: Problems with dc:identifier Elements
publishdate: 2022-02-18
draft: false
tags:
  - iduF
  - OAI
  - DC
  - Dublin Core
  - identifier
  - scholar profile
  - PurgeElements
---

The addition of scholar profiles from [LASIR](https://github.com/Islandora-Collaboration-Group/LASIR), specifically the module's introduction of `/mods/identifier[@type='u1']` and `/mods/identifier[@type='u2']` fields, has caused a few problems in _Digital.Grinnell_.  Perhaps the most sinister of these... these fields are transformed into [DC or Dublin Core](https://www.dublincore.org/) elements that wreak havoc with our [OAI](https://www.openarchives.org/pmh/) export and subsequent import into [Primo VE](https://exlibrisgroup.com/products/primo-discovery-service/).

## OAI Exports

While on the subject of OAI, it's worth noting here that we can query to see the OAI that _Digital.Grinnell_ exported by visiting a URL like: `https://digital.grinnell.edu/oai2?verb=ListRecords&metadataPrefix=oai_dc&from=2022-02-15`.

Note the `from=` parameter at the end of the address.  Specifying a date here will show us what was exported on the specified date (and since that date?).

## A Possible Solution?

I've confirmed that if all `<dc:identifier>` elements containing `u1:*` or `u2:*` values are removed from an object's DC datastream, the object's behavior in _Digital.Grinnell_ is not impacted, and the objects' import to _Primo_ appear to be successful.

Identifying XML elements based on their "value" can be tricky, but I found that an xpath query like `*[contains(.,’u1:’) or contains(.,'u2:')]` works nicely.

## Fixing the MODS-to-DC Transform?

Unfortunately, this is NOT an attractive option because our XSLT is so complex.  To be honest, I think ALL XSLT is too complex!  _I hate XSLT with a passion._  The transform that _Digital.Grinnell_ uses can be found in two places on _DGDocker1_:

  - /var/www/html/sites/all/modules/islandora/dg7/xslt/mods_to_dc_grinnell.xsl, and
  - /var/www/html/sites/all/modules/islandora/islandora_xml_forms/builder/transforms/mods_to_dc_grinnell.xsl

Yes, these two files are IDENTICAL, but a necessary evil due the way that the `islandora_xml_forms` module is built.  I hate that module almost as much as I hate XSLT, maybe more.  :frowning:

The XSLT that we apply for MODS-to-DC transform reads like this:

```
<xsl:template match="mods:identifier">  
  <dc:identifier>  
    <xsl:variable name="type" select="translate(@type,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>  
    <xsl:choose>  
      <!-- 2.0: added identifier type attribute to output, if it is present-->  
      <xsl:when test="contains(.,':')">  
        <xsl:value-of select="."/>  
      </xsl:when>  
      <xsl:when test="@type">  
        <xsl:value-of select="$type"/>: <xsl:value-of select="."/>  
      </xsl:when>  
      <xsl:when test="contains ('isbn issn uri doi lccn', $type)">  
        <xsl:value-of select="$type"/>: <xsl:value-of select="."/>  
      </xsl:when>  
      <xsl:otherwise>  
        <xsl:value-of select="."/>  
      </xsl:otherwise>  
    </xsl:choose>  
  </dc:identifier>  
</xsl:template>  
```  

## A Viable Solution

What I'm going to discuss here isn't an ideal fix because every time we ingest a new object with `u1:` and/or `u2:` MODS identifiers, our transform will put them in the object's corresponding DC record.  Like I said, not ideal.  But there is a relatively easy way to remove what the transforms deposit.

For this purpose I've resurrected an old, broken `drush iduF` command.  So a command of the form `drush -u 1 iduF grinnell:31898-31902 PurgeElements --dsid=DC --xpath="*[contains(.,'u1:') or contains(.,'u2:')]" --verbose` can be used to strip the DC object(s) of its/their offending element(s).  The command is `PurgeElements` and the `--xpath` clause shown above is CRITICAL.  As with all `drush iduF` commands, the `--verbose` parameter is optional, and `--dyrRun` is also available for testing.

That command is worth highlighting one more time.

```
drush -u 1 iduF grinnell:31898-31902 PurgeElements --dsid=DC --xpath="*[contains(.,'u1:') or contains(.,'u2:')]" --verbose
```

## An XML Namespace Issue?

It's not been confirmed just yet, but there is speculation that the real root of the problem here stems from the apparent existence of `srw_dc` namespace references that appear in DC records only when identifier `u1:` or `u2:` elements exist.  You may get some sense of what these references look like on OAI exports from the screen capture shared below.

{{% figure title="Problematic OAI Export Sample" src="/images/post-120/oai_dc-problem.png" %}}  

If this is indeed the root of the problem, then my prayer (:pray:) is that removing all unnecessary `<dc:identifier>` `u1:` and `u2:` elements will make the problem go away.  :four_leaf_clover:


And that's a wrap.  Until next time, stay safe and wash your hands! :smile:
