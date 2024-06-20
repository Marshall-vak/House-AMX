PROGRAM_NAME='Main Program V3'

#include 'amx-dvx-control'
#include 'amx-modero-control'
#include 'amx-dxlink-control'
#include 'debug'


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
dvCOM6 = 5001:6:0	// RS-232 port 6 //used for debug see debug include

//internal switcher connection
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
dvTp1 = 11:1:0		// Bedroom Room
dvTp2 = 12:1:0		// Living room
dvTp3 = 13:1:0		// Bedroom Room 2

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


//Output Select Buttons
INTEGER OutputButtons[] = { 11, 12, 13, 14 }
//Physical Output Numbers (IN ORDER)
INTEGER PhysicalOutputNumbers[] = { 1, 2, 3, 4 }

//Input Select Buttons
INTEGER InputButtons[] = { 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 }
//Physical input Numbers (IN ORDER)
INTEGER PhysicalInputNumbers[] = { 6, 10, 5, 8, 1, 2, 7, 9, 3, 4 }

//Input / Output Master
INTEGER InputOutputMaster[] = { 11, 12, 13, 14, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 }


//Living Room Pc Power Button
INTEGER OptiplexPowerButton[] = { 31 }

//H Room tv on off button
INTEGER HRoomTvOnOffButton[] = { 32 }

//Button codes on the Main Page ( All of the above )
INTEGER MainPageMaster[] = { 11, 12, 13, 14, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32 }


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
DEV dvTPMaster[] = { dvTp1, dvTp2 }

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

// Console command for use in dvCom1 commands to the dgx
ComCommand[40] = ''

//used during a display power toggle
INTEGER DisplayToggle = 0

(***********************************************************)
(*              Function DEFINITIONS GO BELOW              *)
(***********************************************************)

DEFINE_FUNCTION INTEGER fnGetIndex(INTEGER nArray[], INTEGER nValue)
{

    //for use in for loops
    INTEGER x
   
    FOR (x=1; x<=LENGTH_ARRAY(nArray); x++) {
	IF (nArray[x] = nValue) RETURN x
    }

   RETURN 0

}

DEFINE_FUNCTION INTEGER channelGet(dev device, integer chan)
{

    return [device, chan]
    
}

DEFINE_FUNCTION INTEGER fnHasOutputFeedback(dev dvTP)
{

    //for use in for loops
    INTEGER x
    
    for (x=1; x<=LENGTH_ARRAY(OutputButtons); x++) {
	if (channelGet(dvTP, OutputButtons[x]) == 1) return 1
    }
    
    return 0
    
}

DEFINE_FUNCTION INTEGER fnHasInputFeedback(dev dvTP)
{
    
    //for use in for loops
    INTEGER x
    
    for (x=1; x<=LENGTH_ARRAY(InputButtons); x++) {
	if (channelGet(dvTP, InputButtons[x]) == 1) return 1
    }
    
    return 0
    
}

DEFINE_FUNCTION fnResetOutputFeedback(dev dvTP)
{

    //for use in for loops
    INTEGER x
    
    //for every input disable the feedback
    for (x=1; x<=LENGTH_ARRAY(OutputButtons); x++) {
	moderoDisableButtonFeedback(dvTP, OutputButtons[x])
    }
    
}

DEFINE_FUNCTION fnResetInputFeedback(dev dvTP)
{
    
    //for use in for loops
    INTEGER x
    
    //for every input disable the feedback
    for (x=1; x<=LENGTH_ARRAY(InputButtons); x++) {
	moderoDisableButtonFeedback(dvTP, InputButtons[x])
    }
}

/*
//CL0I16O5 6 7T
//CLI(INPUT)16O(Output)5 6 7T(Take)
//CL0I + input number + O + output numbers + T
DEFINE_FUNCTION INTEGER fnCalculateComCommand(dev dvTP)
{
    
    //for use in for loops
    INTEGER x
    
    //Start With Change Input
    ComCommand = 'CL0I'
    
    //add the input
    for (x=1; x<=LENGTH_ARRAY(InputButtons); x++) {
	if (channelGet(dvTP, InputButtons[x])){
	    ComCommand = "ComCommand, ITOA(PhysicalInputNumbers[x])"
	}
    }
    
    //Add O for outputs
    ComCommand = "ComCommand, 'O'"
    
    //Add the outputs
    for (x=1; x<=LENGTH_ARRAY(OutputButtons); x++) {
	if (channelGet(dvTP, OutputButtons[x])){
	    if (ComCommand[LENGTH_ARRAY(ComCommand)] == 'O'){
		ComCommand = "ComCommand, ITOA(PhysicalOutputNumbers[x])"
	    } else {
		ComCommand = "ComCommand, ' ', ITOA(PhysicalOutputNumbers[x])"
	    }
	}
    }
    
    //add T to the end of the command for Take
    ComCommand = "ComCommand, 'T'"
    
    //debug log
    print("'Calculated ComCommand: ', ComCommand", false);
    
    //if there is nothing passed there is an error stop the program
    if (ComCommand == 'CL0IOT') return 0
    
    //no error... Continue!
    return 1
}
*/

DEFINE_FUNCTION INTEGER fnDvxSwitchVideo(dev dvTP)
{
    
    //for use in for loops
    INTEGER x
    INTEGER VidInput
    INTEGER Switched
    INTEGER VidOutputs[4]

    //reset variables
    VidInput = 0
    Switched = 0
    
    for (x=1; x<=LENGTH_ARRAY(VidOutputs); x++) {
	VidOutputs[x] = 0
    }
    
    print("'Switching DVX Video'", false)
    
    //add the input
    for (x=1; x<=LENGTH_ARRAY(InputButtons); x++) {
	if (channelGet(dvTP, InputButtons[x])){
	    VidInput = PhysicalInputNumbers[x]
	}
    }
    
    print("'Switching Input: ', ITOA(VidInput)", false)
    
    //Add the outputs
    for (x=1; x<=LENGTH_ARRAY(OutputButtons); x++) {
	if (channelGet(dvTP, OutputButtons[x])){
	    VidOutputs[x] = PhysicalOutputNumbers[x]
	}else{
	    VidOutputs[x] = 0
	}
    }
    
    print("'Switching Output: ', ITOA(VidOutputs[1]), ', ', ITOA(VidOutputs[2]), ', ', ITOA(VidOutputs[3]), ', ', ITOA(VidOutputs[4])", false)
    
    //if there is nothing passed there is an error stop the program
    if (VidInput == 0){
	print("'An Error Occured while switching the video: No input selected'", false)
	return 0
    }
    
    //Switch the video
    for (x=1; x<=LENGTH_ARRAY(OutputButtons); x++) {
	if (VidOutputs[x] != 0){
	    print("'Switching Output: ', ITOA(VidOutputs[x]), ' to input ', ITOA(VidInput)", false)
	    dvxSwitchVideoOnly(dvDVXSW, VidInput, VidOutputs[x])
	    Switched = 1
	}
    }

    if (Switched){
	//no error... Continue!
	return 1
	
	print("'Switched Video Without Error'", false)
    } else {
	return 0
	
	print("'An Error Occured while switching the video'", false)
    }
}

// System Reset Function
DEFINE_FUNCTION fnResetSystem()
{
    //for use in for loops
    INTEGER x

    print("'Resetting All Systems'", false);
    
    //change all 5 tvs to the "news"
    //SEND_COMMAND dvCOM1, "'CL0I1O5 6 7 8 10T'"
    
    //set the projector to the projector input
    //SEND_COMMAND dvCOM1, "'CL0I5O9T'"

    //for every touch panel in the table
    for (x=1; x<=LENGTH_ARRAY(dvTPMaster); x++) {
	//wake all panels
	moderoWake(dvTPMaster[x])
	
	//reset input and output button feedback
	fnResetInputFeedback(dvTPMaster[x])
	fnResetOutputFeedback(dvTPMaster[x])
	
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
    print("'Toggling output ', ITOA(dvhdmi)", false);
    
    //trigger a display toggle event
    DisplayToggle = 1
    
    //check if the display is on or off
    dvxRequestVideoOutputOn(dvhdmi)
    
    //rest of code on data_event[dvHdmiMaster]
}

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

//yay
print("'Starting AMX Home Automation V3!'", false);

fnResetSystem()

(***********************************************************)
(*                MODULE DEFINITIONS GO BELOW              *)
(***********************************************************) 

//html 5 web panel
DEFINE_MODULE 'DvxSwitcherDashboard_dr1_0_0' DvxSwitcherDashboard_dr1_0_0(vdvSwitcher, dvDVXSW);

// projector communication module // disabled due to not controling projector
//DEFINE_MODULE 'Optoma_TH1060_Comm_dr1_0_0' comm(vdvOptomaTH1060, dvOptomaTH1060);

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

//for connection to the dgx
DATA_EVENT[dvCOM1]
{
    ONLINE: {
	SEND_COMMAND dvCOM1,'SET BAUD 9600,N,8,1'
	SEND_COMMAND dvCOM1, 'HSOFF'
    }
    
    STRING: {
	STACK_VAR CHAR msg[16]
	
	print("'dvCOM1 returned:', msg", false)
    }
}

//for debug spew //connect a computer to this port and open a terminal to see the debug prints
DATA_EVENT[dvCOM6]
{
    ONLINE: {
	SEND_COMMAND dvCOM1,'SET BAUD 9600,N,8,1'
	SEND_COMMAND dvCOM1, 'HSOFF'
    }
    
    STRING: {
	STACK_VAR CHAR msg[16]
	
	//heh funny loop
	print("'dvCOM6 returned:', msg", false)
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
	    //print("devToString(data.Device)", false)
	    //print("data.text", false)
	    
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
	fnResetInputFeedback(data.Device)
	fnResetOutputFeedback(data.Device)
	
	//enable touch panel
	moderoSetPage(data.Device, 'Main')
	moderoBeepDouble(data.Device)
	moderoEnablePopup(data.Device, 'Online')
	
	print("'a TP came Online:', devToString(data.Device)", false)
    }
}

 BUTTON_EVENT[dvTPMaster, 0]
 {
    PUSH:
    {
	//for use in for loops
	INTEGER x
	
	//Log what button was pressed on what panel
	print("'Button pushed on dvTP: ', devToString(BUTTON.INPUT.DEVICE), ' BUTTON.INPUT.CHANNEL: ', ITOA(BUTTON.INPUT.CHANNEL)", false)
	
	// if the pressed button is in the WelcomePageMaster group (table) then run the code
	if (fnGetIndex(WelcomePageMaster, BUTTON.INPUT.CHANNEL) != 0){
	    print("'Button Pressed On The Welcome Page'", false);
	    
	    if (fnGetIndex(WelcomePageStartButton, BUTTON.INPUT.CHANNEL) != 0){
		print("'Start Button Pressed'", false);
	    }
	}
	
	// if the pressed button is in the MainPageMaster group (table) then run the code
	if (fnGetIndex(MainPageMaster, BUTTON.INPUT.CHANNEL) != 0){
	    print("'Button Pressed On The Main Page'", false);
	    
	    // if the pressed button is in the OptiplexPowerButton group (table) then run the code
	    if (fnGetIndex(OptiplexPowerButton, BUTTON.INPUT.CHANNEL) != 0){
		print("'Optiplex Power Button pressed'", false);
		
		ON[dvRELAY, 4]
	    }
	    
	    //HRoomTvOnOffButton
	    if (fnGetIndex(HRoomTvOnOffButton, BUTTON.INPUT.CHANNEL) != 0){
		print("'HRoom Tv Toggle Button Pressed'", false);
		
		fnToggleOutput(dvHdmi1)
	    }
	    
	    if (fnGetIndex(InputOutputMaster, BUTTON.INPUT.CHANNEL) != 0){
		if (fnGetIndex(OutputButtons, BUTTON.INPUT.CHANNEL) != 0){
		    print("'Button Pressed Adressing Output Selection: '", false);
		    
		    //turn on the button feedback for the button that was pressed
		    moderoToggleButtonFeedback(BUTTON.INPUT.DEVICE, BUTTON.INPUT.CHANNEL)
		    
		    //channelGet(dev TP, INTIGER Channel)
		    //fnHasOutputFeedback(dev TP)
		    //fnHasInputFeedback(dev TP)
		    
		    //if an output button is pressed and an input button is already pressed
		    if (fnHasInputFeedback(BUTTON.INPUT.DEVICE)){
			//calculate the com command and if its a sucess run the command
			//if(fnCalculateComCommand(BUTTON.INPUT.DEVICE)) SEND_STRING dvCOM1, ComCommand
			
			if (fnDvxSwitchVideo(BUTTON.INPUT.DEVICE)){
			    //reset the button feedback
			    fnResetOutputFeedback(BUTTON.INPUT.DEVICE)
			    fnResetInputFeedback(BUTTON.INPUT.DEVICE)
			}
		    }
		} else {
		    print("'Button Pressed Adressing Input Selection'", false);
		    
		    //turn on the button feedback for the button that was pressed
		    moderoToggleButtonFeedback(BUTTON.INPUT.DEVICE, BUTTON.INPUT.CHANNEL)
		    
		    //only input button can be pressed at once
		    if (fnHasInputFeedback(BUTTON.INPUT.DEVICE)){
			//Disable all input buttons
			fnResetInputFeedback(BUTTON.INPUT.DEVICE)
			
			//ReEnable the button that was just pressed
			moderoEnableButtonFeedback(BUTTON.INPUT.DEVICE, BUTTON.INPUT.CHANNEL)
		    }
		    
		    //if an input button is pressed and an output button is already pressed
		    if (fnHasOutputFeedback(BUTTON.INPUT.DEVICE)){
			//if(fnCalculateComCommand(BUTTON.INPUT.DEVICE)) SEND_STRING dvCOM1, ComCommand
			
			if (fnDvxSwitchVideo(BUTTON.INPUT.DEVICE)){
			    //reset the button feedback
			    fnResetOutputFeedback(BUTTON.INPUT.DEVICE)
			    fnResetInputFeedback(BUTTON.INPUT.DEVICE)
			}
		    }
		}
	    }
	}
	
	// if the pressed button is in the ShutdownPopupMaster group (table) then run the code
	if (fnGetIndex(ShutdownPopupMaster, BUTTON.INPUT.CHANNEL) != 0){
	    print("'Button Pressed On The Shutdown Popup'", false);
	    
	    // if the button is in the table then its a yes
	    if (fnGetIndex(ShutDownYesButtons, BUTTON.INPUT.CHANNEL) != 0){
		// Call System reset
		
		fnResetSystem()
	    } else {
		//else then it was a no
		print("'Aborting System Reset!'", false);
		
		//print("'==================[ implement me ]=================='", false);
	    }
	}
    }

    RELEASE:
    {
	//Log what button was released on what panel
	print("'Button released on dvTP: ', devToString(BUTTON.INPUT.DEVICE), ' BUTTON.INPUT.CHANNEL: ', ITOA(BUTTON.INPUT.CHANNEL)", false)
	
	// if the released button is in the OptiplexPowerButton group (table) then run the code
	if (fnGetIndex(OptiplexPowerButton, BUTTON.INPUT.CHANNEL) != 0){
	    OFF[dvRELAY, 4]
	}
    }
 }

//html5 webpanel
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
