---
title: "Stop Mac OS X from Requiring a Repeat of User Name"
publishDate: 2020-09-01
lastmod: 2020-09-01T10:03:14-05:00
draft: false
tags:
  - Cisco
  - AnyConnect
  - VPN
  - Keychain
---

Ever since moving to a new college-controlled VPN client, _Cisco AnyConnect_, for VPN access on August 1, 2020, I've had to **repeatedly** enter both my username and system password every time I launch a VPN connection. The annoying prompt/dialog looked like this:

{{% figure title="Keychain Access Prompt" src="/images/post-089/Access-Keychain-Prompt.png" %}}

Fortunately, I found [this post and answer](https://superuser.com/a/1306894) explaining how to enable Keychain Access without having to repeat the User Name twice each time. The suggested process is this:

{{% original %}}
 Launch /Applications/Utilities/Keychain Access

• Select "System" from the Keychains menu in the upper left

• Select "Certificates" from the Category menu in the lower left

• Find the entry that corelates to your computer's name in the list on the right, and click on the disclosure triangle.

• Secondary click on the "Private Key" entry that appears and select "Get Info" from the contextual menu that appears.

• Select the Access Control tab.

• You can then either add AnyConnect to the the list at the bottom of the screen (more secure, but you will need to repeat this process anytime the version of AnyConnect changes), or toggle the radio button to "Allow all applications to access this item".
{{% /original %}}

Note that I chose to add _AnyConnect_ to my list of allowed apps, so presumably I'll need to repeat this change every time that a new version of _Cisco AnyConnect_ is installed.

And that's a wrap.  Until next time...
