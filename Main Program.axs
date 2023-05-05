PROGRAM_NAME='Main Program'

#include 'amx-dvx-control'
#include 'amx-modero-control'
#include 'debug'

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

//test button

//touch pannels
DEV dvTPMaster[] = { dvTP1, dvTP2 }

//dynamic vars

//dynamic device

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
print("'Starting WSHS AMX Automation!'",false);
 
// loop io as its fun
TIMELINE_CREATE(TL_LOOP, lLoopTimes, LENGTH_ARRAY(lLoopTimes), TIMELINE_RELATIVE, TIMELINE_REPEAT);
 
(***********************************************************)
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)
DEFINE_EVENT


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

//projection Buttons
 BUTTON_EVENT[dvTPMaster, 0]
{
    PUSH:
    {
        TO[BUTTON.INPUT]
	
	
	
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