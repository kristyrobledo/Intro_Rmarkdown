/*------------------------------------------------------------------------------------------
Name: Le_Tourneau_SHIVA_Table1.do
--------------------------------------------------------------------------------------------
Description: Table 1 (Baseline table) do-file for SHIVA Trial

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
		PART 2: Create baseline table
		PART 3: Modify the table as required
		PART 4: Save baseline table to report or as a separate word document
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
log using Le_Tourneau_SHIVA_Table1.log, replace

/*------------------------------------------------------------------------------------------
PART 1: Load analysis data
------------------------------------------------------------------------------------------*/

use "$analysisdata", clear

/*------------------------------------------------------------------------------------------
PART 2: Create baseline table
------------------------------------------------------------------------------------------*/

table1_mc, by(brasf) total(after) vars(sexf cat %2.1f\ agerand contn %2.1f\ ///
				pathwayf cat %2.1f\ tt_Lnum conts %2.1f) onecol nospace extraspace clear
				
/*------------------------------------------------------------------------------------------
PART 3: Modify the table as required
------------------------------------------------------------------------------------------*/

keep factor brasf_0 brasf_1 brasf_T

replace factor = "Sex, n (%)" if _n==3					

/*------------------------------------------------------------------------------------------
PART 4: Save baseline table to report or as a separate word document
------------------------------------------------------------------------------------------*/

table1_mc_dta2docx using "$outputfolder\Table 1", replace

/*------------------------------------------------------------------------------------------
Alternate method
------------------------------------------------------------------------------------------*/
use "$analysisdata", clear

table1_mc, by(brasf) total(after) vars(sexf cat %2.1f\ agerand contn %2.1f\ ///
				pathwayf cat %2.1f\ tt_Lnum conts %2.1f) onecol nospace extraspace clear
				
keep factor brasf_0 brasf_1 brasf_T

putdocx begin

	putdocx table table1 = (11,4), title("Table 1: Baseline characteristics") ///
			border(all, nil) layout(autofitcontents) ///
			note("CT = Treatment at physician's choice group, IQR = Interquartile range, MTA = Molecularly targeted agent group, SD = Standard deviation")
	
	local i = 2
	local j = 1
	
	foreach var of varlist factor brasf_0 brasf_1 brasf_T {
		
		forvalues i = 2(1)12 {
			
			local table1_`i'`j' = `var'[`i'-1]
			
			putdocx table table1(`i',`j') = ("`table1_`i'`j''")

		}
		
		local j = `j' + 1 
	}
	
	putdocx table table1(4,1) = ("Sex, n (%)")
	putdocx table table1(7,1) = ("Age (years), mean (SD)")
	putdocx table table1(8,1) = ("Molecular pathway altered, n (%)")
	putdocx table table1(9,1) = ("   Hormone receptor pathway")
	putdocx table table1(10,1) = ("   RAF/MEK pathway")
	putdocx table table1(11,1) = ("	  PI3K/AKT/mTOR pathway")
	putdocx table table1(12,1) = ("Previous lines of treatment, median (IQR)")
	
	putdocx table table1(1/3,.), bold 
	putdocx table table1(1,.), font("Calibri", 12)

	putdocx table table1(2,.), border("top")
	putdocx table table1(4,.), border("top")
	putdocx table table1(12,.), border("bottom")
			
*putdocx save "$outputfolder\Table 1", replace								// To save as a separate document

putdocx save "$report", append												// To include in the trial report

log close
exit