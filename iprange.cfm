<cfinclude template="../header.cfm">

<!--- get the list of configured ranges --->
<cfif FileExists("#ExpandPath('.')#/iprange.xml")>
	<cffile action="read" file="#ExpandPath('.')#/iprange.xml" variable="ipRangesWDDX"/>
	<cfwddx action="wddx2cfml" input="#ipRangesWDDX#" output="ipRanges" />
<cfelse>	
	<cfset ipRanges = "" />
</cfif>


<cfif IsDefined("form.action")>

	<cfset octect1start = 0 />
	<cfset octect1end = 0 />
	<cfset octect2start = 0 />
	<cfset octect2end = 0 />
	<cfset octect3start = 0 />
	<cfset octect3end = 0 />
	<cfset octect4start = 0 />
	<cfset octect4end = 0 />

	<cfif IsDefined("form.IPRange") and Len(form.IPRange)>
		
		<cftry>
	
		<!--- first octect --->
		<cfset octect1 = ListGetAt(form.IPRange,1,".") />
		<cfset octect1start = ListFirst(octect1,"-") />
		<cfset octect1end = ListLast(octect1,"-") />
		<cfif octect1start eq "*">
			<cfset octect1start = 0 />
			<cfset octect1end = 255 />
		</cfif>
		
		<cfif octect1start gt octect1end>
			<cfset error = "Invalid IP Address Range" />
		</cfif>
		
		<!--- second octect --->
		<cfset octect2 = ListGetAt(form.IPRange,2,".") />
		<cfset octect2start = ListFirst(octect2,"-") />
		<cfset octect2end = ListLast(octect2,"-") />
		<cfif octect2start eq "*">
			<cfset octect2start = 0 />
			<cfset octect2end = 255 />
		</cfif>
		
		<cfif octect2start gt octect2end>
			<cfset error = "Invalid IP Address Range" />
		</cfif>
		
		<!--- third octect --->
		<cfset octect3 = ListGetAt(form.IPRange,3,".") />
		<cfset octect3start = ListFirst(octect3,"-") />
		<cfset octect3end = ListLast(octect3,"-") />
		<cfif octect3start eq "*">
			<cfset octect3start = 0 />
			<cfset octect3end = 255 />
		</cfif>
		
		<cfif octect3start gt octect3end>
			<cfset error = "Invalid IP Address Range" />
		</cfif>
		
		<!--- fourth octect --->
		<cfset octect4 = ListGetAt(form.IPRange,4,".") />
		<cfset octect4start = ListFirst(octect4,"-") />
		<cfset octect4end = ListLast(octect4,"-") />
		<cfif octect4start eq "*">
			<cfset octect4start = 0 />
			<cfset octect4end = 255 />
		</cfif>
		
		<cfif octect4start gt octect4end>
			<cfset error = "Invalid IP Address Range" />
		</cfif>	
		
			<cfcatch type="any">
				<cfset error = "Invalid IP Address Range" />
			</cfcatch>
		
		</cftry>
			
	<cfelse>
		<cfset error = "IP Range Not Defined" />
	</cfif>

	<cfif not IsDefined("error")>
	
		<cftry>
		
		<cfset debugging = CreateObject("component","cfide.adminapi.debugging") />
		
		<cfswitch expression="#form.action#">
	
			<cfcase value="Add,Refresh">			
							
				<cfset ipList = "" />			
				<cfloop from="#octect1start#" to="#octect1end#" index="a">
					<cfloop from="#octect2start#" to="#octect2end#" index="b">
						<cfloop from="#octect3start#" to="#octect3end#" index="c">
							<cfloop from="#octect4start#" to="#octect4end#" index="d">
								<cfset ipList = ListAppend(ipList,"#a#.#b#.#c#.#d#",",") />
							</cfloop>	
						</cfloop>	
					</cfloop>	
				</cfloop>
				
				<cfset debugging.setIP(ipList) />	
				
				<cfif form.action eq "Add">
					<cfset ipRanges = ListAppend(ipRanges,form.IPRange) />
					<cfwddx action="cfml2wddx" input="#ipRanges#" output="ipRangesWDDX" />
					<cffile action="write" file="#ExpandPath('.')#/iprange.xml" output="#ipRangesWDDX#" />
				</cfif>				
		
			</cfcase>
			
			<cfcase value="Verify">
				<cfset ipList = debugging.getIPList() />
				<cfset missingIPs = "" />
				<cfloop from="#octect1start#" to="#octect1end#" index="a">
					<cfloop from="#octect2start#" to="#octect2end#" index="b">
						<cfloop from="#octect3start#" to="#octect3end#" index="c">
							<cfloop from="#octect4start#" to="#octect4end#" index="d">
								<cfset ip = "#a#.#b#.#c#.#d#" />
								<cfif not ListFindNoCase(ipList,ip,",")>
									<cfset missingIPs = ListAppend(missingIPs,ip) />	
								</cfif>
							</cfloop>	
						</cfloop>	
					</cfloop>	
				</cfloop>
				
				<cfif ListLen(missingIPs,",")>
					<cfset error="The following IP addresses are missing from the IP Range #form.IPRange#: #missingIPs#." />
				<cfelse>
					<cfset message="All IPs were found for the IP Range #form.IPRange#." />
				</cfif>
				
			</cfcase>	
			
			<cfcase value="Delete">			
				
				<cfloop from="#octect1start#" to="#octect1end#" index="a">
					<cfloop from="#octect2start#" to="#octect2end#" index="b">
						<cfloop from="#octect3start#" to="#octect3end#" index="c">
							<cfloop from="#octect4start#" to="#octect4end#" index="d">
								<cfset debugging.deleteIP("#a#.#b#.#c#.#d#") />
							</cfloop>	
						</cfloop>	
					</cfloop>	
				</cfloop>
				
				<cfset pos = ListFind(ipRanges,form.IPRange,",") />
				<cfset ipRanges = ListDeleteAt(ipRanges,pos,",") />
				<cfwddx action="cfml2wddx" input="#ipRanges#" output="ipRangesWDDX" />
				<cffile action="write" file="#ExpandPath('.')#/iprange.xml" output="#ipRangesWDDX#" />
			
			</cfcase>

		</cfswitch>
		
		<cfcatch type="any">
			<cfset error=cfcatch.message />
		</cfcatch>
		
		</cftry>
		
	</cfif>
	
</cfif>

<h2 class="pageHeader"> Custom Debugging > Debugging IP Address Ranges</h2>
<br/>
<br/>
Specify the IP address ranges that should receive debugging messages, including messages for the AJAX Debug Log window. Ranges may use wildcards (192.*.*.*), octect ranges (192.168.1-10.1-120), or a combination of both (192.168.*.1-120).
<br/>
<br/>

<cfif IsDefined("error")>
	<cfoutput>
	<ul>
		<li class="errorText">
			#error#
		</li>
	</ul>
	</cfoutput>
</cfif>

<cfif IsDefined("message")>
	<cfoutput>
	<ul>
		<li>
			<b>#message#</b>
		</li>
	</ul>
	</cfoutput>
</cfif>

<form method="post">
<input type="hidden" name="action" value="Add" />
<table cellspacing="0" cellpadding="5" border="0" width="100%">
	<tr>
		<td class="cellBlueTopAndBottom" bgcolor="#e2e6e7">
			<b> Select IP Address Range for Debug Output</b>
		</td>
	</tr>
	<tr>
		<td>
			<table cellspacing="0" cellpadding="2" border="0" width="100%">
				<tr>
					<td class="cellBlueBottom">
						<label for="ipaddress"> IP Address Range</label>
						<input id="ipaddress" type="text" size="20" name="IPRange" maxlength="50"/>
					</td>
				</tr>
				<tr>
					<td class="cellBlueBottom" bgcolor="#f3f7f7">
						<input class="buttn" type="submit" title="Add" value=" Add " name="Add"/>
					</td>
				</tr>
	
			</table>
		</td>
	</tr>	
</table>
</form>
<br/>

<cfif ListLen(ipRanges) gt 0>
<table border="0" cellpadding="5" cellspacing="0" width="100%">
	<tr>
		<td bgcolor="#E2E6E7" class="cellBlueTopAndBottom">
			<b> Configured IP Address Ranges</b>
		</td>
	</tr>
	<tr>
		<td>		
			<table border="0" cellpadding="2" cellspacing="0" width="100%">
				<tr>
					<th scope="col" nowrap width="100" bgcolor="#F3F7F7" class="cellBlueTopAndBottom">
						<strong> Actions </strong>
					</th>
					<th scope="col" nowrap bgcolor="#F3F7F7" class="cellBlueTopAndBottom">
						<strong> Range</strong>
					</th>
				</tr>
				<cfloop list="#ipRanges#" index="ipRange" delimiters=",">
				<form method="post">
				<input type="hidden" name="action" value="" />	
				<tr>
					<td nowrap class="cell3BlueSides">				
						<table>
							<tr>
								<td>
									<input type="image" src="/CFIDE/administrator/images/iverify.gif" name="Verify" height="16" width="16" border="0" alt="Verify" onclick="this.form.elements['action'].value='Verify';return true;">
								</td>						
								<td>
									<input type="image" src="/CFIDE/administrator/images/idelete.gif" name="Delete" height="16" width="16" border="0" alt="Delete" onclick="this.form.elements['action'].value='Delete';return true;">
								</td>
								<td>
									<input type="image" src="/CFIDE/administrator/images/irefresh.gif" name="Refresh" height="16" width="16" border="0" alt="Refresh" onclick="this.form.elements['action'].value='Refresh';return true;">
								</td>					
							</tr>
						</table>					
					</td>			
					<td nowrap class="cellRightAndBottomBlueSide">
						<cfoutput>
							<input type="hidden" name="IPRange" value="#ipRange#" />
							#ipRange#
						</cfoutput>
					</td>
				</tr>
				</form>	
				</cfloop> 
			</table>
		</td>
	</tr>
</table>
<br/>
</cfif>

<cfinclude template="../footer.cfm">
