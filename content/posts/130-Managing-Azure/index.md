---
title: "Managing Azure"
publishdate: 2022-10-19
draft: false
tags:
  - Azure
  - storage
  - blob
---

For the past couple years I/we have been experimenting with moving digital content to _Azure_, both for storage and as a web app host.  The most prominent case is with regard to _Rootstalk_ where _Azure_ currently supports two (recently down from three) static development apps as well as a storage account.  All such services are part of a personal* _Azure_ subscription opened under the digital@grinnell.edu email address. 

*I call this a "personal" account because charges for it are currently billed to my own credit card, a situation that will need to be changed sometime relatively soon.  Fortunately, charges thus far have not exceeded $0.15 per month.

## Terminology

_Azure_ terminology seems a little odd in places, but it's not too much of a departure from other providers of cloud services.  So that we might properly understand things I think it wise to share [Microsoft Azure glossary: A dictionary of cloud terminology on the Azure platform](https://learn.microsoft.com/en-us/azure/azure-glossary-cloud-terminology).  I don't expect these definitions to change, but for easy reference the terms used most often in this document are listed here:

  - [account](https://learn.microsoft.com/en-us/azure/azure-glossary-cloud-terminology#account) - An account that's used to access and manage an Azure subscription. It's often referred to as an Azure account although an account can be any of these: an existing work, school, or personal Microsoft account. You can also create an account to manage an Azure subscription when you sign up for the free trial.

  - [portal](https://learn.microsoft.com/en-us/azure/azure-glossary-cloud-terminology#portal) - The secure web portal used to deploy and manage Azure services.

  - [resource](https://learn.microsoft.com/en-us/azure/azure-glossary-cloud-terminology#resource) - An item that is part of your Azure solution. Each Azure service enables you to deploy different types of resources, such as databases or virtual machines.

  - [resource group](https://learn.microsoft.com/en-us/azure/azure-glossary-cloud-terminology#resource-group) - A container in Resource Manager that holds related resources for an application. The resource group can include all of the resources for an application, or only those resources that are logically grouped together. You can decide how you want to allocate resources to resource groups based on what makes the most sense for your organization.

  - [storage account](https://learn.microsoft.com/en-us/azure/azure-glossary-cloud-terminology#storage-account) - An account that gives you access to the Azure Blob, Queue, Table, and File services in Azure Storage. The storage account name defines the unique namespace for Azure Storage data objects.

  - [subscription](https://learn.microsoft.com/en-us/azure/azure-glossary-cloud-terminology#subscription) - A customer's agreement with Microsoft that enables them to obtain Azure services. The subscription pricing and related terms are governed by the offer chosen for the subscription.

## Azure Home - My Portal

At present the account's "home" or [portal](https://portal.azure.com/#home) looks like this:

{{% figure title="Azure Account Portal" src="/images/post-130/azure-account-portal.png" %}} 

As you can see in the image, the portal lists 8 resources including:

  - 4 static web apps (3 for _Rootstalk_ and one for _CollectionBuilder_),
  - 2 storage accounts (one for _Rootstalk_ and one for _CollectionBuilder_), and
  - 2 included "Resource group" types.

## Removing a Resource and Renaming a Subscription

Before going farther I need to do a little cleanup in the account.  Specifically, the `rootstalk-gokcebel` static web add can be removed, and the subscription name of `Azure subscription 1` should be changed to something more meaningful.  

### rootstalk-gokcebel

Clicking the `rootstalk-gokcebel` link in the portal took me to the screen shown in the figure below.  Since this resource is no longer needed, it was recently replaced by `rootstalk-develop`, I'll just use the `Delete` icon to remove it.

{{% figure title="Deleting a Resource" src="/images/post-130/deleting-a-resource.png" %}} 

To complete the deletion I had to follow-through when prompted with this confirmation screen you see below.  Thankfully, the message was very helpful.

{{% figure title="Confirming Deletion" src="/images/post-130/resource-delete-confirmation.png" %}} 

The `rootstalk-gokcebel` resource is still present in my portal view minutes after the deletion, but clicking on the resource link now takes me to a "Resource not found" screen.

### Azure subscription 1

I really needed a better name than `Azure subscription 1` for my subscription, so I did some searching on the web and found the blurb shown in the figure below.  I also suspect the document it comes from, [Change contact information for an Azure billing account](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/change-azure-account-profile), will come in handy later when I hope to transfer ownership of and billing for the account to the Grinnell College Libraries.

{{% figure title="Confirming Deletion" src="/images/post-130/change-subscription-name.png" %}} 

Unfortunately, that guideance did NOT work!  So I stumbled through a few screens and eventually got it done.  The pages I visited along the way were:

  - [All services](https://portal.azure.com/#allservices/category/All),
  - [Subscriptions](https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionsBlade), and
  - [Azure subscription 1](https://portal.azure.com/#@grinco.onmicrosoft.com/resource/subscriptions/609af5e3-a5d8-4ff9-968f-6524767a4dbe/overview)

On that last page I found a [Rename icon](https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionRenameBlade/subscriptionId/609af5e3-a5d8-4ff9-968f-6524767a4dbe) that took me to a very simple page where I changed the subscription name to `mcfatem - Digital@Grinnell.edu Personal Subscription`.  The name change took only a minute or so to show up in my [portal](https://portal.azure.com/#home) after refreshing my browser.  :smile:

## Creating a New Storage Account

I have a newly-exported `migration-test` collection of digital content from [Digital.Grinnell](https://digital.grinnell.edu) and some of the exported files need a web-addressable blob storage home in the cloud.  So, I used the guidance provided in [Create resource groups](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal#create-resource-groups) and [Create a storage account](https://learn.microsoft.com/en-us/azure/storage/common/storage-account-create?tabs=azure-portal) to make a space for that content.

The new resource group I named `migration-test` and in it is a new storage account named `migrationtestcollection`.  I accepted all of the defaults when creating the storage account.  Unfortunately, _Azure_ naming rules for storage accounts are VERY restrictive, so this name was the best I could do. :frowning:

## Engaging _Azure Storage Explorer_

I've been using the _Azure Storage Explorer_* (ASE) app on my MacBook quite a bit lately, so I'll return there to get the new `migration-test` collection digital objects, the `OBJ` files, from `smb://storage.grinnell.edu/library/allstaff/DG-migration-test` network storage to the new `migrationtestcollection` _Azure_ storage.  In the app I tunneled down into the new `migrationtestcollection` storage account and right-clicked on `Blob Containers` to create a new one as shown in the figure below.

*_Note that in ASE my account still appears as `Azure subscription 1 (Digital@grinnell.edu)` no matter how many times I close and re-open the app._  :frowning:

{{% figure title="Confirming Deletion" src="/images/post-130/new-blob-container.png" %}} 

The new blob container name is `migration-test` and I'm able to select it and use the `Upload` menu item to select and upload all of the `grinnell_*_OBJ.*` files from aforementioned network storage.  The process took less than a minute and left me with 29 stored digital objects.

At the time of this writing the container looked like the figure below when viewed in _Azure Storage Explorer_.

{{% figure title="ASE View of the `migration-test` Container" src="/images/post-130/migration-test-container.png" %}} 

I also created a new `migration-test-metadata` blob container and populated it with all of the other files from `smb://storage.grinnell.edu/library/allstaff/DG-migration-test`.   There are now 53 files stored in that container.

## Web-Addressable Objects

All of the content in the new blob containers should be web-addressable, and a right-click on any file will allow you to see/copy the object's URL and/or path.  For example:

  - [grinnell_10020_OBJ.pdf](https://migrationtestcollection.blob.core.windows.net/migration-test/grinnell_10020_OBJ.pdf) has a URL of https://migrationtestcollection.blob.core.windows.net/migration-test/grinnell_10020_OBJ.pdf
  - [grinnell_10020_MODS.xml](https://migrationtestcollection.blob.core.windows.net/migration-test-metadata/grinnell_10020_MODS.xml) has a URL of https://migrationtestcollection.blob.core.windows.net/migration-test-metadata/grinnell_10020_MODS.xml

Note that both the storage account name, `migrationtestcollection`, and the name of the parent blob container is present, and is consistently included in each URL.  

## A New Jekyll Site in Azure or Reclaim Cloud?

This afternoon I plan to take a big bite out of [Tutorial: Publish a Jekyll site to Azure Static Web Apps](https://learn.microsoft.com/en-us/azure/static-web-apps/publish-jekyll) and maybe a look at [Category: jekyll](https://reclaimhosting.com/category/jekyll/) as well. 


---

That's a wrap for now.  Look for more content here as I continue to expand the role of _Azure_ across the [Digital.Grinnell](https://digital.grinnell.edu) landscape.
