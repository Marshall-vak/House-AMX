PROGRAM_NAME='console'

// Check if the file has been called before
#if_not_defined __CONSOLE__
#define __CONSOLE__

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT 

// Log levels
INTEGER CONSOLE_OFF = 0
INTEGER CONSOLE_ERROR = 1
INTEGER CONSOLE_WARNING = 2
INTEGER	CONSOLE_INFO = 3
INTEGER CONSOLE_DEBUG = 4 

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE 

// Store the LogLevel across reboots and default to Debug on program upload
NON_VOLATILE LogLevel = 4

// Make a string out of a number
DEFINE_FUNCTION CHAR[7] GetLevelChar(INTEGER LevelOfLog)
{
    SWITCH (LevelOfLog)
    {
	CASE CONSOLE_ERROR: {
	    return 'Error'
	}
	
	CASE CONSOLE_WARNING: {
	    return 'Warning'
	}
	
	CASE CONSOLE_INFO: {
	    return 'Info'
	}
	
	DEFAULT: {
	    return 'Debug'
	}
    }
}

DEFINE_FUNCTION print(CHAR data[], INTEGER LevelOfLog)
{
    // If the messages log level is greater than the system log level then stop
    if(LogLevel < LevelOfLog) return
    
    // Log to the console Example: [Debug] Text in the debug
    SEND_STRING 0, "'[', GetLevelChar(LevelOfLog), '] ', data"
    
    // Send a debug spew to com 6
    SEND_STRING 5001:6:0, "'[', GetLevelChar(LevelOfLog), '] ', data, $0D, $0A"
}

// Return the current log level
DEFINE_FUNCTION INTEGER GetLogLevel()
{
    return LogLevel
}

// Set the current log level to the new level then return it
DEFINE_FUNCTION INTEGER SetLogLevel(INTEGER LevelOfLog)
{
    LogLevel = LevelOfLog
    
    return LogLevel
}

// Turn a device number into a string that is able to be logged
DEFINE_FUNCTION CHAR[17] devToString(dev device) {
    return "ITOA(device.number), ':', ITOA(device.port), ':', ITOA(device.system)"
}

#end_if