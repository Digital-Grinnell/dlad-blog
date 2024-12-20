---
title: "Collection Migration Template" 
publishDate: 2024-12-20T09:47:59-06:00
last_modified_at: 2024-12-20T10:00:39
draft: false
description: A public blog post copied from `Collection-Migration-Template.md` in my private repo at https://github.com/Digital-Grinnell/Migration-to-Alma-D.
supersedes: 
tags:
  - Alma
  - migration
azure:
  dir: 
  subdir: 
---  

This document lists the commands and steps, without a lot of detail, that should be taken to migrate a DG collection.  Use this document as a template for recording actual collection migration, where additional details may be necessary.

1) Check our [Migration Google Sheet](https://docs.google.com/spreadsheets/d/1JzW8TGU8qJlBAlyoMyDS1mkLTGoaLrsCzVtwQo-4JlU) to verify that there is NO worksheet for the target collection.  If one exists you should rename it for safe-keeping to get it out of the way.

2) Map the `smb://storage/mediadb/DGingest/Migration-to-Alma/outputs` and `smb://storage/mediadb/DGingest/Migration-to-Alma/exports` to the workstation as `/Volumes/outputs` and `/Volumes/exports`, respectively.   

3) On your workstation, `cd` into the `migrate-MODS-to-dcterms` project directory and verify that the `main` branch and its `venv` are active.  Your prompt should look something like this: `(.venv) ╭─mcfatem@MAC02FK0XXQ05Q ~/GitHub/migrate-MODS-to-dcterms ‹main›`.  Use the `source .venv/bin/activate` command if needed.  

```zsh
cd ~/GitHub/migrate-MODS-to-dcterms
source .venv/bin/activate
```

4) Run `main.py`. Assuming a target collection ID of `__target-collection__`, it should look like this:  

```zsh
time python3 main.py --collection_name __target-collection__ 
```
5) Run `to-google-sheet.py`.  Assuming a target collection ID of `__target-collection__`, it should look like this:  

```zsh
time python3 to-google-sheet.py --collection_name __target-collection__    
```
6) The collection's stakeholder(s) should be engaged to clean-up the metadata found in the new `__target-collection__` worksheet in our [Migration Google Sheet](https://docs.google.com/spreadsheets/d/1JzW8TGU8qJlBAlyoMyDS1mkLTGoaLrsCzVtwQo-4JlU).

7) Run `manage-collections.py`. Assuming a target collection ID of `__target-collection__`, it should look like this:  

```zsh
time python3 manage-collections.py --collection_name __target-collection__ 
```

{{% alert %}}
Note that the `manage-collections.py` script does LOTS of things for you.  It will take care of rearranging most "compound" object data to achieve our intended Alma/Primo structures.  Don't skip this step!  
{{% /alert %}}

8) The scripts may fail to change compound parent and child objects' `collection_id` as they should, so you should intervene and copy the `pending-review` ID (`81313013130004641`) into every row in the spreadsheet replacing ALL `collection_id` values.

This will import the objects into the suppressed `pending-review` collection so they can be reviewed before being moved to the proper sub-collection.  

_Note: The above was inserted as step 8 on 2024-Aug-22._ 

9) Navigate to `~/GitHub/worksheet-file-finder`, set your VENV as needed, and run the `streamlit_app.py` script/application to check the `file_name_1` column (typically column `AW`) values against network storage, typically `/Volumes/exports/__target-collection__/OBJ`.

This step is now a `Streamlit` Python app so it should be largely self-explanatory.  See the app's `README.md` file for additional details if needed. 

The `streamlit_app.py` will also check that the column headings in your worksheet are correct!  

_Note: The above was inserted as step 9 on 2024-Aug-22 and dramatically modified on 2024-Oct-15._ 

10) Note that there are options in `worksheet-file-finder` to automatically generate thumbnail images (`.clientThumb` files in the case of Alma migration) AND copy both the found `OBJ` and `clientThumb` to a new `/Volumes/outputs/OBJs` subdirectory.  

_Note: The above was inserted as step 10 on 2024-Dec-18._ 

11) Run `expand-csv.py`. Assuming a target collection ID of `__target-collection__`, it should look like this:   

```zsh
time python3 expand-csv.py --collection_name __target-collection__
```

**Attention!  The `expand-csv.py` script now accepts optional parameters `--first_row` (or `-f`) and `--last_row` (or `-l`) that can be used to limit the rows of the `__target-collection__` Google Sheet that the `values.csv` file contains.  

```zsh
time python3 expand-csv.py --collection_name __target-collection__ --first_row 50 --last_row 500
```

If the `--first_row` parameter is omitted it defaults to `2`, and if the last is omitted it defaults to `5000`.  The `--last_row` limit is automatically trimmed to the last row of data in the sheet so specifying a number larger than the row count effectively includes all rows including and after `--first_row`.   

12) Examine the `/Volumes/outputs/__target-collection__` directory to confirm that a new `values.csv` file has been created.  

13) In Alma, invoke the `Digital Uploader` via the `Resources | Digital Uploader` menu selection.

14) In the `Digital Uploader` choose `Add New Ingest` from the menu tab in the upper center of the window.

15) Give the ingest a descriptive and unique name `Ingest Details | Name` and note the all-important `ID` value displayed below it.

16) Select `Add Files` then navigate to the `/Volumes/outputs/__target-collection__` network directory and select the `values.csv` file there.

17) Click on `Upload All` to send the `values.csv` file off for later processing and click `OK`.

18) The `Digital Uploader` page should show the aforementioned `ID` with a status of `Upload Complete`.  

19) Return to the terminal prompt where we will now enter some `aws S3...` commands following guidance provided in `AWS-S3-Storage-Info.md`. 

20) List the contents of our `upload` directory like so: 

```zsh
aws s3 ls s3://na-st01.ext.exlibrisgroup.com/01GCL_INST/upload/ --recursive --human-readable --summarize
```

21) Verify that there's a short list of files in `../upload/` including our `values.csv` file.  Copy the ID portion of the `values.csv` (two subdirectories after `upload`) path for use in the next step.

22) Paste the copied path into the following `aws S3` command AND be sure to change the `__target-collection__` to our intended target.

```zsh
aws s3 cp /Volumes/exports/OBJs/ s3://na-st01.ext.exlibrisgroup.com/01GCL_INST/upload/__PASTE__/ --recursive
```

This should copy the `/Volumes/outputs/OBJs` subdirectory contents of our collection into AWS for ingest.

23) List the contents of our `upload` directory to verify, like so:

```zsh
aws s3 ls s3://na-st01.ext.exlibrisgroup.com/01GCL_INST/upload/ --recursive --human-readable --summarize    
```

24) Return to the `Digital Uploader` and select the ingest (should be at the top of the list) and click `Submit Selected`.  

25) Wait for the `Run MD Import` button to be enabled, then click it.

26) After a short time you should see a pop-up that says:  `Import job xxxxxxxxxxxx04641 submitted successfully`.

27) Navigate in the menus to `Resources` | `Monitor and View Imports` to check on progress.  

28) Be patient while the ingest takes place and you're almost done!

29) Once the import/ingest is complete, report all of the new `MMS_ID` values and copy/paste them back into the corresponding `mms_id` cells of the `__target-collection__` worksheet.

30) Move the completed `__target-collection__` worksheet and its `..._READY-FOR-EXPANSION` companion to the `Migration-Arcive` Google Sheet.  See the `Migration-to-Alma-D` Google Sheet `README` tab for instruction.  

_Note: The two sections above were appended as steps 28 and 29 (now 29 and 30) on 2024-Aug-22._ 

31) Use `Resources` and `Manage Collections` to pull up the `Pending Review` collection and select up to 50 records at a time, then click the `Move Selected` option, search for and select the `__target-collection__`.  Moving all of the `Pending Review` content in this manner may take many iterations. 

_Note: Section 30 (now 31) above was appended on 2024-Oct-15._ 


