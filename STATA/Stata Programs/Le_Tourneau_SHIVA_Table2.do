/*------------------------------------------------------------------------------------------
Name: Le_Tourneau_SHIVA_Table2.do
--------------------------------------------------------------------------------------------
Description: Table 2 (Efficacy table) do-file for SHIVA Trial

Molecularly targeted therapy based on tumour molecular profiling versus conventional therapy 
for advanced cancer (SHIVA): a multicentre, open-label, proof-of-concept, randomised, 
controlled phase 2 trial.
--------------------------------------------------------------------------------------------
Date created: 09/02/2023
--------------------------------------------------------------------------------------------				
Contacts:

Principal Investigator: XXX 
                        <XXX>, XXX
						 
Study statistician: 	XXX
                        <XXX>, XXX				   
--------------------------------------------------------------------------------
Outline:    

		PART 1: Load analysis data
		PART 2: Create efficacy table
		PART 3: Save efficacy table to report or as a separate word document
--------------------------------------------------------------------------------
Authors: 				Anurika De Silva, 
                        <anurika.de@unimelb.edu.au>, 
						The University of Melbourne	
--------------------------------------------------------------------------------
Last date modified: 10/02/2023
------------------------------------------------------------------------------*/

*------------------------------------------------------------------------------*/
cap log close
putdocx clear
clear
set more off
*------------------------------------------------------------------------------*/

cd "$analysisdatafolder"
log using Le_Tourneau_SHIVA_Table2.log, replace

/*------------------------------------------------------------------------------------------
PART 1: Load analysis data
------------------------------------------------------------------------------------------*/

use "$analysisdata", clear

/*------------------------------------------------------------------------------------------
PART 2: Create efficacy table
------------------------------------------------------------------------------------------*/

tempname char
tempfile char_file
postfile `char' str45(var) estimate lcl ucl pvalue using `char_file', replace

	stset years, failure(progStatus)
	stcox i.brasf

	matrix estimates=r(table)
	matrix list estimates
	local estimate=estimates[1,2]
	local pvalue=estimates[4,2]
	local lcl=estimates[5,2]
	local ucl=estimates[6,2]

post `char' ("`var_lbl'") (`estimate') (`lcl') (`ucl') (`pvalue')

postclose `char'

use `char_file', clear

gen Estimate = string(estimate,"%3.2f") + " (" + string(lcl,"%3.2f") + "," + string(ucl,"%3.2f") + ")"

gen Pvalue = string(pvalue,"%4.3f")
replace Pvalue = "<0.001" if Pvalue=="0.000"

/*------------------------------------------------------------------------------------------
PART 3: Save efficacy table to report or as a separate word document
------------------------------------------------------------------------------------------*/

putdocx begin

	putdocx table table2 = (4,3), title("Table 2: Effect of treatment for progression-free survival") ///
			border(all, nil) layout(autofitcontents) note("HR = Hazard Ratio, CI = Confidence Interval")

	putdocx table table2(2,1) = ("Characteristic")
	putdocx table table2(2,2) = ("HR (95% CI)")
	putdocx table table2(2,3) = ("p-value")

	putdocx table table2(3,1) = ("Treatment")
	putdocx table table2(4,1) = ("	Treatment at physician's choice group")
	putdocx table table2(5,1) = ("	Molecularly targeted agent group")

	putdocx table table2(4,2) = ("Ref.")

	local table2_52 = Estimate[1]
	di "`table2_52'"
	putdocx table table2(5,2) = ("`table2_52'")

	local table2_53 = Pvalue[1]
	di "`table2_53'"
	putdocx table table2(5,3) = ("`table2_53'")

	putdocx table table2(1/2,.), bold 
	putdocx table table2(1,.), font("Calibri", 12)

	putdocx table table2(2,.), border("top")
	putdocx table table2(3,.), border("top")
	putdocx table table2(5,.), border("bottom")

*putdocx save "$outputfolder\Table 2", replace								// To save as a separate document

putdocx save "$report", append												// To include in the trial report

log close
exit
