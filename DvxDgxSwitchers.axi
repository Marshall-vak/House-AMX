PROGRAM_NAME='DvxDgxSwitchers'

#include 'amx-dvx-control'

#if_not_defined __DvxDgxSwitchers__
#define __DvxDgxSwitchers__

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

DEFINE_FUNCTION INTEGER channelGet(dev device, integer chan)
{

    // Return true if the device channel is active
    return [device, chan]
    
}

// Example Command: CL0I16O5 6 7T
// Example Concept: CL0(Change)I(INPUT)16O(Output)5 6 7T(Take [Apply])
// Example Code: CL0I + input number + O + output numbers + T
DEFINE_FUNCTION INTEGER fnCalculateComCommand(dev dvTP)
{
    
    // For use in for loops
    INTEGER x
    
    // Console command for use in dvCom1 commands to the dgx
    INTEGER ComCommand[40] = ''

    
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
    print("'Calculated ComCommand: ', ComCommand", false);
    
    // If the command failed to generate then return 0 to signify an error
    if (ComCommand == 'CL0IOT') return false
    
    // No error... Yay Continue!
    return ComCommand
}

DEFINE_FUNCTION INTEGER fnDvxSwitchVideo(dev dvTP, dev dvCom)
{
    // Calculate the com command based on the pressed touch panel buttons
    INTEGER ComCommand[40] = fnCalculateComCommand(dvTP)
    
    // If there was no error generating the command then send it through the com
    if (ComCommand){
	SEND_COMMAND dvCom, "fnCalculateComCommand(dvTP)"
    }
    
    // If there was an error log it
    print("'Failed to generate ComCommand!'", false)
}

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