/*------------------------------------------------------------------------------------------
Name: Le_Tourneau_SHIVA_Master.do
--------------------------------------------------------------------------------------------
Description: Master do-file for SHIVA Trial

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

		PART 1: Standardize settings and install packages
        PART 2: Set globals for file paths
		PART 3: Call the task-specific master do-files that call all do-files needed 
				for that task
--------------------------------------------------------------------------------------------
Authors: 				Anurika De Silva, 
                        <anurika.de@unimelb.edu.au>, 
						The University of Melbourne	
--------------------------------------------------------------------------------------------
Last date modified: 10/02/2023
------------------------------------------------------------------------------------------*/

*-----------------------------------------------------------------------------------------*/
cap log close
putdocx clear
clear
set more off
*-----------------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------------------
PART 1: Standardize settings and install packages
------------------------------------------------------------------------------------------*/

/*------------------------------------------------------------------------------------------
Install required packages
------------------------------------------------------------------------------------------*/

local user_commands table1_mc       						 	//Fill this list with all user-written commands this project requires
   foreach command of local user_commands {
       cap which `command'
       if _rc == 111 {
           ssc install `command'
       }
   }
   
*Packages for figure settings
net install gr0002_3, from(http://www.stata-journal.com/software/sj4-3)
   
/*------------------------------------------------------------------------------------------
Standardize settings across users
------------------------------------------------------------------------------------------*/ 

*Version settings
version 17.0        												//Set the version number to the oldest version used by anyone in the project team

*Figure settings
set scheme lean2

/*------------------------------------------------------------------------------------------
PART 2: Set globals for file paths
------------------------------------------------------------------------------------------*/

global directory 				"C:\Users\anurikad1\Dropbox\Le Tourneau_SHIVA\2. Data_Analysis_and_Reporting"      //Set global directory

global sourcedatafolder         "$directory/2. Source_Data"

global analysisdatafolder       "$directory/3. Analysis_Data"

global programsfolder           "$directory/4. Programs"

global outputfolder             "$directory/5. Output"

global reportfolder         	"$directory/7. Report"

global sourcedata 				"$sourcedatafolder/SHIdat.xlsx"

global analysisdata 			"$analysisdatafolder/Le_Tourneau_SHIVA_analysisdata.dta"

global report 					"$reportfolder/Report1.docx"

/*------------------------------------------------------------------------------------------
PART 3: Call the task-specific master do-files that call all do-files needed for that task
------------------------------------------------------------------------------------------*/

do "$programsfolder\Le_Tourneau_SHIVA_Data.do"           //Data preparation

do "$programsfolder\Le_Tourneau_SHIVA_Report1.do"		 //Create Report 1 

exit
 