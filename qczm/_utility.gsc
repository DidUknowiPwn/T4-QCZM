waitframe()
{
	wait 0.05;
}

/*
=============
///ScriptDocBegin
"Name: ter_op( <statement> , <true_value> , <false_value> )"
"Summary: Functon that serves as a tertiary operator in C/C++"
"Module: Utility"
"CallOn: "
"MandatoryArg: <statement>: The statement to evaluate"
"MandatoryArg: <true_value>: The value that is returned when the statement evaluates to true"
"MandatoryArg: <false_value>: That value that is returned when the statement evaluates to false"
"Example: x = ter_op( x > 5, 2, 7 );"
"SPMP: both"
///ScriptDocEnd
=============
*/
ter_op( statement, true_value, false_value )
{
	if ( statement )
		return true_value;
	return false_value;
}


set_dvar_if_unset(
	dvar,
	value,
	reset)
{
	if (!IsDefined(reset))
		reset = false;

	if (reset || GetDvar(dvar)=="")
	{
		SetDvar(dvar, value);
		return value;
	}
	
	return GetDvar(dvar);
}

set_dvar_float_if_unset(
	dvar,
	value,
	reset)
{
	if (!IsDefined(reset))
		reset = false;

	if (reset || GetDvar(dvar)=="")
	{
		SetDvar(dvar, value);
	}
	
	return GetDvarFloat(dvar);
}

set_dvar_int_if_unset(
	dvar,
	value,
	reset)
{
	if (!IsDefined(reset))
		reset = false;

	if (reset || GetDvar(dvar)=="")
	{
		SetDvar(dvar, value);
		return int(value);
	}
	
	return GetDvarInt(dvar);
}

playSoundInSpace (alias, origin, master)
{
	org = spawn ( "script_origin",(0,0,1) );
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	if (isdefined(master) && master)
		org playsoundasmaster (alias);
	else
		org playsound (alias);
	wait ( 10.0 );
	org delete();
}

/*
"Name: is_true(<check>)"
"Summary: For boolean checks when undefined should mean 'false'."
"Module: Utility"
"MandatoryArg: <check> : The boolean value you want to check."
"Example: if ( is_true( self.is_linked ) ) { //do stuff }"
"SPMP: both"
*/
is_true(check)
{
	return(IsDefined(check) && check);
}

/*
"Name: is_false(<check>)"
"Summary: For boolean checks when undefined should mean 'true'."
"Module: Utility"
"MandatoryArg: <check> : The boolean value you want to check."
"Example: if ( is_false( self.is_linked ) ) { //do stuff }"
"SPMP: both"
*/
is_false(check)
{
	return(IsDefined(check) && !check);
}

GetPlayerTeam()
{
	return self.pers["team"]
}
