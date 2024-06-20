PROGRAM_NAME='Main Program V4-SP'

#include 'amx-dvx-control'
#include 'amx-modero-control'
#include 'amx-dxlink-control'
#include 'console'
#include 'utils'


(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

// Master Controller
dvCONSOLE = 0:1:0

//gpio connections
dvIO = 5001:17:0	// GPIO

//relays
dvRELAY = 5001:8:0      //Relays

// RS-232 Connections
dvCOM1 = 5001:1:0	// RS-232 port 1 
dvCOM2 = 5001:2:0	// RS-232 port 2
dvCOM3 = 5001:3:0	// RS-232 port 3 
dvCOM4 = 5001:4:0	// RS-232 port 4
dvCOM5 = 5001:5:0	// RS-232 port 5 
dvCOM6 = 5001:6:0	// RS-232 port 6 //used for debug see console include

// Internal switcher connection
dvDVXSW = 5002:1:0	// Switcher

//Video outputs
dvHdmi1 = 5002:1:0	//HDMI Out 1 and DxLink Out 1
dvHdmi2 = 5002:2:0	//HDMI Out 2
dvHdmi3 = 5002:3:0	//HDMI Out 3 and DxLink Out 2
dvHdmi4 = 5002:4:0	//HDMI Out 4

//DxLink DVX in/out ports
dvDvxDxLinkIn1 = 5002:1:0	//DxLink Input 1
dvDvxDxLinkIn2 = 5002:2:0	//DxLink Input 2
dvDvxDxLinkOut1 = 5002:3:0	//DxLink Output 1
dvDvxDxLinkOut2 = 5002:4:0	//DxLink Output 2

//Touch Panels
dvTP1 = 11:1:0	
dvTP2 = 12:1:0	
dvTP3 = 13:1:0	

//DxLink Boxes
dvDxIn1 = 20001:1:0 // Extra
dvDxIn2 = 20002:1:0 // Master Bedroom Input
dvDxOut1 = 20003:1:0 // Bedroom output
dvDxOut2 = 20004:1:0 // Master Bedroom Output

//DxLink Boxes IR Output
dvDxIn1IrOut = 20001:3:0 // Extra
dvDxIn2IrOut = 20002:3:0 // Master Bedroom Input
dvDxOut1IrOut = 20003:3:0 // Bedroom output
dvDxOut2IrOut = 20004:3:0 // Master Bedroom Output

//html5 webpanel
vdvSwitcher = 41001:1:0;	// Virtual Device

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

//Big Start Button on the Welcome Page
INTEGER WelcomePageStartButton[] = { 1 }

//All Welcome Page Buttons
INTEGER WelcomePageMaster[] = { 1 } //WelcomePageStartButton }


//H Room tv on off button
INTEGER HRoomTvOnOffButton[] = { 32 }

//Button codes on the Main Page ( All of the above )
INTEGER MainPageMaster[] = { 32 }


//Audio Popup Power Buttons
INTEGER ShutDownButtons[] = { 100 }
//When a shutdown button is pressed we can check if its in the yes table and if its not then its no
//Again think of a grid (again [again {again}])
INTEGER ShutDownYesButtons[] = { 100 }

//Shutdown Abort Button
INTEGER ShutdownAbortButton[] = { 120 }

//All Buttons on the Shutdown System Page ( All of the above )
INTEGER ShutdownPopupMaster[] = { 100 }


//Group of all touch panels connected to the master
DEV dvTPMaster[] = { dvTP1, dvTP2 }

//Group of all HDMI outputs on the DVX
DEV dvHdmiMaster[] = { dvHdmi1, dvHdmi2, dvHdmi3, dvHdmi4 }

//Group of all DxLink Inputs on the back of the dvx
DEV dvDvxDxlinkInMaster[] = { dvDvxDxLinkIn1, dvDvxDxLinkIn2 }

//Group of all DxLink Outputs on the back of the dvx
DEV dvDvxDxLinkOutMaster[] = { dvDvxDxLinkOut1, dvDvxDxLinkOut2 }

//Group of all DxLink Input Boxes connected to the master
DEV dvDxLinkInMaster[] = { dvDxIn1, dvDxIn2 }

//Group of all DxLink Output Boxes connected to the master
DEV dvDxLinkOutMaster[] = { dvDxOut1, dvDxOut2 }

//Group of all DxLink Boxes connected to the master
DEV dvDxLinkMaster[] = { dvDxIn1, dvDxIn2, dvDxOut1, dvDxOut2 }

//Group of all DxLink Boxes Ir Blasters connected to the master
DEV dvDxLinkIrOutMaster[] = { dvDxIn1IrOut, dvDxIn2IrOut, dvDxOut1IrOut, dvDxOut2IrOut }

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

//used during a display power toggle
INTEGER DisplayToggle = 0

(***********************************************************)
(*              Function DEFINITIONS GO BELOW              *)
(***********************************************************)

// System Reset Function
DEFINE_FUNCTION fnResetSystem()
{
    //for use in for loops
    INTEGER x

    print("'Resetting All Systems'", CONSOLE_INFO);
    
    //change all 5 tvs to the "news"
    //SEND_COMMAND dvCOM1, "'CL0I1O5 6 7 8 10T'"
    
    //set the projector to the projector input
    //SEND_COMMAND dvCOM1, "'CL0I5O9T'"

    //for every touch panel in the table
    for (x=1; x<=LENGTH_ARRAY(dvTPMaster); x++) {
	//wake all panels
	moderoWake(dvTPMaster[x])
	
	//reset input and output button feedback
	//fnResetInputFeedback(dvTPMaster[x])
	//fnResetOutputFeedback(dvTPMaster[x])
	
	//disable all popups
	moderoDisableAllPopups(dvTPMaster[x])
	
	//set the page to the welcome page
	moderoSetPage(dvTPMaster[x], 'Main')
	
	//beep the touch panel
	moderoBeepDouble(dvTPMaster[x])
    }
}

//Toggle video output
DEFINE_FUNCTION fnToggleOutput(dev dvhdmi)
{
    print("'Toggling output ', ITOA(dvhdmi)", CONSOLE_DEBUG);
    
    //trigger a display toggle event
    DisplayToggle = 1
    
    //check if the display is on or off
    dvxRequestVideoOutputOn(dvhdmi)
    
    //rest of code on data_event[dvHdmiMaster]
}

(***********************************************************)
(*                MODULE DEFINITIONS GO BELOW              *)
(***********************************************************) 

// Html 5 web panel
DEFINE_MODULE 'DvxSwitcherDashboard_dr1_0_0' DvxSwitcherDashboard_dr1_0_0(vdvSwitcher, dvDVXSW);

// Dvx/Dgx Switchers
// DEFINE_MODULE 'DXX Switcher' mDXXSwitcher(dvTPMaster, dvDVXSW, dvCOM5);
DEFINE_MODULE 'DXX Switcher' mDXXSwitcher(dvTP2, dvDVXSW, dvCOM5);

// Projector communication module // disabled due to not controling projector
// DEFINE_MODULE 'Optoma_TH1060_Comm_dr1_0_0' comm(vdvOptomaTH1060, dvOptomaTH1060);

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

// Yay
print("'Starting AMX Home Automation V4-SP!'", CONSOLE_INFO);

fnResetSystem()

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

// Used for debug spew located in console include
DATA_EVENT[dvCOM6]
{
    ONLINE: {
	SEND_COMMAND dvCOM6,'SET BAUD 9600,N,8,1'
	SEND_COMMAND dvCOM6, 'HSOFF'
    }
    
    STRING: {
	STACK_VAR CHAR msg[16]
	
	// Heh funny loop
	print("'dvCOM6 returned:', msg", CONSOLE_DEBUG)
    }
}

//Display output toggeler
DATA_EVENT[dvHdmiMaster]
{
    COMMAND:
    {
	//if we are currently trying to toggle a display continue
	if (DisplayToggle == 1){
	    //debug
	    //print("devToString(data.Device)", CONSOLE_DEBUG)
	    //print("data.text", CONSOLE_DEBUG)
	    
	    //if the display is enabled
	    if (data.text == 'VIDOUT_ON-ENABLE'){
		//disable the display
		dvxDisableVideoOutputOn(data.Device)
	    } else { //VIDOUT_ON-DISABLE
		//if the display is disabled
		//enable the display
		dvxEnableVideoOutputOn(data.Device)
	    }
	    
	    //stop the display toggle event
	    DisplayToggle = 0
	}
    }
}

// Touch Panel Startup Program
DATA_EVENT[dvTPMaster]
{
    ONLINE:
    {
	//wake panel
	moderoWake(data.Device)
	
	//setup touch panel
	moderoDisableAllPopups(data.Device)
	
	//set panel passwords
	moderoSetPageFlipPassword(data.Device, '1', '1950')
	
	//Debug Menu Password
	moderoSetPageFlipPassword(data.Device, '2', '1998')
	
	//default unused passwords
	moderoSetPageFlipPassword(data.Device, '3', '1988')
	moderoSetPageFlipPassword(data.Device, '4', '1988')
	
	//pannel admin password
	moderoSetPageFlipPassword(data.Device, '5', '1988')
	
	//reset input and output feedback for this panel
	//fnResetInputFeedback(data.Device)
	//fnResetOutputFeedback(data.Device)
	
	//enable touch panel
	moderoSetPage(data.Device, 'Main')
	moderoBeepDouble(data.Device)
	moderoEnablePopup(data.Device, 'Online')
	
	print("'a TP came Online: ', devToString(data.Device)", CONSOLE_INFO)
    }
}

BUTTON_EVENT[dvTPMaster, 0]
{
    PUSH:
    {
	//for use in for loops
	INTEGER x
	
	//Log what button was pressed on what panel
	print("'Button pushed on dvTP: ', devToString(BUTTON.INPUT.DEVICE), ' BUTTON.INPUT.CHANNEL: ', ITOA(BUTTON.INPUT.CHANNEL)", CONSOLE_DEBUG)
	
	// if the pressed button is in the WelcomePageMaster group (table) then run the code
	if (fnGetIndex(WelcomePageMaster, BUTTON.INPUT.CHANNEL) != 0){
	    print("'Button Pressed On The Welcome Page'", CONSOLE_DEBUG);
	    
	    if (fnGetIndex(WelcomePageStartButton, BUTTON.INPUT.CHANNEL) != 0){
		print("'Start Button Pressed'", CONSOLE_DEBUG);
	    }
	}
	
	// if the pressed button is in the MainPageMaster group (table) then run the code
	if (fnGetIndex(MainPageMaster, BUTTON.INPUT.CHANNEL) != 0){
	    print("'Button Pressed On The Main Page'", CONSOLE_DEBUG);
	    
	    //HRoomTvOnOffButton
	    if (fnGetIndex(HRoomTvOnOffButton, BUTTON.INPUT.CHANNEL) != 0){
		print("'HRoom Tv Toggle Button Pressed'", CONSOLE_DEBUG);
		
		fnToggleOutput(dvHdmi2)
	    }
	}
	
	// if the pressed button is in the ShutdownPopupMaster group (table) then run the code
	if (fnGetIndex(ShutdownPopupMaster, BUTTON.INPUT.CHANNEL) != 0){
	    print("'Button Pressed On The Shutdown Popup'", CONSOLE_DEBUG);
	    
	    // if the button is in the table then its a yes
	    if (fnGetIndex(ShutDownYesButtons, BUTTON.INPUT.CHANNEL) != 0){
		// Call System reset
		
		fnResetSystem()
	    } else {
		//else then it was a no
		print("'Aborting System Reset!'", CONSOLE_DEBUG);
	    }
	}
    }

    RELEASE:
    {
	//Log what button was released on what panel
	print("'Button released on dvTP: ', devToString(BUTTON.INPUT.DEVICE), ' BUTTON.INPUT.CHANNEL: ', ITOA(BUTTON.INPUT.CHANNEL)", CONSOLE_DEBUG)
	
    }
}

// HTML5 Webpanel
data_event[vdvSwitcher]
{
    online: 
    {
	send_command data.device,'DEBUG-1';
	
	(***********************************************************)
	(*                UI customization options                 *)
	(***********************************************************)
	// Override reported DVX matrix size
	// send_command data.device,'PROPERTY-INPUT.COUNT,4';
	// send_command data.device,'PROPERTY-OUTPUT.COUNT,2';
	// Remove reported DVX Components
	send_command data.device,'PROPERTY-Has-microphones,false';
    }
}

(*****************************************************************)
(*                                                               *)
(*                      !!!! WARNING !!!!                        *)
(*                                                               *)
(* Due to differences in the underlying architecture of the      *)
(* X-Series masters, changing variables in the DEFINE_PROGRAM    *)
(* section of code can negatively impact program performance.    *)
(*                                                               *)
(* See Differences in DEFINE_PROGRAM Program Execution section   *)
(* of the NX-Series Controllers WebConsole & Programming Guide   *)
(* for additional and alternate coding methodologies.            *)
(*****************************************************************)

DEFINE_PROGRAM

(*****************************************************************)
(*                       END OF PROGRAM                          *)
(*                                                               *)
(*         !!!  DO NOT PUT ANY CODE BELOW THIS COMMENT  !!!      *)
(*                                                               *)
(*****************************************************************)
