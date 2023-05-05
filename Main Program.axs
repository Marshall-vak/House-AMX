PROGRAM_NAME='Main Program'

#include 'amx-dvx-control'
#include 'amx-modero-control'

//so much easier with the lib
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
dvCOM1 = 5001:1:0	// RS-232 port 1 (Left Projector)
dvCOM2 = 5001:2:0	// RS-232 port 2 (Center Projector)
dvCOM3 = 5001:3:0	// RS-232 port 3 (Right Projector)
dvCOM4 = 5001:4:0	// RS-232 port 4 (Light Board)

//internal switcher connection
dvDVXSW = 5002:1:0	// Switcher
dvSWV = 5002:1:8	// Switcher Video
dvSWA = 5002:1:10	// Switcher Audio

dvLeftProjector = 5002:1:0
dvRightProjector = 5002:2:0
dvCenterProjector = 5002:3:0
dvBackProjector = 5002:4:0


//Touch Pannel (Sound Board)
dvTP1 = 10001:1:0	// NXT-CV7-1 

//Touch Pannel (Booth)
dvTP2 = 10002:1:0	// NXT-CV7-2 
 
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

//about test button
INTEGER btnAbout[] = { 1, 2 }

//reset button
INTEGER btnReset[] = { 100 }

//Calibration button
btnCalibration[] = { 101 }

//button projector assignments
INTEGER LeftProjectorButtons[] = { 3, 4, 11, 12, 13, 14, 15, 30, 31, 32, 33, 34 }
INTEGER RightProjectorButtons[] = { 5, 6, 16, 17, 18, 46, 19, 35, 36, 37, 47, 48 }
INTEGER CenterProjectorButtons[] = { 7, 8, 20, 21, 22, 23, 24, 49, 50, 51, 52, 53 }
INTEGER BackProjectorButtons[] = { 9, 10, 25, 26, 27, 28, 29, 54, 55, 56, 57, 58 }

//Prokector power buttons
INTEGER ProjectorPowerButtons[] = { 38, 40, 42, 44, 39, 41, 43, 45 }
INTEGER ProjectorPowerOnButtons[] = { 38, 40, 42, 44 }
INTEGER ProjectorPowerOffButtons[] = { 39, 41, 43, 45 }

// input buttons
INTEGER InputButtons[] = { 12, 17, 21, 26, 13, 18, 22, 27, 14, 46, 23, 28, 15, 19, 24, 29, 30, 35, 49, 54, 31, 36, 50, 55 }
INTEGER SoundBoardHdmiButtons[] = { 12, 17, 21, 26 }
INTEGER LeftPodiumHdmiButtons[] = { 13, 18, 22, 27 }
INTEGER RightPodiumHdmiButtons[] = { 14, 46, 23, 28 }
INTEGER NestHdmi1Buttons[] = { 15, 19, 24, 29 }
INTEGER DVDButtons[] = { 30, 35, 49, 54 }
INTEGER VHSButtons[] = { 31, 36, 50, 55 }

// Projection Pattern Buttons
INTEGER PatternButtons[] = { 11, 16, 20, 25, 59, 64, 69, 74, 60, 65, 70, 75, 61, 66, 71, 76, 62, 67, 72, 77, 63, 68, 73, 78 }
INTEGER InputLogoButtons[] = { 11, 16, 20, 25 }
INTEGER XHATCHButtons[] = { 59, 64, 69, 74 }
INTEGER ColorBarButtons[] = { 60, 65, 70, 75 }
INTEGER SMPTEBarButtons[] = { 61, 66, 71, 76 }
INTEGER PlungeButtons[] = { 62, 67, 72, 77 }
INTEGER HILOTrackButtons[] = { 63, 68, 73, 78 }

//touch pannels
DEV dvTPMaster[] = { dvTP1, dvTP2 }

//dynamic vars
INTEGER VidInput
INTEGER ProjectorNumber
INTEGER ScreenNumber
CHAR Pattern[] = ''


//dynamic device
DEV dynamicInputDevice
DEV dynamicComDevice
DEV BlankDynamicDevice

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
SEND_STRING dvCONSOLE, 'Starting WSHS AMX Automation!'
 
// loop io as its fun
TIMELINE_CREATE(TL_LOOP, lLoopTimes, LENGTH_ARRAY(lLoopTimes), TIMELINE_RELATIVE, TIMELINE_REPEAT);
 
(***********************************************************)
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)
DEFINE_EVENT

//Left Projector serial link
DATA_EVENT[dvCOM1]
{
    online:
    {
	SEND_COMMAND dvCOM1,'SET BAUD 115200,N,8,1'
	SEND_COMMAND dvCOM1, 'HSOFF'
    }
    STRING: {
	STACK_VAR CHAR msg[16]
	
	SEND_STRING dvCONSOLE, "'com1 returned:', msg"
    }
}

//Center Projector serial link
DATA_EVENT[dvCOM2]
{
    online:
    {
	SEND_COMMAND dvCOM2,'SET BAUD 115200,N,8,1'
	SEND_COMMAND dvCOM2, 'HSOFF'
    }
    STRING: {
	STACK_VAR CHAR msg[16]
    
	SEND_STRING dvCONSOLE, "'com2 returned:', msg"
    }
}

//Right Projector serial link
DATA_EVENT[dvCOM3]
{
    online:
    {
	SEND_COMMAND dvCOM3,'SET BAUD 115200,N,8,1'
	SEND_COMMAND dvCOM3, 'HSOFF'
    }
    STRING: {
	STACK_VAR CHAR msg[16]
    
	SEND_STRING dvCONSOLE, "'com3 returned:', msg"
    }
}

// beep dvTP1 on startup 
DATA_EVENT[dvTP1]
{
    ONLINE:
    {
        moderoBeepDouble(dvTP1)
	SEND_STRING dvCONSOLE, 'a TP came Online!'
    }
}

// beep dvTP2 on startup 
DATA_EVENT[dvTP2]
{
    ONLINE:
    {
        moderoBeepDouble(dvTP2)
	SEND_STRING dvCONSOLE, 'a TP came Online!'
    }
}

 BUTTON_EVENT[dvTPMaster, btnAbout]
{
    PUSH:
    {
        TO[BUTTON.INPUT]
     
        SEND_STRING dvCONSOLE, 'TP beep!'
	
	moderoBeepDouble(Button.Input.Device.Number)
    }
}

//reset button
 BUTTON_EVENT[dvTPMaster, btnReset]
{
    PUSH:
    {
        TO[BUTTON.INPUT]
     
        SEND_STRING dvCONSOLE, 'Tp reset!'

    }
}

//projection Buttons
 BUTTON_EVENT[dvTPMaster, 0]
{
    PUSH:
    {
        TO[BUTTON.INPUT]
	ProjectorNumber = 0
	ScreenNumber = 0
	dynamicInputDevice = BlankDynamicDevice
	dynamicComDevice = BlankDynamicDevice
	Pattern = ''
	
	if (fnGetIndex(LeftProjectorButtons, BUTTON.INPUT.CHANNEL) != 0){
	    dynamicInputDevice = dvLeftProjector
	    dynamicComDevice = dvCOM1
	    ProjectorNumber = 1
	    ScreenNumber = 1
	}

	if (fnGetIndex(RightProjectorButtons, BUTTON.INPUT.CHANNEL) != 0){
	    dynamicInputDevice = dvRightProjector
	    dynamicComDevice = dvCOM2
	    ProjectorNumber = 2
	    ScreenNumber = 3
	}

	if (fnGetIndex(CenterProjectorButtons, BUTTON.INPUT.CHANNEL) != 0){
	    dynamicInputDevice = dvCenterProjector
	    dynamicComDevice = dvCOM3
	    ProjectorNumber = 3
	    ScreenNumber = 5
	}

	if (fnGetIndex(BackProjectorButtons, BUTTON.INPUT.CHANNEL) != 0){
	    dynamicInputDevice = dvBackProjector
	    ProjectorNumber = 4
	    ScreenNumber = 10
	}

	if (fnGetIndex(PatternButtons, BUTTON.INPUT.CHANNEL) != 0) {
	    if (fnGetIndex(InputLogoButtons, BUTTON.INPUT.CHANNEL) != 0) {
		Pattern = 'DVX_TEST_PATTERN_LOGO_1'
	    }
	    
	    if (fnGetIndex(XHATCHButtons, BUTTON.INPUT.CHANNEL) != 0) {
		Pattern = 'DVX_TEST_PATTERN_X_HATCH'
	    }
	    
	    if (fnGetIndex(ColorBarButtons, BUTTON.INPUT.CHANNEL) != 0) {
		Pattern = 'DVX_TEST_PATTERN_COLOR_BAR'
	    }
	    
	    if (fnGetIndex(SMPTEBarButtons, BUTTON.INPUT.CHANNEL) != 0) {
		Pattern = ' DVX_TEST_PATTERN_SMPTE_BAR'
	    }
	    
	    if (fnGetIndex(PlungeButtons, BUTTON.INPUT.CHANNEL) != 0) {
		Pattern = 'DVX_TEST_PATTERN_PLUGE'
	    }
	    
	    if (fnGetIndex(HILOTrackButtons, BUTTON.INPUT.CHANNEL) != 0) {
		Pattern = 'DVX_TEST_PATTERN_HILO_TRACK'
	    }
	    
	    
	    dvxSetVideoOutputTestPattern(dynamicInputDevice, Pattern)
	}

	if (fnGetIndex(InputButtons, BUTTON.INPUT.CHANNEL) != 0 && ProjectorNumber != 0){
	    if (fnGetIndex(DVDButtons, BUTTON.INPUT.CHANNEL) != 0) {
		VidInput = 1
		    
		SEND_STRING dvCONSOLE, "' DVDButtons '"
	    }
		
	    if (fnGetIndex(VHSButtons, BUTTON.INPUT.CHANNEL) != 0) {
		VidInput = 2
		    
		SEND_STRING dvCONSOLE, "' VHSButtons '"
	    }
		
	    if (fnGetIndex(SoundBoardHdmiButtons, BUTTON.INPUT.CHANNEL) != 0) {
		VidInput = 5
		    
		SEND_STRING dvCONSOLE, "' SoundBoardHdmiButtons '"
	    }
		
	    if (fnGetIndex(LeftPodiumHdmiButtons, BUTTON.INPUT.CHANNEL) != 0) {
		VidInput = 6
		    
		SEND_STRING dvCONSOLE, "' LeftPodiumHdmiButtons '"
	    }
		
	    if (fnGetIndex(RightPodiumHdmiButtons, BUTTON.INPUT.CHANNEL) != 0) {
		VidInput = 7
		    
		SEND_STRING dvCONSOLE, "' RightPodiumHdmiButtons '"
	    }
		
	    if (fnGetIndex(NestHdmi1Buttons, BUTTON.INPUT.CHANNEL) != 0) {
		VidInput = 8
		    
		SEND_STRING dvCONSOLE, "' NestHdmi1Buttons '"
	    }
		
	    dvxSwitchVideoOnly(dvDVXSW, VidInput, ProjectorNumber)
	    dvxSetVideoOutputTestPattern(dynamicInputDevice, "DVX_TEST_PATTERN_OFF")
	}
	
	if (fnGetIndex(ProjectorScreenButtons, BUTTON.INPUT.CHANNEL) != 0 && ScreenNumber != 0){
	    if (ScreenNumber == 10) {
		if (fnGetIndex(ProjectorScreenUpButtons, BUTTON.INPUT.CHANNEL) != 0) {
		    PULSE[dvRELAY, 2]
		    PULSE[dvRELAY, 4]
		    PULSE[dvRELAY, 6]
		    
		    SEND_STRING dvCONSOLE, "' All Screens Up '"
		}else{
		    PULSE[dvRELAY, 1]
		    PULSE[dvRELAY, 3]
		    PULSE[dvRELAY, 5]
		    
		    SEND_STRING dvCONSOLE, "' All Screens Down '"
		}
	    }else{
		if (fnGetIndex(ProjectorScreenDownButtons, BUTTON.INPUT.CHANNEL) != 0) {
		    ScreenNumber = ScreenNumber + 1
		}
		
		PULSE[dvRELAY, ScreenNumber]
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