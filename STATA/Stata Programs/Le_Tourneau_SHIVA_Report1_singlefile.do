/*------------------------------------------------------------------------------------------
Name: Le_Tourneau_SHIVA_Report1_singlefile.do
--------------------------------------------------------------------------------------------
Description: Report 1 do-file for SHIVA Trial  

This do-file includes all Stata code to generate tables and figures, and include them in a 
report created using Microsoft Word.

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
log using Le_Tourneau_SHIVA_Report1_singlefile.log, replace

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
	
	*Create Table 1
	use "$analysisdata", clear
	
	local t = 1  				//Specify table number

	table1_mc, by(brasf) total(after) vars(sexf cat %2.1f\ agerand contn %2.1f\ ///
				pathwayf cat %2.1f\ tt_Lnum conts %2.1f) onecol nospace extraspace clear
				
	keep factor brasf_0 brasf_1 brasf_T

	*Add Table 1 to report
	putdocx table table`t' = (11,4), title("Table `t': Baseline characteristics") ///
			border(all, nil) layout(autofitcontents) ///
			note("CT = Treatment at physician's choice group, IQR = Interquartile range, MTA = Molecularly targeted agent group, SD = Standard deviation")
	
	local i = 2
	local j = 1
	
	foreach var of varlist factor brasf_0 brasf_1 brasf_T {
		
		forvalues i = 2(1)12 {
			
			local table`t'_`i'`j' = `var'[`i'-1]
			
			putdocx table table`t'(`i',`j') = ("`table`t'_`i'`j''")

		}
		
		local j = `j' + 1 
	}
	
	putdocx table table`t'(4,1) = ("Sex, n (%)")
	putdocx table table`t'(7,1) = ("Age (years), mean (SD)")
	putdocx table table`t'(8,1) = ("Molecular pathway altered, n (%)")
	putdocx table table`t'(9,1) = ("   Hormone receptor pathway")
	putdocx table table`t'(10,1) = ("   RAF/MEK pathway")
	putdocx table table`t'(11,1) = ("	  PI3K/AKT/mTOR pathway")
	putdocx table table`t'(12,1) = ("Previous lines of treatment, median (IQR)")
	
	putdocx table table`t'(1/3,.), bold 
	putdocx table table`t'(1,.), font("Calibri", 12)

	putdocx table table`t'(2,.), border("top")
	putdocx table table`t'(4,.), border("top")
	putdocx table table`t'(12,.), border("bottom")
			
	putdocx save "$report", append												

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

	*Create Figure 1
	use "$analysisdata", clear
	
	local f = 1 			//Specify figure number

	stset years, failure(progStatus)

	sts graph, by(brasf_string) risktable (, size(small) title(,size(small))) ///
					title("") xtitle("Years from randomisation",size(small)) ytitle("Progression-free survival (%)",size(small)) ///
					ylab(0 "0" .25 "25" .5 "50" .75 "75" 1 "100") ///
					legend (label(1 "CT") label(2 "MTA") size(small) region(lcolor(white)) position(6) rows(1)) ///
					xlabel(,labsize(small)) ylabel(,labsize(small) angle(horizontal)) ///
					plot1(lcolor(blue) lpattern(solid)) plot2(lcolor(red) lpattern(solid)) graphregion(color(white))

	graph export "$outputfolder\Figure `f'.png", replace
	
	* Add Figure 1 to report
	putdocx paragraph, halign(center)
	putdocx image "$outputfolder\Figure `f'.png", linebreak(1)
	
	* Add figure title
	putdocx text ("Figure `f': Kaplan–Meier curve by treatment for progression-free survival.")
	
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
	
	*Create Table 2
	use "$analysisdata", clear
	
	local t = 2  				//Specify table number
	
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

	*Add Table 2 to report
	putdocx table table`t' = (4,3), title("Table `t': Effect of treatment for progression-free survival") ///
			border(all, nil) layout(autofitcontents) note("HR = Hazard Ratio, CI = Confidence Interval")

	putdocx table table`t'(2,1) = ("Characteristic")
	putdocx table table`t'(2,2) = ("HR (95% CI)")
	putdocx table table`t'(2,3) = ("p-value")

	putdocx table table`t'(3,1) = ("Treatment")
	putdocx table table`t'(4,1) = ("	Treatment at physician's choice group")
	putdocx table table`t'(5,1) = ("	Molecularly targeted agent group")

	putdocx table table`t'(4,2) = ("Ref.")

	local table`t'_52 = Estimate[1]
	di "`table`t'_52'"
	putdocx table table`t'(5,2) = ("`table`t'_52'")

	local table`t'_53 = Pvalue[1]
	di "`table`t'_53'"
	putdocx table table`t'(5,3) = ("`table`t'_53'")

	putdocx table table`t'(1/2,.), bold 
	putdocx table table`t'(1,.), font("Calibri", 12)

	putdocx table table`t'(2,.), border("top")
	putdocx table table`t'(3,.), border("top")
	putdocx table table`t'(5,.), border("bottom")

	putdocx save "$report", append							

log close
exit