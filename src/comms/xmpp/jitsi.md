<div style="float:right">
	$!Image("xmpp/jitsi.logo.png")!$
</div>

## Jitsi - An XMPP Client

<div class="toc">

Table of Contents

<ol>
	<li>Client UI</li>
	<li>Configuring the Client
		<ul>
			<li>Options</li>
			<li>Add Account</li>
		</ul>
	</li>
</ol>

</div>

We use the [Jitsi SIP-Communications client](http://www.jitsi.org)
because the client best meets our immediate needs:

1. 	text-chat
2.	audio and video chat
3.	specifying the server by IP-Address

The ability to specify the server by IP-Address is important:

* until we can get the proper [DNS SRV Settings](../xmpp.html#domain), and 
* we use a single Jabber-ID @domain at multiple sites using
[clustered ejabberd servers](cluster.html)

Below are the basic instructions for configuration of the Jitsi client.

### Client UI

The Jitsi Client User Interface (UI) has two modes:

1. Full Window Application
2. Minimised (icon in the Notification Toolbar)

#### Full Window Application

The Full Window User Interface, displays your connection status
(e.g. Offline or Available) and the status of your "Contacts".

<div style="text-align:center">
	$!Image("xmpp/jitsi/01.running.client.01.png")!$
	<br />
	Figure: Jitsi Main Window ("Offline")
</div>

The initial client will (obviously) not be connected, as
no accounts have been configured, and we have no "Contacts"

#### Minimised

When not in active use, you can "hide" away the Jitsi client
by minimising it, and it will be accessible from the Windows
Task Bar "Notification Area"

To get at the menu bar from the "Minimised" application:

1. Mouse "Right-Click" on the Jitsi Icon.

<div style="text-align:center">
	$!Image("xmpp/jitsi/01.running.client.03.png")!$
	<br />
	Figure: Jitsi Notification Icon
</div>

The initial minimised client will (obviously) not be connected,
and as such will be "greyed out" by losing all it's colours.

<div style="text-align:center">
	$!Image("xmpp/jitsi/01.running.client.02.png")!$
	<br />
	Figure: Jitsi Notification Icon (coloured when an account is connected)
</div>


### Configuring the Client

The Jitsi client runs with a Window or minimised and accessible from
it's Task Bar Notification Icon. The Account items are:

*	Network Type: Jabber
*	Jabber-ID or Username: user-name**@example.com**
*	Password: as-provided-to-you
*	Advanced Settings: **Connection**
	*	Connect Server: (only necessary if you're DNS setting is not correct)

The following is a guide to specifying the above configuration.

1. Show Options
2. Accounts -> Add
3. Add Accounts - Select a Network
4. Add Accounts - Network List - Jabber
5. Add Accounts - Details
	* Add Accounts - Advanced Settings
	* Add Accounts - Advanced Settings - Connection
	* Add Accounts - Advanced Settings - Summary
6. Options - Account Configured
7. Active Client


#### 1. Show Options

To get at the Options dialog:

From the Running Jitsi client, select the 

1. Tools Menu
2. Options command 

From the Jitsi notification Icon, 

1. 	Right Click the icon and 
2. 	Select the "Options" command

<div style="text-align:center">
	$!Image("xmpp/jitsi/01.tools.options.png")!$
	<br />
	Figure: From the Jitsi Client: Tools --> Options
</div>

To get the menus from the Jitsi Notification Icon, "Right-Click" on the
icon.

<div style="text-align:center">
	$!Image("xmpp/jitsi/01.running.client.options.png")!$
	<br />
	Figure: From the Jitsi Notification Icon: --> Options
</div>



#### 2. Options - Accounts -> Add

From the Options dialog box, make sure you are:

1.	in the "Accounts" Tab (i.e. the Accounts toolbar item is sunken/selected) 
2.	Click on the "Add" button.

<div style="text-align:center">
	$!Image("xmpp/jitsi/02.accounts.add.png")!$
	<br />
	Figure: From the Options dialog box: Accounts --> Add
</div>

#### 3. Add Accounts - Select a Network

The Add new account dialogue box starts by requiring we **select a network**

1. 	Click on the **select network** drop-down list-box to view a list
	of account-types supported by Jitsi.
	
<div style="text-align:center">
	$!Image("xmpp/jitsi/03.select.network.png")!$
	<br />
	Figure: From Add Account dialogue box: Select a Network
</div>

#### 4. Add Accounts - Network List - Jabber

We are running an XMPP/Jabber Server (ejabberd) so:

1. 	Clicking on the **select network** will give us our list
2.	Click on the JABBER network
3.	[Add] is not enabled, do not click it.

<div style="text-align:center">
	$!Image("xmpp/jitsi/04.select.network.jabba.png")!$
	<br />
	Figure: From Select Network drop down list, Select Jabber
</div>

Clicking on the **JABBER** network will give us the configuration
options for this server type.

#### 5. Add Accounts - Details

The contents of the [Add new account] dialogue will change to give
more options that we need to complete.

In the appropriate text-fields, enter the details you've been given:

1. Existing Account (we've created the account, leave this as the selected option)
2. Username: make sure you use the full Jabber ID name **user-name@example.com**
   Specify the username and the **@** server-name.
3. Password: <strong>******</strong>
4. Advanced: If you have not set up your [DNS SRV Settings](../xmpp.html#domain), 
	then click on the Advanced button

<div style="text-align:center">
	$!Image("xmpp/jitsi/05.add.new.account.jabber.png")!$
	<br />
	Figure: Complete the Add new account details and select Advanced.
</div>

After completing the dialogue:

*	If you **have not** set up your [DNS SRV Settings](../xmpp.html#domain), 
	then click on the **Advanced** button.
*	Click **Add** to complete your configurations.

##### a) Add Accounts - Advanced Settings

The advanced settings allow modifying the standard:

- **Account** information, as well as 
- **Connection** Settings and
- **ICE Configuration** Settings.

<div style="text-align:center">
	$!Image("xmpp/jitsi/06.add.new.account.jabber.advanced.png")!$
	<br />
	Figure: In this dialog, select the <strong>Connection</strong> Tab
</div>

We need to modify the **Connection** settings, so select this tab by
clicking on the **Connection** tab.

##### b) Add Accounts - Advanced Settings - Connection

In the **Connection** tab, we want to:

1. Specify the **Connect Server**
2. Click the **Next** button

<div style="text-align:center">
	$!Image("xmpp/jitsi/07.add.new.account.jabber.advanced.connection.png")!$
	<br />
	Figure: Complete the "Connect Server" details and click <strong>Next</strong>
</div>

When the DNS SRV records are correctly configured, then this field will be
your Jabber-ID @example.com hostname.

In a split environment, such as ours, one site will have correct SRV records, whilst
others have to specify the Address for the Connect Server.

For Vietnam users, specify the connect server as: 10.9.0.1

##### c) Add Accounts - Advanced Settings - Summary

The next dialogue, is a summary of the configurations we've
specified.

<div style="text-align:center">
	$!Image("xmpp/jitsi/08.add.new.account.jabber.advanced.summary.png")!$
	<br />
	Figure: Complete the "Connect Server" details and click <strong>Next</strong>
</div>

Clicking on **Sign In** will complete the account configuration, and 
attempt to log into the XMPP/Jabber Server.

#### 6. Options - Account Configured

Returning to the Options dialogue box, your account should show on the list.

<div style="text-align:center">
	$!Image("xmpp/jitsi/09.signed.in.png")!$
	<br />
	Figure: Your configured account should be displayed.
</div>

If your configuration is successful, we can close the dialog box. Otherwise,
you may get an error that the account is not valid, or your password
is incorrect.

Close the dialog box to return to the Jitsi client.

#### 7. Active Client

When you have successfully configured your account, the client will
connect to the server and the display will change.

<div style="text-align:center">
	$!Image("xmpp/jitsi/10.jitsi.client.01.connected.png")!$
	<br />
	Figure: You are connected (Green Online button).
</div>

The standard window will display a "Green" button, indicating you
are successfully logged in.

<div style="text-align:center">
	$!Image("xmpp/jitsi/01.running.client.02.png")!$
	<br />
	Figure: You are connected (Jitsi logo is colourful).
</div>

The minimised notification icon will be in colour.

#### Errors ?

If you have entered the **wrong password**, you will be prompted
to re-enter the password. 

If you have entered the **wrong Connection Server**, the connection
will time-out/fail and you will need to edit your account settings.

If you're password is correct, but you have entered the **wrong
Jabber ID** (i.e. username@example.com) you must delete the listed
account, and create a new account.