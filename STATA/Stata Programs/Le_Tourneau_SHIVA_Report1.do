/*------------------------------------------------------------------------------------------
Name: Le_Tourneau_SHIVA_Report1.do
--------------------------------------------------------------------------------------------
Description: Report 1 do-file for SHIVA Trial

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

		PART 1: Create report
		PART 2: Title page
		PART 3: Placeholder for Table of contents, List of figures and List of tables
		PART 4: Introduction
		PART 5: Table 1 - Baseline Table
		PART 6: Results
		PART 7: Figure 1 - Kaplan-Meier plot
		PART 8: Table 2 - Efficacy Table
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
log using Le_Tourneau_SHIVA_Report1.log, replace

/*------------------------------------------------------------------------------------------
PART 1: Create report
------------------------------------------------------------------------------------------*/

	* Create a document with a header
	putdocx begin, header(head) footer(foot) pagesize(A4)

	* Define the header content
	putdocx paragraph, toheader(head) font(,11)
	putdocx text ("Clinical trial report")

	* Define the footer content, and include page numbers
	putdocx paragraph, tofooter(foot) font(,11) halign(center)
	putdocx pagenumber
	
	putdocx save "$report", replace

/*------------------------------------------------------------------------------------------
PART 2: Title page
------------------------------------------------------------------------------------------*/
	
	putdocx begin
	
	* Add some white space before the title
	putdocx textblock begin
	putdocx textblock end

	* Add a title
	putdocx paragraph, style(Title) halign(center) font("Calibri", 36)
	putdocx text ("Statistical Report for the EXAMPLE trial")

	* Add a subtitle
	putdocx paragraph, style(Subtitle) halign(center) font("Calibri", 16, black) 
	putdocx text ("Dr Anurika De Silva"), linebreak(4)
	
	* Add other information
	putdocx paragraph, halign(center) font("Calibri", 12)
	putdocx text ("Last compiled on 10 February 2023")
	
	putdocx save "$report", append
	
/*------------------------------------------------------------------------------------------
PART 3: Placeholder for Table of contents, List of figures and List of tables
------------------------------------------------------------------------------------------*/

	putdocx begin	
	
	*Add page break
	putdocx pagebreak
	
	* Add placeholder for Table of contents
	putdocx paragraph
	putdocx text ("Placeholder for table of contents - remove text after inserting"), font(, ,red) linebreak(5)
	 
	* Add placeholder for List of figures
	putdocx paragraph, style (Heading2)
	putdocx text ("1.1 List of figures"), linebreak(5)
	
	* Add placeholder for List of tables
	putdocx paragraph, style (Heading2)
	putdocx text ("1.2 List of tables"), linebreak(5)
	
	putdocx save "$report", append
	
/*------------------------------------------------------------------------------------------
PART 4: Introduction
------------------------------------------------------------------------------------------*/

	putdocx begin	
	
	*Add page break
	putdocx pagebreak
	
	* Add section heading
	putdocx paragraph, style(Heading1)
	putdocx text ("2. Introduction")
	
	* Write paragraph
	putdocx textblock begin, halign(justified)
Normal cells become cancer cells via a succession of genomic alterations. This finding has led to the development of molecularly targeted agents that inhibit the proteins that are abnormally activated as a result of somatic genetic alterations. Theoretically, these agents are more specific to cancer cells than are cytotoxic agents that target cell replication. Some of these molecularly targeted agents have yielded previously unprecedented anti-tumour activity in specific tumour types in the presence of the matching molecular alteration. Molecularly targeted agents have followed the same clinical development process as cytotoxic agents: per tumour location and histology. Most genetic molecular alterations exist across tumour types and histologies, although incidence varies. This observation challenges the existing drug development strategies for molecularly targeted agents and raises the possibility of a shift towards histology-agnostic molecularly based treatment with these drugs.
	putdocx textblock end
	
	putdocx save "$report", append
	
/*------------------------------------------------------------------------------------------
PART 5: Table 1 - Baseline Table
------------------------------------------------------------------------------------------*/

	putdocx begin	
	
	* Add section heading
	putdocx paragraph, style(Heading1)
	putdocx text ("3. Baseline characteristics")
	
	putdocx save "$report", append

	do "$programsfolder\Le_Tourneau_SHIVA_Table1.do"
	
/*------------------------------------------------------------------------------------------
PART 6: Results
------------------------------------------------------------------------------------------*/

	putdocx begin	
	
	* Add section heading
	putdocx paragraph, style(Heading1)
	putdocx text ("4. Results")
	
	*Extract summary statistics required for the Results section
	use "$analysisdata", clear
	
	*Number of participants
	count
	local n = r(N)
	
	*Mean (SD) for age
	sum agerand
	local age_mean = round(r(mean),0.1)
	local age_sd = round(r(sd),0.1)
	
	* Add a paragraph
	putdocx paragraph, halign(justified)
	putdocx text ("There are a total of `n' participants enrolled in this trial. The average age is `age_mean' (`age_sd') years.")
	
	putdocx save "$report", append

/*------------------------------------------------------------------------------------------
PART 7: Figure 1 - Kaplan-Meier plot
------------------------------------------------------------------------------------------*/

	putdocx begin
	
	*Add section break
	putdocx sectionbreak, landscape
	
	* Add section heading
	putdocx paragraph, style(Heading2)
	putdocx text ("4.1.	Kaplan-Meier plot")
	
	* Add a paragraph
	putdocx paragraph
	putdocx text ("Plot the Kaplan–Meier curve by treatment for progression on a landscape page.")

	* Add Figure 1
	do "$programsfolder\Le_Tourneau_SHIVA_Figure1.do"
	putdocx paragraph, halign(center)
	putdocx image "$outputfolder\Figure 1.png", linebreak(1)
	
	* Add figure title
	putdocx text ("Figure 1: Kaplan–Meier curve by treatment for progression-free survival.")
	
	putdocx save "$report", append
	
/*------------------------------------------------------------------------------------------
PART 8: Table 2 - Efficacy table
------------------------------------------------------------------------------------------*/

	putdocx begin
	
	*Add section break
	putdocx sectionbreak
	
	* Add section heading
	putdocx paragraph, style(Heading2)
	putdocx text ("4.2.	Cox regression")
	
	putdocx save "$report", append

	do "$programsfolder\Le_Tourneau_SHIVA_Table2.do"

exit