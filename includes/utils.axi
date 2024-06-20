PROGRAM_NAME='utils'

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

// Function to check if a channel is active or not
DEFINE_FUNCTION INTEGER channelGet(dev device, integer chan)
{
    // Return true if the device channel is active
    return [device, chan]
}

// Function to check if a file is in an array
DEFINE_FUNCTION INTEGER fnGetIndex(INTEGER nArray[], INTEGER nValue)
{

    // For use in for loops
    INTEGER x
   
    // For everything in the array
    FOR (x=1; x<=LENGTH_ARRAY(nArray); x++) {
	// If the array entry matches what we are looking for then return its position
	IF (nArray[x] = nValue) RETURN x
    }

    // If we didn't find what we are looking for return 0
    RETURN 0

}