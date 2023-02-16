/*------------------------------------------------------------------------------------------
Name: Le_Tourneau_SHIVA_Figure1.do
--------------------------------------------------------------------------------------------
Description: Figure 1 (Kaplan-Meier plot) do-file for SHIVA Trial

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
		PART 2: Create Kaplan-Meier plot
		PART 3: Save figure as a separate image
--------------------------------------------------------------------------------
Authors: 				Anurika De Silva, 
                        <anurika.de@unimelb.edu.au>, 
						The University of Melbourne	
--------------------------------------------------------------------------------
Last date modified: 10/02/2023
------------------------------------------------------------------------------*/

*------------------------------------------------------------------------------*/
cap log close
clear
set more off
*------------------------------------------------------------------------------*/

cd "$analysisdatafolder"
log using Le_Tourneau_SHIVA_Figure1.log, replace

/*------------------------------------------------------------------------------------------
PART 1: Load analysis data
------------------------------------------------------------------------------------------*/

use "$analysisdata", clear

/*------------------------------------------------------------------------------------------
PART 2: Create Kaplan-Meier plot
------------------------------------------------------------------------------------------*/

stset years, failure(progStatus)

sts graph, by(brasf_string) risktable (, size(small) title(,size(small))) ///
					title("") xtitle("Years from randomisation",size(small)) ytitle("Progression-free survival (%)",size(small)) ///
					ylab(0 "0" .25 "25" .5 "50" .75 "75" 1 "100") ///
					legend (label(1 "CT") label(2 "MTA") size(small) region(lcolor(white)) position(6) rows(1)) ///
					xlabel(,labsize(small)) ylabel(,labsize(small) angle(horizontal)) ///
					plot1(lcolor(blue) lpattern(solid)) plot2(lcolor(red) lpattern(solid)) graphregion(color(white))

/*------------------------------------------------------------------------------------------
PART 3: Save figure as a separate image
------------------------------------------------------------------------------------------*/

graph export "$outputfolder\interaction.png", replace

log close
exit
