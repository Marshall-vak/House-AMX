PROGRAM_NAME='Main, DvxSwitcherDashboard, Rev 0'
(***********************************************************)
(*  FILE CREATED ON: 10/13/2020  AT: 09:24:55              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 11/12/2020  AT: 08:18:30        *)
(***********************************************************)
(*  FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 10/30/2020  AT: 08:27:41                *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)

(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

dvSwitcher_1	= 5002:1:0; // Must be DVX device for module to instantiate - coded into the stub

vdvSwitcher	= 41001:1:0;


(***********************************************************)
(*                MODULE DEFINITIONS GO BELOW              *)
(***********************************************************)
DEFINE_MODULE 
    'DvxSwitcherDashboard_dr1_0_0' DvxSwitcherDashboard_dr1_0_0(vdvSwitcher, dvSwitcher_1);


(***********************************************************)
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)
DEFINE_EVENT

data_event[vdvSwitcher]
{
    online: 
    {
	send_command data.device,'DEBUG-1';
	
	(***********************************************************)
	(*                UI customization options                 *)
	(***********************************************************)
	// Override reported DVX matrix size
//	send_command data.device,'PROPERTY-INPUT.COUNT,4';
//	send_command data.device,'PROPERTY-OUTPUT.COUNT,2';

	// Remove reported DVX Components
//	send_command data.device,'PROPERTY-Has-microphones,false';
    }
}
