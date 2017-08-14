IP Ranger Installation Notes

1.   Welcome
2.   License and Credits
3.   Installation
4.   Usage


1. Welcome
-----------------------------------------------------------------------

Welcome to IP Ranger, a ColdFusion administrator extension which 
allows IP ranges to be added to the debugging IP address list:

http://ipranger.riaforge.org

If you like this project, please consider supporting the creator at
his Amazon wish lists:

http://www.amazon.com/gp/registry/wishlist/1PMU5WXR9RZNJ/ref=wl_web/


2. License and Credits
-----------------------------------------------------------------------

Licensed under the Apache License, Version 2.0 (the "License"); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
implied. See the License for the specific language governing 
permissions and limitations under the License.

3. Installation
-----------------------------------------------------------------------

To install the IP Ranger, extract the .zip installation package to a 
folder on your computer. Next find your ColdFusion administrator, 
typically located under your web root at: /CFIDE/administrator. Copy
the ipranger folder from the installation package to the administrator.
Find the custommenu.xml file in the administrator folder and add the
following submenu element:

<submenu label="Custom Debugging">
	<menuitem 
		href="ipranger/iprange.cfm" 
		target="content">Debugging IP Address Ranges</menuitem>
</submenu>

If you do not have a custommenu.xml file you can copy the sample
included in the installation package to the administrator folder.

4. Usage
-----------------------------------------------------------------------

To open IP Ranger, login to the ColdFusion administrator and look for 
a new menu heading, "Custom Debugging." Expand the heading and click on
the "Debugging IP Address Ranges" menu item.

IPv4 IP address ranges may then be added using wildcards (192.*.*.*), 
octect ranges (192.168.1-10.1-120), or a combination of both 
(192.168.*.1-120). 

IP Ranger also allows you to verify, delete, and refresh IP address 
ranges, as individual IP addresses from a range may be deleted via
the Debugging IP Addresses administrator page. The verify option
will check that each range IP address is in the current debugging IP 
address list. The delete option will remove all range IP addresses 
from the current debugging IP address list. The refresh option will
re-add any missing range IP addresses to the current debugging IP 
address list. 
