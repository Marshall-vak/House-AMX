// dvTPMaster is a array of all the touch pannels indexing this file
// dvDVXSW is the internal switcher device for the dvx
// dvDgxCOM is the com port that will be used to control the dgx
MODULE_NAME='DXX Switcher' (DEV dvTPMaster, DEV dvDVXSW, DEV dvDgxCOM)

#include 'amx-modero-control'
#include 'amx-dvx-control'
#include 'console'
#include 'utils'
   
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

// Master Controller
dvCONSOLE = 0:1:0

// Internal audio/video switcher connection
dvSW = 5002:1:0

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

//Output Select Buttons
INTEGER OutputButtons[] = { 11, 12, 13, 14 }
//Physical Output Numbers (IN ORDER)
INTEGER PhysicalOutputNumbers[] = { 2, 1, 3, 4 }

//Input Select Buttons
INTEGER InputButtons[] = { 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 }
//Physical input Numbers (IN ORDER)
INTEGER PhysicalInputNumbers[] = { 6, 10, 5, 7, 1, 2, 8, 9, 3, 4 }

//Input / Output Master
INTEGER InputOutputMaster[] = { 11, 12, 13, 14, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30 }

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE
// Console command for use in dvCom1 commands to the dgx
ComCommand[40] = ''

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

// Example Command: CL0I16O5 6 7T
// Example Concept: CL0(Change)I(INPUT)16O(Output)5 6 7T(Take [Apply])
// Example Code: CL0I + input number + O + output numbers + T
DEFINE_FUNCTION INTEGER fnCalculateComCommand(dev dvTP)
{
    
    // For use in for loops
    INTEGER x
    
    // Start With Change Input
    ComCommand = 'CL0I'
    
    // For every input button
    for (x=1; x<=LENGTH_ARRAY(InputButtons); x++) {
	// If the input button is active
	if (channelGet(dvTP, InputButtons[x])){
	    // Add the input input number to the command
	    ComCommand = "ComCommand, ITOA(PhysicalInputNumbers[x])"
	}
    }
    
    // Add O to signify we are about to pass output numbers in
    ComCommand = "ComCommand, 'O'"
    
    // For every output button
    for (x=1; x<=LENGTH_ARRAY(OutputButtons); x++) {
	// If the output button is pressed
	if (channelGet(dvTP, OutputButtons[x])){
	    // If it is the first output in the command
	    if (ComCommand[LENGTH_ARRAY(ComCommand)] == 'O'){
		// Add the output number to the command
		ComCommand = "ComCommand, ITOA(PhysicalOutputNumbers[x])"
	    } else {
		// If it is not the first output in the command add a comma before adding the command
		ComCommand = "ComCommand, ' ', ITOA(PhysicalOutputNumbers[x])"
	    }
	}
    }
    
    // Add a T so tell the switcher to Take (apply the changes)
    ComCommand = "ComCommand, 'T'"
    
    // Debug Log the Calculated command
    print("'Calculated ComCommand: ', ComCommand", CONSOLE_DEBUG);
    
    // If the command failed to generate then return 0 to signify an error
    if (ComCommand == 'CL0IOT') return false
    
    // No error... Yay Continue!
    return ComCommand
}

DEFINE_FUNCTION INTEGER fnDgxSwitchVideo(dev dvTP, dev dvCom)
{
    /*
    // Calculate the com command based on the pressed touch panel buttons
    INTEGER ComCommand[40] = fnCalculateComCommand(dvTP)
    
    // If there was no error generating the command then send it through the com
    if (ComCommand){
	SEND_COMMAND dvCom, "ComCommand"
	
	return
    }
    */
    
    // This will do untill I can find the proper way to do this
    SEND_COMMAND dvCom, "fnCalculateComCommand(dvTP)"
    
    // If there was an error log it
    //print("'Failed to generate ComCommand!'", CONSOLE_ERROR)
}

DEFINE_FUNCTION INTEGER fnDvxSwitchVideo(dev dvTP)
{
    
    // For use in for loops
    INTEGER x
    INTEGER VidInput
    INTEGER Switched
    INTEGER VidOutputs[4]

    // Reset variables
    VidInput = 0
    Switched = 0
    
    /*
    
    REVEW IF NEEDED
    
    // For every video output
    for (x=1; x<=LENGTH_ARRAY(VidOutputs); x++) {
	// Set starting false switch
	VidOutputs[x] = 0
    }
    */
    
    print("'Switching DVX Video'", CONSOLE_DEBUG)
    
    // For every input button
    for (x=1; x<=LENGTH_ARRAY(InputButtons); x++) {
	// If the input button is active
	if (channelGet(dvTP, InputButtons[x])){
	    // Set the video input variable to the physical input number
	    VidInput = PhysicalInputNumbers[x]
	}
    }
    
    // Debug Log
    print("'Switching Input: ', ITOA(VidInput)", CONSOLE_DEBUG)
    
    // For every output button
    for (x=1; x<=LENGTH_ARRAY(OutputButtons); x++) {
	// If the output button is pressed
	if (channelGet(dvTP, OutputButtons[x])){
	    // Add the output button to the array
	    VidOutputs[x] = PhysicalOutputNumbers[x]
	}else{
	    // If it isnt pressed then set the value to 0 (false)
	    VidOutputs[x] = 0
	}
    }
    
    // Debug log
    print("'Switching Output: ', ITOA(VidOutputs[1]), ', ', ITOA(VidOutputs[2]), ', ', ITOA(VidOutputs[3]), ', ', ITOA(VidOutputs[4])", CONSOLE_DEBUG)
    
    // If there is nothing passed there is an error stop the program
    if (VidInput == 0){
	print("'An Error Occured while switching the video: No input selected!'", CONSOLE_ERROR)
	return 0
    }
    
    // For every output
    //LENGTH_ARRAY(VidOutputs) this doesnt work for some reason I really dont want to find out why
    for (x=1; x<=4; x++) {
	// If the output is set to switch
	if (VidOutputs[x] != 0){
	    // Debug Log
	    print("'Switching Output: ', ITOA(VidOutputs[x]), ' to input ', ITOA(VidInput)", CONSOLE_DEBUG)
	    
	    // Switch the video
	    dvxSwitchVideoOnly(dvDVXSW, VidInput, VidOutputs[x])
	    
	    // Mark that the switcher did indeed switch
	    Switched = 1
	}
    }

    // If the switcher switched
    if (Switched){
	print("'Switched Video Without Error'", CONSOLE_DEBUG)
	
	// No error... Continue!
	return 1
    } else {
	print("'An Error Occured while switching the video: No Output to switch!'", CONSOLE_ERROR)
	
	// Error... crap
	return 0
    }
}

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START

// Yay
print("'Starting DXX Switcher!'", CONSOLE_INFO);

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

//for connection to the dgx
DATA_EVENT[dvDgxCOM]
{
    ONLINE: {
	// Set the baud rate to 9600kbps default in most terminal software
	SEND_COMMAND dvDgxCOM,'SET BAUD 9600,N,8,1'
	
	// Turn off Hardware Handshaking (https://help.harmanpro.com/361-troubleshooting-steps-for-rs232-control [Yes I archived it])
	SEND_COMMAND dvDgxCOM, 'HSOFF'
    }
    
    STRING: {
	STACK_VAR CHAR msg[16]
	
	// Debug Log mesages returned from the com bus
	print("'dvDgxCOM returned:', msg", CONSOLE_DEBUG)
    }
}
    

BUTTON_EVENT[dvTPMaster, 0]
 {
    PUSH:
    {
	if (fnGetIndex(InputOutputMaster, BUTTON.INPUT.CHANNEL) != 0){
	    if (fnGetIndex(OutputButtons, BUTTON.INPUT.CHANNEL) != 0){
		print("'Button Pressed Adressing Output Selection: '", CONSOLE_DEBUG);
		
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
		print("'Button Pressed Adressing Input Selection'", CONSOLE_DEBUG);
		    
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
}

(*****************************************************************)
(*                                                               *)
(*                      !!!! WARNING !!!!                        *)
(*                                                               *)
(* Due to differences in the underlying architecture of the      *)
(* X-Series masters, changing variables in the DEFINE_PROGRAM    *)
(* section of code can negatively impact program performance.    *)
(*                                                               *)
(* See “Differences in DEFINE_PROGRAM Program Execution” section *)
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
