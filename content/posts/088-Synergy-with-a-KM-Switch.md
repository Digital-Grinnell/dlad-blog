---
title: "Synergy with a KM (Keyboard/Mouse) Switch: A Near-Perfect Combination"
publishDate: 2020-08-28
lastmod: 2020-08-28T08:08:38-05:00
draft: false
tags:
  - Synergy
  - KM switch
  - keyboard/mouse
  - Universal Clipboard
---

I think I have finally found (created?) a multi-computer desktop environment that is nearly perfect; it combines [Synergy](https://symless.com/synergy) with a [4-port USB KM switch](https://www.aten.com/us/en/products/usb-&-thunderbolt/peripheral-switches/us424/) that I purchased a few months ago after my other solutions failed, again. The many miserable failures that came before this solution tell a bleak story, but perhaps my telling it here will save others some grief.

## The Goal

Just to be clear, the purpose of my journey has always been to engage multiple computers with one or more monitors from a SINGLE keyboard and mouse. I absolutely **loathe** having to use more than one keyboard/mouse combination to support multiple computers. I've also found that it's really nice if those computers can share things like:

  - The clipboard - So that I can copy and paste files and material from one comptuer to another.
  - USB Peripherals - Things like printers, scanners, external hard drives, and my label printer.

## My Desktop Environment

The desktop environment that I have in my home-office features a personal Mac Mini connected to a 39" Vizio LCD screen, plus a college-owned 21" iMac with an extra 21" LCD dedicated monitor.  I also have two MacBook Air portable computers, one personal and the other owned by the college, that I connect into the mix when needed, or when I need computing power on-the-road. Elsewhere in my home I have a collection that includes two NAS (network attached storage) computers running Linux, a Mac Mini with a large monitor or my daughter, another iMac for my wife, and three more MacBook Air computers distributed between my wife and daughter. Mackenzie, my daughter, also has the only remining Windows machine in the house, a Lenovo laptop.

All of this, plus a handful of iPhones, iPads, and Apple Watches exist on my LAN along with a pair of networked laser printers. Suffice it to say, there are wires, and wireless signals, EVERYWHERE.

## What Used to Work

What used to work? Well, for one, Apple's [Universal Clipboard](https://support.apple.com/en-us/HT209460) used to work, but it doesn't anymore. 🙍 It's a wonderful feature, easy to configure and use, except when the controling agency/department won't let it. In my case the controlling agency/department is a "Windows shop", so I'm not surprised that their "solutions" don't mesh with Apple's.

Aside from Universal Clipboard, the litany of things I've tried in the past is frankly too long to remember in detail, so in no particular order, they include:

  - Numerous KVM switches - These all involved lots of wires and a single monitor, which was nice, but no longer practical. I need LOTS of monitor real estate these days because my vision isn't what it used to be. 😢
  - A StarTech USB cable - This thing combined a "smart" USB cable, between two computers, with some software to provide a really slick experience that had all the features I needed. Unfortunately, it was flaky and frequently misbehaved. When OS X transitioned to 64-bit only the thing was no longer supported and became uterly useless.
  - The aforementioned 4-port USB KM switch - Another really nice solution, but it lacked the software that the StarTech cable had, so it wasn't as flaky, but also has no clipboard sharing and only allows sharing of limited peripherals, one's that don't have to be continuously connected. Also, it requires me to click a built-in hardware switch to move my KM focus from one computer to another.
  - Synergy - This is a wonderful piece of software (no hardware involved) that provides ALL of the capability that I need, and it's inexpensive, so I purchased a license in January 2019. Unfortunately, like the StarTech cable, it is also a little flaky and somewhat difficult to configure.
  - Sharemouse - This is another software-only solution that's a little easier to configure than Synergy, and seems to be a bit more stable. But still, there are significant limitations that I'll talk about in general below.

## Why Those Things No Longer Work

The real key to my computing environment is the college-owned iMac, it is the most powerful machine I have and the only one that has all the tools I need to do my job. Since it is a college-owned machine it must comply with college IT policy, and for the most part, that's why my previous soltuions have all failed. I understand why the policy is what it is, but there are available workarounds and strategies that I beleive could be successfully used, but nobody has vetted them nor are they willing to spend time doing so. I get that too.

The most frustrating issue for me involves the college VPN which requires use of the [Cisco AnyConnect Secure Mobility Client](https://www.cisco.com/c/en/us/products/security/anyconnect-secure-mobility-client/index.html) configured to the college's specifications and under their control. I connect via VPN quite often and for long periods of time so this is especially painful. When engaged, the Cisco client takes complete control of the iMac's networking such that NONE of my network-dependent resources work. That effectively renders me unable to share ANY resources including my keyboard and mouse, printers, scanners, and external memory devices. Even with my "almost ideal" solution, this issue with loss of connectivity whenever VPN is active remains a big problem, but one that I can now workaround even when things aren't working optimally.

### The Deal Breaker

The software solutions I've used, Synergy and Sharemouse, are by far the best options; they just work, except when they don't. 😦 When using either solution the VPN issue has always been present, but there are also times when the software just gets wonky. I've never been able to pinpoint all the conditions that cause things to go awry, but believe me, it happens all the time, every day, sometimes more than once per day. Even worse, when the software fails I'm generally stuck using whatever machine had my keyboard/mouse focus at the time, and the other machine is effectively unreachable. In the past I had to physically connect a "spare" keyboard and mouse to the "zombie" machine to get control back, then I'd have to restart both machines and reconfigure the whole mess again. Rinse and repeat, daily, or sometimes every few hours.

## What Works...the Good Part

For many months now I abandoned all of the software solutions in favor of a more reliable, but less capable and convenient, hardware soltuion. Until this past week I had never even thought about bringing any of the software soltuions, specifically Synergy, back to use in-concert with the hardware. I was pleasantly surprised at how well the combination works.

The hardware portion of the scheme, my 4-port USB KM switch, seems to be very reliable, albeit not very convenient. The software component, Synergy, provides me with the ability to not only share they keyboard and mouse, but it does so seemlessly. I simply move the mouse from one screen to the other (the software is configured to know where the screens are in relation to each other) and the focus changes instantly. Even better, anything I copy on one screen or machine, is instantly available to paste on the other, so I no longer have to email or IM text or files between adjacent machines. All of this works with no apparent ill-effects from using the two schemes in-tandem. It just works! Woot woot!

And the very best feature, if the software does gets wonky (it hasn't thus far, execpt in a couple of tests where I forced it to fail) I don't have to connect a spare keyboard/mouse combination to get control back, I simply press my KM switch and move the existing keyboard/mouse focus to the "other" machine. Best of all, having made this switch it looks like I can take any action necessary to get the software back in-sync and working properly.

This is as close to desktop computing nirvana as I can get, and I'm happy to have it. 😄

And that's a wrap.  Until next time...
