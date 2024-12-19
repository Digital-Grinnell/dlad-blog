---
title: "Dealing with Alma Dedup and FRBR" 
publishDate: 2024-12-19 12:48:37
last_modified_at: 2024-12-19 12:48:46
draft: false
description: A public blog post copied from `Dealing-with-Alma-Dedup-and-FRBR.md` in my private repo at https://github.com/Digital-Grinnell/Migration-to-Alma-D.
supersedes: 
tags:
  - dedup
  - FRBR
  - Alma
  - Primo
azure:
  dir: 
  subdir: 
---  

# Dealing with Alma/Primo Dedup and FRBR

Together, Alma and Primo (mostly Primo) apply "dedup" and "FRBR" (Functional Requirements for Bibliographic Records) rules that unexpectedly "group" similar titles together.  Since the objects migrating from Islandora to Alma are all intended to be single and un-grouped (unless they are parts of a compound object where we expect and an intentional "grouping" of records), we need to take action to deal with these rules.  Unfortunately, we cannot just turn the rules off or universally modify them since those rules also apply to ALL bib records, not just digital items.

When records are "grouped" together 

# Understanding the Rules

I have yet to see these rules in-the-flesh, but the observed effects suggest that...

1) Any two or more bib records that have matching titles and/or alternative titles will be grouped together.

2) Any two or more bib records that have a matching `dc:identifier` value will be grouped together.  Keep in mind that `dc:identifier`, and similar fields, are multi-valued so this means that if any one value is identical to an identifier value from another bib, the two will be grouped together.

  _I deem this to be a very "good" rule.  It should help to catch true duplicate bibs since `dc:identifier`, and other ID fields, should be universally unique._

3) Like `dc:identifier`, alternative title is a multi-valued field, so ANY alt title value from a record that has an identical title or alt title in another will be will be grouped together. 

  _This caused major headaches for migration since many collections used the alt title field to carry subject-like information._

4) Alma and Primo appear to tokenize the title and alternative title fields (and other fields too) such that embedded punctuation can cause two similar records to be grouped together.  For example...

  The record https://grinnell.primo.exlibrisgroup.com/permalink/01GCL_INST/1g018f9/alma991011506419704641 was originally "grouped" with https://grinnell.primo.exlibrisgroup.com/permalink/01GCL_INST/1g018f9/alma991011506420404641 even though the two records have very different content and no identical title, alt title, or identifier fields values.  The alt titles of these bibs are "First year tutorial, Fall 2001" and "Tutorial, Fall 2001", respectively. The presence of the embedded comma in each apparently causes the "Fall 2001" portion of each alt title to engage dedup and group these very different bib together.     

## Resolving Dedup and FRBR Problems

The following email and Slack excerpts chronicle steps taken to deal specifically with the situation documented in bullet 4 above.

### From Slack... 

>Following up on our conversation yesterday (https://gcl-org.slack.com/archives/C04EMUD2M7Z/p1723563107993219)…

>There’s no change in the Syllabi and Curricular Materials collection this morning, we still have 52 items but I was hoping to see 53 (the correct total) after making a change that would de-dup on pair of items that got incorrectly tagged as duplicates because of an errant (and identical) pair of alt title elements.

>The MMS_IDs are `991 01150 64197 04641` and `991 01150 64204 04641`, objects `grinnell:3452` and `grinnell:3459`.  They both happen to have HAD alt title values that included `Tutorial, Fall 2001`. Yesterday I changed one of the object’s alt title values in the hope that it would un-dedup, but clearly it did not.

>So, now the question is what to do about this?  I hate to blow these away and re-import them.  Not a terrible solution this time, but I fear this is going to keep happening so I’m holding out hope there is a better way.

>Julia identified a potentially better way of dealing with this at https://knowledge.exlibrisgroup.com/Primo/Product_Documentation/020Primo_VE/Primo_VE_(English)/090Dedup_and_FRBR_for_Primo_VE/010Understanding_the_Dedup_and_FRBR_Processes_(Primo_VE).  

### Ex Libris support suggested this...

>Yes, you can put all the MMS IDs for your DG content in the set, including ones that have not been deduped. The job will mark all records in the set ineligible for dedup/frbr. You can run the job at any time, including after your migration is done. You could do it now and again after the migration too. There is no harm in running it now on the existing records, and again after the full migration.

> For the job ""Prevent FRBR and/or Dedup in Discovery", the documentation notes that it will prevent dedup/frbr on records that have not been grouped. However, in my experience, it also breaks up the existing groups.

### My response to the related help ticket...

>Since I was reminded of this, I took steps to give the process a try. Not sure about the outcome yet so I wonder if you could help us determine if it worked or not? Moments ago, I ran job 6980681020004641 and gave it a set of 151 MMS Ids to process. Among those IDs was 991011506419704641, one of two bib records that previously grouped together as matching. This was presumably because an alt title in each record had embedded punctuation, a comma, AND a small portion of their alt titles were an identical match. It seems the presence of punctuation in the title or alt title has an unexpected impact on the dedup results? The other matched record is 991011506420404641 and you can see them both grouped together at https://grinnell.primo.exlibrisgroup.com/discovery/search?query=any,contains,991011506420404641&tab=Everything&search_scope=MyInst_and_CI&sortby=rank&vid=01GCL_INST:GCL&lang=en&offset=0. 

>It's been 20 minutes since I ran the job and the two records in Primo still show up as versions of the same thing, which they are NOT. Can you tell me if the process worked, and if it did, how long do I have to wait to see the result in Primo? Or do I need to list BOTH MMS IDs in my set/job for the group to be break apart? Thanks. -Mark M. 

### Outcome

Eventually, after about an hour the targeted group of bibs was "disolved" yielding two distinct records as was intended, rather than a group with two "versions". 

## Suppressing Dedup and FRBR Rules

The workflow needed to suppress grouping of specific records is documented at https://knowledge.exlibrisgroup.com/Primo/Product_Documentation/020Primo_VE/Primo_VE_(English)/090Dedup_and_FRBR_for_Primo_VE/Suppressing_Groups_of_Records_from_Dedup%2F%2FFRBR_for_Primo_VE.  Note that while this is a "post-processing" step, it's useful only AFTER records have been imported, it does appear to "dissolve" existing unintended grouping as was suggested in the email excerpt which appears in `Ex Libris support suggested this...` above. 

In a nutshell, the workflow involves the following steps:

1) Create a single column .csv file with a column heading of `MMS Id`.

2) Export all of the existing digital item MMS IDs from our `Digital Grinnell` collection and all subordinate collections in Alma.

3) Populate the .csv file with this list of exported MMS IDs, one ID per line.

>Note that steps 1-3 can easily be compressed into a single operation using `Analytics` and the `List-ALL-Active-DCAP01-Bibs- MMS-Only` query stored in `/Shared Folders/Grinnell College Libraries 01GCL_INST/DG Migration`. 

4) Create a new itemized record "set" using the .csv file as input.  Note that the set named `All DG Imported Active Bibs` (ID = 6993436050004641) may be updated and used as necessary.    

5) Select and run the `Prevent FRBR and/or Dedup in Discovery` applying the itemized set mentioned above.

6) Set both `Prevent FRBR in Discovery?` and `Prevent Dedup in Discovery?` parameters to `YES`.

7) Submit the job and wait for results.  Note that once the job completes it may take hours before the effects are fully visible in Primo!  

