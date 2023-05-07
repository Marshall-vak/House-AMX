PROGRAM_NAME='Main Program'

#include 'amx-dvx-control'
#include 'amx-modero-control'
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
dvCOM1_MBRoomTv = 5001:1:0	// RS-232 port 1 
dvCOM2_HRoomTv = 5001:2:0	// RS-232 port 2 (Philips)
dvCOM3_4thRoom = 5001:3:0	// RS-232 port 3 
dvCOM4_LroomTv = 5001:4:0	// RS-232 port 4 (Sharp)

//internal switcher connection
dvDVXSW = 5002:1:0	// Switcher
dvSWV = 5002:1:8	// Switcher Video
dvSWA = 5002:1:10	// Switcher Audio
                                                                                                      
//Video outputs
dvHdmi1_MBRoomTv = 5002:1:0
dvHdmi2_HRoomTv = 5002:2:0
dvHdmi3_4thRoom = 5002:3:0
dvHdmi4_LroomTv = 5002:4:0

//Touch Pannels
dvTP_HRoom = 10001:1:0	 // HRoom
dvTP_LRoom = 10002:1:0	 // Lroom 
dvTP_MBRoom = 10003:1:0	 // HRoom
dvTP_4thRoom = 10004:1:0 // Lroom 

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
LONG lLoopTimes[] = { 500, 500, 500, 500, 500, 500, 500, 500 }

//buttons

//input button codes in order left to right
integer InputButtons[] = { 1, 2, 3, 4, 5, 6 }

//per room device input codes in order left to right
integer HRoomInputs[] = { 5, 6, 1, 2, 3, 4 }
integer LRoomInputs[] = { 5, 6, 1, 2, 3, 4 }

//Display Power Buttons
integer DisplayPower[] = { 254, 255 }
integer PowerOnButtons[] = { 255 }

//touch pannels
DEV dvTPMaster[] = { dvTP_HRoom, dvTP_LRoom }


//dynamic device
DEV dvDynamic

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
 
(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)

DEFINE_START

//yay
print("'Starting AMX Automation!'", false);
 
// loop io as its fun
TIMELINE_CREATE(TL_LOOP, lLoopTimes, LENGTH_ARRAY(lLoopTimes), TIMELINE_RELATIVE, TIMELINE_REPEAT);
 
(***********************************************************)
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)

DEFINE_EVENT

(*
// RS-232 Connections planned not connected as of now.
dvCOM1_HRoomTv = 5001:1:0	// RS-232 port 1 (Philips)
dvCOM2_LroomTv = 5001:2:0	// RS-232 port 2 (Sharp)
dvCOM3_MBRoomTv = 5001:3:0	// RS-232 port 3 
dvCOM4 = 5001:4:0	// RS-232 port 4 
*)

//serial links
DATA_EVENT[dvCOM2_HRoomTv]
{
    online: {
	SEND_COMMAND dvCOM2_HRoomTv,'SET BAUD 9600,N,8,1'
	SEND_COMMAND dvCOM2_HRoomTv, 'HSOFF'
    }
    
    STRING: {
	STACK_VAR CHAR msg[16]
	
	SEND_STRING dvCONSOLE, "'dvCOM2_HRoomTv returned:', msg"
    }
}

DATA_EVENT[dvCOM4_LroomTv]
{
    online: {
	SEND_COMMAND dvCOM4_LroomTv,'SET BAUD 9600,N,8,1'
	SEND_COMMAND dvCOM4_LroomTv, 'HSOFF'
    }
    
    STRING: {
	STACK_VAR CHAR msg[16]
	
	SEND_STRING dvCONSOLE, "'dvCOM4_LroomTv returned:', msg"
    }
}


// beep dvTP1 on startup 
DATA_EVENT[dvTP_HRoom]
{
    ONLINE:
    {
        moderoBeepDouble(dvTP_HRoom)
	SEND_STRING dvCONSOLE, 'a TP came Online!'
    }
}

// beep dvTP2 on startup 
DATA_EVENT[dvTP_LRoom]
{
    ONLINE:
    {
        moderoBeepDouble(dvTP_LRoom)
	SEND_STRING dvCONSOLE, 'a TP came Online!'
    }
}

(*
    room numbers
    HBedroom = 2
    LivingRoom = 1
    MBedroom = 3 
    MBathroom = 4
*)

//Button Press
 BUTTON_EVENT[dvTPMaster, 0]
{
    PUSH:
    {
	//local vars
	LOCAL_VAR dev dvDynamicHdmi
	LOCAL_VAR dev dvDynamicCom
	LOCAL_VAR INTEGER VidInput
	LOCAL_VAR INTEGER VidOutput
	LOCAL_VAR INTEGER AudInput
	LOCAL_VAR INTEGER AudOutput
	LOCAL_VAR INTEGER devCommand
	
        TO[BUTTON.INPUT]
	
	SEND_STRING dvCONSOLE, "'Button pushed on dvTP: ', devToString(Button.Input.Device), ' BUTTON.INPUT.CHANNEL: ', ITOA(BUTTON.INPUT.CHANNEL)"
	
	VidInput = 0
	VidOutput = 0
	AudInput = 0
	AudOutput = 0
	
	if (BUTTON.INPUT.DEVICE == dvTP_HRoom){
	    VidInput = HRoomInputs[BUTTON.INPUT.CHANNEL]
	    VidOutput = 2
	    AudInput = HRoomInputs[BUTTON.INPUT.CHANNEL]
	    AudOutput = 2
	    dvDynamicHdmi = dvHdmi2_HRoomTv
	    dvDynamicCom = dvCOM2_HRoomTv
	}
	    
	if (BUTTON.INPUT.DEVICE == dvTP_LRoom){
	    VidInput = HRoomInputs[BUTTON.INPUT.CHANNEL]
	    VidOutput = 4
	    AudInput = HRoomInputs[BUTTON.INPUT.CHANNEL]
	    AudOutput = 3
	    dvDynamicHdmi = dvHdmi4_LroomTv
	    dvDynamicCom = dvCOM4_LroomTv
	}
	
	if (BUTTON.INPUT.DEVICE == dvTP_MBRoom){
	    VidInput = HRoomInputs[BUTTON.INPUT.CHANNEL]
	    VidOutput = 1
	    AudInput = HRoomInputs[BUTTON.INPUT.CHANNEL]
	    AudOutput = 0
	    dvDynamicHdmi = dvHdmi1_MBRoomTv
	    dvDynamicCom = dvCOM1_MBRoomTv
	}
	
	if (BUTTON.INPUT.DEVICE == dvTP_4thRoom){
	    VidInput = HRoomInputs[BUTTON.INPUT.CHANNEL]
	    VidOutput = 3
	    AudInput = HRoomInputs[BUTTON.INPUT.CHANNEL]
	    AudOutput = 0
	    dvDynamicHdmi = dvHdmi3_4thRoom
	    dvDynamicCom = dvCOM3_4thRoom
	}
	
	if (fnGetIndex(InputButtons, BUTTON.INPUT.CHANNEL) != 0){
	    //dvxSwitchVideoOnly(dev dvxPort1, integer input, integer output)
	    //dvxSwitchAudioOnly(dev dvxPort1, integer input, integer output)
	    if (VidOutput != 0 && VidInput != 0){
		dvxSwitchVideoOnly(dvDVXSW, VidInput, VidOutput)
	    }
	    
	    if(AudOutput != 0 && AudInput != 0){
		dvxSwitchAudioOnly(dvDVXSW, AudInput, AudOutput)
	    }
	}
	
	if (fnGetIndex(DisplayPower, BUTTON.INPUT.CHANNEL) != 0){
	    if (fnGetIndex(PowerOnButtons, BUTTON.INPUT.CHANNEL) != 0){
		if (VidOutput == 2){
		    //SEND_STRING dvDynamicCom, "$36, $20, $30, $20, $30, $20, $32, $37, $20, $32, $20, $33, $30, $0C, $0A"
		    //0x06 0x00 0x00 0x18 0x02 0x1E
		    //SEND_STRING dvCONSOLE, "'sending on'"
		    ON[dvRELAY, 2]
		}
		
		if (VidOutput == 4){
		    SEND_STRING dvDynamicCom, "'POWR 1', $0A"
		}
	    }else{
		if (VidOutput == 2){
		    //SEND_STRING dvDynamicCom, "$36, $20, $30, $20, $30, $20, $32, $37, $20, $31, $20, $33, $30, $0C, $0A"
		    //0x06 0x00 0x00 0x18 0x01 0x1E
		    //SEND_STRING dvCONSOLE, "'sending off'"
		    OFF[dvRELAY, 2]
		}
		
		if (VidOutput == 4){
		    SEND_STRING dvDynamicCom, "'POWR 0', $0A"
		}
	    }
	    
	    
	
	}
    }
}

// loop io as its fun
TIMELINE_EVENT[TL_LOOP]
{
    [dvIO,1] = (TIMELINE.SEQUENCE == 1)
    [dvIO,2] = (TIMELINE.SEQUENCE == 2)
    [dvIO,3] = (TIMELINE.SEQUENCE == 3)
    [dvIO,4] = (TIMELINE.SEQUENCE == 4)
    [dvIO,5] = (TIMELINE.SEQUENCE == 5)
    [dvIO,6] = (TIMELINE.SEQUENCE == 6)
    [dvIO,7] = (TIMELINE.SEQUENCE == 7)
    [dvIO,8] = (TIMELINE.SEQUENCE == 8)
}