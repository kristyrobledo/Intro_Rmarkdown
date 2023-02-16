/*------------------------------------------------------------------------------------------
Name: Le_Tourneau_SHIVA_Data.do
--------------------------------------------------------------------------------------------
Description: Data preparation do-file for SHIVA Trial

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
--------------------------------------------------------------------------------------------
Outline:    

		PART 1: Load source data
		PART 2: Derive new variables required for analysis
		PART 3: Add variable labels and value labels as needed
		PART 4: Save data in Analysis Data folder
-------------------------------------------------------------------------------------------
Authors: 				Anurika De Silva, 
                        <anurika.de@unimelb.edu.au>, 
						The University of Melbourne	
-------------------------------------------------------------------------------------------
Last date modified: 10/02/2023
-----------------------------------------------------------------------------------------*/

*----------------------------------------------------------------------------------------*/
cap log close
clear
set more off
*----------------------------------------------------------------------------------------*/

cd "$sourcedatafolder"
log using Le_Tourneau_SHIVA_Data.log, replace

/*------------------------------------------------------------------------------------------
PART 1: Load source data
------------------------------------------------------------------------------------------*/

import excel using "$sourcedata", firstrow clear

/*------------------------------------------------------------------------------------------
PART 2: Derive variables required for analysis
------------------------------------------------------------------------------------------*/

* Derive variable for years corresponding to survival status
gen double study_start = date("01-01-2012", "DMY")
format study_start %td

gen double study_end = progDate if progStatus==1
replace study_end = date("01-01-2016", "DMY") if study_end==.
format study_end %td

gen years = (study_end - study_start)/365.25

/*------------------------------------------------------------------------------------------
PART 3: Add variable labels and value labels as needed
------------------------------------------------------------------------------------------*/

* Recode treatment variable (brasf) 
rename brasf brasf_string
encode brasf_string, gen(brasf)
recode brasf (2=1) (1=0)
label define brasflbl 0 "CT" 1 "MTA", replace
label value brasf brasflbl

/*------------------------------------------------------------------------------------------
PART 4: Save data in Analysis Data folder
------------------------------------------------------------------------------------------*/

save "$analysisdata", replace

log close
exit



