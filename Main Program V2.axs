PROGRAM_NAME='Main Program'

#include 'amx-dvx-control'
#include 'amx-modero-control'
#include 'amx-dxlink-control'
#include 'debug'
//#include 'binary'

//so much easier with the libs
//dvxSwitchVideoOnly(dev dvxPort1, integer input, integer output)
//dvxSwitchAudioOnly(dev dvxPort1, integer input, integer output)
//dvxEnableVideoOutputFreeze (dev dvxVideoOutputPort)
//dvxDisableVideoOutputFreeze (dev dvxVideoOutputPort)
//dvxEnableVideoOutputMute (dev dvxVideoOutputPort)
//dvxDisableVideoOutputMute (dev dvxVideoOutputPort)


//dvxSetVideoOutputTestPattern (dev dvxVideoOutputPort, char testPattern[])
/*
 * Function:    dvxSetVideoOutputTestPattern
 *
 * Arguments:   dev dvxVideoOutputPort - video output port on the DVX
 *              char testPattern[] - test pattern
 *                      Values:
 *                          DVX_TEST_PATTERN_OFF
 *                          DVX_TEST_PATTERN_COLOR_BAR
 *                          DVX_TEST_PATTERN_GRAY_RAMP
 *                          DVX_TEST_PATTERN_SMPTE_BAR
 *                          DVX_TEST_PATTERN_HILO_TRACK
 *                          DVX_TEST_PATTERN_PLUGE
 *                          DVX_TEST_PATTERN_X_HATCH
 *                          DVX_TEST_PATTERN_LOGO_1
 *                          DVX_TEST_PATTERN_LOGO_2
 *                          DVX_TEST_PATTERN_LOGO_3
 *
 * Description: Sets the test pattern for the video output port.
 */
 
 
 //dvxSetVideoOutputBlankImage (dev dvxVideoOutputPort, char blankImage[])
 /*
 * Function:    dvxSetVideoOutputBlankImage
 *
 * Arguments:   dev dvxVideoOutputPort - video output port on the DVX
 *              char cBlankImage[] - video blanking image
 *                      Values:
 *                          DVX_BLANK_IMAGE_BLACK
 *                          DVX_BLANK_IMAGE_BLUE
 *                          DVX_BLANK_IMAGE_LOGO_1
 *                          DVX_BLANK_IMAGE_LOGO_2
 *                          DVX_BLANK_IMAGE_LOGO_3
 *
 * Description: Set the image of the video blanking feature for the video
 *              output port.
 */
 

//pannel lib
//moderoSetPage (dev panel, char pageName[])
//moderoSetPagePrevious (dev panel)
//moderoTogglePopup (dev panel, char popupName[])
//moderoBeepDouble (dev panel)

//The enter key for rs232 commands
//,$0D,$0A"

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

// RS-232 Connections planned not connected as of now.
dvCOM1_HRoomTv = 5001:1:0	// RS-232 port 1 
dvCOM2_4thRoom = 5001:2:0	// RS-232 port 2 (Philips)
dvCOM3_MBRoomTv = 5001:3:0	// RS-232 port 3 
dvCOM4_LroomTv = 5001:4:0	// RS-232 port 4 (Sharp)

//internal switcher connection
dvDVXSW = 5002:1:0	// Switcher
dvSWV = 5002:1:8	// Switcher Video
dvSWA = 5002:1:10	// Switcher Audio
 
//Video outputs
dvHdmi1_HRoomTv = 5002:1:0
dvHdmi2_4thRoom = 5002:2:0
dvHdmi3_MBRoomTv = 5002:3:0
dvHdmi4_LroomTv = 5002:4:0

//DxLink DVX in/out
dvDvxDxLinkIn1 = 5002:1:0
dvDvxDxLinkIn2 = 5002:2:0
dvDvxDxLinkOut1 = 5002:3:0
dvDvxDxLinkOut2 = 5002:4:0

//DxLink Boxes
dvDxLinkTx1_HRoom = 20001:1:0
dvDxLinkRx1_HRoom = 20002:1:0
dvDxLinkTx3_MBRoom = 20003:1:0
dvDxLinkRx3_MBRoom = 20004:1:0

//Touch Pannels
dvTP_HRoom = 11:1:0	 // HRoom
dvTP_LRoom = 12:1:0	 // Lroom 
dvTP_MBRoom = 13:1:0	 // HRoom
dvTP_4thRoom = 14:1:0 // 4th room 

//html5 webpannel
vdvSwitcher = 41001:1:0;


(***********************************************************)
(*              Structure DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

STRUCTURE TouchPannel
{
    DEV Id
    CHAR TouchPanelPage[25]
}


(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

//TL_LOOP = 1

// loop io as its fun
//LONG lLoopTimes[] = { 500, 500, 500, 500, 500, 500, 500, 500 }

//input devices
// device 	| button number | Room
// Wii	   	| 01 		| Living Room
// Cameras 	| 02 		| House Wide
// Dvi 3 	| 03 		| None
// Dvi 4 	| 04 		| None
// HTPC 	| 05 		| Living Room
// DVR 		| 06 		| Living Room
// Xbox 	| 07 		| Living Room
// Pc 		| 08 		| Bed Room
// Spare DxLink | 09 		| None
// Cable Box    | 10 		| None

//input button codes in order left to right should match with input number on dvx
integer InputButtons[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }

//RoomNumbers are based on the video output number they are assigned
//should be in order
integer ValidRoomNumbers[] = { 1, 2, 3, 4 }
//should match the order room to number in the table above
RoomTPPageNames[][25] = { 'Main Bedroom', 'Main Bath Room', 'Main Master Bedroom', 'Main Living Room' }

//room select buttons
//the 10xx button range is reserved to room select buttons
integer RoomSelectButtons[] = { 1000, 1001, 1002, 1003, 1004 }

//Display Power Buttons
integer DisplayPower[] = { 254, 255 }
integer PowerOnButtons[] = { 255 }

//Pc Power Buttons
integer LivingRoomPcPower[] = { 30 }

//image mute button
integer ImageMuteButtons[] = { 243 }

//display on and off
integer DisplayPowerOnButtons[] = { 255 }
integer DisplayPowerOffButtons[] = { 254 }

//Device Groups
DEV dvTPMaster[] = { dvTP_HRoom, dvTP_LRoom }
DEV dvDxMaster[] = { dvDxLinkTx1_HRoom, dvDxLinkRx1_HRoom, dvDxLinkTx3_MBRoom, dvDxLinkRx3_MBRoom }
DEV dvHdmiMaster[] = { dvHdmi1_HRoomTv, dvHdmi2_4thRoom, dvHdmi3_MBRoomTv, dvHdmi4_LroomTv }
DEV dvDvxDxlinkInMaster[] = { dvDvxDxLinkIn1, dvDvxDxLinkIn2 }
DEV dvDvxDxLinkOutMaster[] = { dvDvxDxLinkOut1, dvDvxDxLinkOut2 }

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

//Dynamic touch pannel 
TouchPannel TouchPannels[100]

(***********************************************************)
(*              Function DEFINITIONS GO BELOW              *)
(***********************************************************)

DEFINE_FUNCTION INTEGER fnGetIndex(INTEGER nArray[], INTEGER nValue){

   INTEGER x
   
    FOR (x=1; x<=LENGTH_ARRAY(nArray); x++) {
	IF (nArray[x] = nValue) RETURN x
    }

   RETURN 0

}


DEFINE_FUNCTION TPSetupPageTracking(dev panelId, char CompletedPage[]){
    TouchPannels[panelId.number].Id = panelId
    TouchPannels[panelId.number].TouchPanelPage = CompletedPage
    
    moderoSetPage(panelId, CompletedPage)
    
    SEND_STRING dvCONSOLE, "'Setup TP: ', devToString(panelId), ' for page tracking!'"
}

DEFINE_FUNCTION INTEGER TPGetRoomNumber(dev panelId){
    INTEGER RoomNumber
    CHAR RoomName
    INTEGER x
    
    //if its in the table and its on a valid room page
    if (RoomNumber != 0){
	//get the page name from the touch pannel id then cross refrence against the room table to get the number
	RoomName = TouchPannels[panelId.number].TouchPanelPage
	SEND_STRING dvCONSOLE, "'TPGetRoomNumber Called RoomName: ', RoomName"
	
	FOR (x=1; x<=LENGTH_ARRAY(RoomTPPageNames); x++) {
	    IF (RoomTPPageNames[x] = RoomName) RoomNumber = x
	}
	
	SEND_STRING dvCONSOLE, "'TPGetRoomNumber Called RoomNumber: ', ITOA(RoomNumber)"
	
	//finally we verify that the room number is valid
	if (fnGetIndex(ValidRoomNumbers, RoomNumber) != 0){
	    return RoomNumber
	}else{
	    //if it isnt then return 0
	    return 0
	}
    }
}

DEFINE_FUNCTION INTEGER TPGetPage(dev panelId){
    return TouchPannels[panelId.number].TouchPanelPage
}

DEFINE_FUNCTION INTEGER TPSetPage(dev panelId, char PageName[]){
    TouchPannels[panelId.number].TouchPanelPage = PageName
    moderoSetPage(panelId, PageName)
    
    
    SEND_STRING dvCONSOLE, "'going to: ', PageName"
}

 
(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)

DEFINE_START

//yay
print("'Starting AMX Home Automation V2!'", false);

(***********************************************************)
(*                MODULE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_MODULE 

'DvxSwitcherDashboard_dr1_0_0' DvxSwitcherDashboard_dr1_0_0(vdvSwitcher, dvDVXSW);
 
(***********************************************************)
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)

DEFINE_EVENT

// Touch Pannel Startup Program
DATA_EVENT[dvTPMaster]
{
    ONLINE:
    {
	local_var integer x
	
	//setup touch pannel
	moderoDisableAllPopups(Data.Device)
	TPSetupPageTracking(Data.Device, 'Room Select')
	
	FOR (x=1; x<=6; x++) {
	    moderoSetPageFlipPassword(Data.Device, itoa(x), '1988')
	}
	
	moderoSetPageFlipPassword(Data.Device, '1', '1988')
	moderoSetPageFlipPassword(Data.Device, '2', '1988')
	moderoSetPageFlipPassword(Data.Device, '3', '1988')
	moderoSetPageFlipPassword(Data.Device, '4', '1988')
	moderoSetPageFlipPassword(Data.Device, '5', '1988')
	
	
	//enable touch pannel
	moderoBeepDouble(Data.Device)
	moderoEnablePopup(Data.Device, 'Online')
	
	SEND_STRING dvCONSOLE, "'a TP came Online:', devToString(Data.Device)"
    }
}

/*
//DxLink Dvx In
DATA_EVENT[dvDvxDxlinkInMaster]
{
    ONLINE:
    {
	dvxEnableDxlinkInputPortEthernet(Data.Device)
    }
}

//DxLink Dvx Out
DATA_EVENT[dvDvxDxlinkOutMaster]
{
    ONLINE:
    {
	dvxEnableDxlinkOutputPortEthernet(Data.Device)
    }
}
*/

//DxLink
DATA_EVENT[dvDxMaster]
{
    online: {
	SEND_STRING dvCONSOLE, "'A DxLink Box Came online: ', devToString(Data.Device)"
    }
}

//Button Press
 BUTTON_EVENT[dvTPMaster, 0]
{
    PUSH:
    {
	LOCAL_VAR dev dvDynamicHdmi
	LOCAL_VAR dev dvDynamicCom
	LOCAL_VAR INTEGER RoomNumber
	
        TO[BUTTON.INPUT]
	
	SEND_STRING dvCONSOLE, "'Button pushed on dvTP: ', devToString(Button.Input.Device), ' Page: ', TPGetPage(Button.Input.Device), ' RoomNumber: ', ITOA(TPGetRoomNumber(Button.Input.Device)), ' BUTTON.INPUT.CHANNEL: ', ITOA(BUTTON.INPUT.CHANNEL)"
	
	RoomNumber = TPGetRoomNumber(Button.Input.Device)
	
	//Room Select Button Pressed
	if (fnGetIndex(RoomSelectButtons, BUTTON.INPUT.CHANNEL) != 0){
	    //the 1000 button range is reserved to room select buttons
	    if (BUTTON.INPUT.CHANNEL - 1000 == 0){
		//subtracting 1000 should give you the room number. in this case it gives 0 witch is the page select screen
		TPSetPage(Button.Input.Device, 'Room Select')
	    }else{
		//lets work from the inside out with this one
		//get the requested room number by subtracting 1000 from the button pressed
		//then get the name of the page assosiated with the room number
		//finally set the page on the requesting panel to the requested page
		TPSetPage(Button.Input.Device, RoomTPPageNames[BUTTON.INPUT.CHANNEL - 1000])
	    }
	}
	
	//input button pressed
	if (fnGetIndex(InputButtons, BUTTON.INPUT.CHANNEL) != 0){
	    SEND_STRING dvCONSOLE, "'Input Button!'"
	    
	    if (RoomNumber != 0){
		//RoomNumbers are based on the video output number they are assigned
		dvxSwitchVideoOnly(dvDVXSW, RoomNumber, BUTTON.INPUT.CHANNEL)
	    }
	}
	
	//living room pc power button pressed
	if (fnGetIndex(LivingRoomPcPower, BUTTON.INPUT.CHANNEL) != 0){
	    ON[dvRELAY, 4]
	}
    }
    
    RELEASE:
    {
	//living room pc power button released
	if (fnGetIndex(LivingRoomPcPower, BUTTON.INPUT.CHANNEL) != 0){
	    OFF[dvRELAY, 4]
	}
    }    
}

//html5 webpannel
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
	// send_command data.device,'PROPERTY-Has-microphones,false';
    }
}