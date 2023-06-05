PROGRAM_NAME='Main Program'

#include 'amx-dvx-control'
#include 'amx-modero-control'
#include 'amx-dxlink-control'
#include 'debug'

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

//DxLink
dvDxLinkTx1_HRoomTv = 20001:1:0
dvDxLinkRx1_HRoomTv = 20002:1:0
dvDxLinkTx3_MBRoomTv = 20003:1:0
dvDxLinkRx3_MBRoomTv = 20004:1:0

//Touch Pannels
dvTP_HRoom = 10001:1:0	 // HRoom
dvTP_LRoom = 10002:1:0	 // Lroom 
dvTP_MBRoom = 10003:1:0	 // HRoom
dvTP_4thRoom = 10004:1:0 // 4th room 

//html5 webpannel
vdvSwitcher = 41001:1:0;

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

TL_LOOP = 1

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

// loop io as its fun
//LONG lLoopTimes[] = { 500, 500, 500, 500, 500, 500, 500, 500 }

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

//input button codes in order left to right
integer InputButtons[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
integer ValidRoomNumbers[] = { 1, 2, 3, 4 }

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

//room select buttons
integer RoomSelectButtons[] = { 1000, 1001, 1002, 1003, 1004 }

//touch pannels
DEV dvTPMaster[] = { dvTP_HRoom, dvTP_LRoom }
DEV dvDxMaster[] = { dvDxLinkTx1_HRoomTv, dvDxLinkRx1_HRoomTv, dvDxLinkTx3_MBRoomTv, dvDxLinkRx3_MBRoomTv }
DEV dvHdmiMaster[] = { dvHdmi1_HRoomTv, dvHdmi2_4thRoom, dvHdmi3_MBRoomTv, dvHdmi4_LroomTv }

//Dynamic touch pannel 
integer TouchPanelIndex[10]
integer TouchPanelPage[10]

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


DEFINE_FUNCTION TPSetupPageTracking(dev panelId, integer CompletedPage){
    INTEGER PanelIndex
    
    PanelIndex = fnGetIndex(TouchPanelIndex, device_id(panelId))

    if (PanelIndex != 0){
	TouchPanelIndex[PanelIndex] = device_id(panelId)
    }else{
	PanelIndex = length_array(TouchPanelIndex) + 1
	TouchPanelIndex[PanelIndex] = device_id(panelId)
    }
	
    //10 is a random non generated even number used to represent the page select screen
    TouchPanelPage[PanelIndex] = string_to_variable(CompletedPage)
    moderoSetPage(panelId, CompletedPage)
    
    SEND_STRING dvCONSOLE, "'Setup TP: ', devToString(panelId), ' for page tracking!'"
}

DEFINE_FUNCTION INTEGER TPGetRoom(dev panelId){
    INTEGER RoomNumber
    
    //get the position of the pannel in the table of page numbers
    RoomNumber = fnGetIndex(TouchPanelIndex, device_id(panelId))
    //if its in the table and its on a valid room page
    if (RoomNumber != 0 && fnGetIndex(ValidRoomNumbers, TouchPanelPage[RoomNumber])){
	//then set the room number var to the page number
	RoomNumber = TouchPanelPage[RoomNumber]
    }
    
    //if either fnGetIndex checks fail then RoomNumber will be 0
    return RoomNumber
}

DEFINE_FUNCTION INTEGER TPGetPage(dev panelId){
    INTEGER PageNumber
    
    //get the position of the pannel in the table of page numbers
    PageNumber = fnGetIndex(TouchPanelIndex, device_id(panelId))
    //if its in the table
    if (PageNumber != 0){
	//then set the room number var to the page number
	PageNumber = TouchPanelPage[PageNumber]
    }
    
    //if the fnGetIndex check fails then PageNumber will be 0
    return PageNumber
}

DEFINE_FUNCTION INTEGER TPSetPage(dev panelId, integer Page){
    INTEGER PanelIndex
    PanelIndex = fnGetIndex(TouchPanelIndex, device_id(panelId))

    if (PanelIndex != 0){
	//Track the page change
	TouchPanelPage = string_to_variable(Page)
	moderoSetPage(panelId, Page)
    }else{
	//just incase this magically failed the first time
	TPSetupPageTracking(panelId, Page)
    }
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
	//setup touch pannel
	moderoDisableAllPopups(Data.Device)
	TPSetupPageTracking(Data.Device, 'Room Select')
	moderoSetPageFlipPassword(Data.Device, "3", "1988")
	
	
	//enable touch pannel
	moderoBeepDouble(Data.Device)
	moderoEnablePopup(Data.Device, 'Online')
	
	SEND_STRING dvCONSOLE, "'a TP came Online:', devToString(Data.Device)"
    }
}

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
	LOCAL_VAR INTEGER Room
	LOCAL_VAR INTEGER VidOutput
	LOCAL_VAR INTEGER AudOutput
	
        TO[BUTTON.INPUT]
	
	SEND_STRING dvCONSOLE, "'Button pushed on dvTP: ', devToString(Button.Input.Device), ' Page: ', TPGetPage(Button.Input.Device) , ' BUTTON.INPUT.CHANNEL: ', ITOA(BUTTON.INPUT.CHANNEL)"
	
	Room = TPGetRoom(Button.Input.Device)
	VidOutput = 0
	AudOutput = 0
	
	//Room Select Button Pressed
	if (fnGetIndex(RoomSelectButtons, BUTTON.INPUT.CHANNEL) != 0){
	    if (BUTTON.INPUT.CHANNEL - 1000 == 0){
		
	    }
	
	}
	
	//input button pressed
	if (fnGetIndex(InputButtons, BUTTON.INPUT.CHANNEL) != 0){
	    SEND_STRING dvCONSOLE, "'Input Button!'"
	    
	    if (VidOutput != 0){
		dvxSwitchVideoOnly(dvDVXSW, VidOutput, BUTTON.INPUT.CHANNEL)
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