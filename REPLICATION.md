# [DOI:10.1086/694616] [Who Migrates and Why? Evidence from Italian Administrative Data.] Validation and Replication results

> INSTRUCTIONS: Once you've read these instructions, DELETE THESE AND SIMILAR LINES.
> In the above title, replace [Manuscript Title] with the actual title of the paper, and [MC number] with the Manuscript Central number (e.g., AEJPol-2017-0097)
> Go through the steps to download and attempt a replication. Document your steps here, the errors generated, and the steps you took to alleviate those errors.

> Some useful links:
> - [Official Data and Code Availability Policy](https://www.aeaweb.org/journals/policies/data-code)
> - [Unofficial Verification Guidance](https://social-science-data-editors.github.io/guidance/Verification_guidance.html) for additional tips and criteria.

SUMMARY
-------

> INSTRUCTION: The Data Editor will fill this part out. It will be based on any [REQUIRED] and [SUGGESTED] action items that the report makes a note of. 
>**No README file summarizing the actions that should be taken was included. The data file along with the code file were just given.** 

> INSTRUCTION: ALWAYS do "Data description", "Code description". If data is present, ALWAYS do "Data checks". If time is sufficient (initial assessment!), do "Replication steps", if not, explain why not.

Data description
----------------

### Data Sources

> INSTRUCTIONS: Identify all INPUT data sources. Create a list (and commit the list together with this report) (not needed if filling out the "Data Citation and Information report"). For each data source, list in THIS document presence or absence of source, codebook/information on the data, and summary statistics. Summary statistics and codebook may not be necessary if they are available for public use data. In all cases, if the author of the article points to an online location for such information, that is OK. Check for data citation. IN THIS DOCUMENT, point out only a summary of shortcomings.

#### Work Histories Italian Panel data

- Data source was not provided, only the analysis data file.
- However, you can see about the original data source [here](http://www.laboratoriorevelli.it/whip/whip_datahouse.php?lingua=ita&pagina=dati), note that language is in Italian, which makes it harder to understand if you do not know how to speak italian. But the data is still retreivable.
- No information on the data was provided. That is, no README file about the data.
- There are however, two poorly commented STATA codes that are included in a .zip file in [this link](https://www-journals-uchicago-edu.proxy-remote.galib.uga.edu/doi/suppl/10.1086/694616). 
- This data is however public and easy to access as seen by the previous points.
- Summary/ descriptive statistics are provided in the paper and how to provide the necessary tables are present in the STATA code.

### Analysis Data Files

> INSTRUCTIONS: Separately, identify any analysis data file provided. Analysis data files are produced by code in the deposit from data sources. Not every deposit will have these.

- [ ] No analysis data file mentioned
- [ ] Analysis data files mentioned, not provided (explain reasons below)
- [ ] Analysis data files mentioned, provided. File names listed below.

> INSTRUCTIONS: List all provided filenames here. For large deposits, this can be done using the "Git Bash" program:
> > find . -name \*.dta
> will list all Stata datasets. Replace `dta` with `.Rdata` or any other extension to find other datafiles.


Example:

```
./Output_Empirical/data/census_shp/counties_coord.dta
./Output_Empirical/data/census_shp/counties_db.dta
./Output_Empirical/data/census_shp/state_coord.dta
./Output_Empirical/data/census_shp/state_db.dta
```
- Who Migrates and Why - April 2017.dta

>**The final sample is what is produced from the code, which will have to be run in order to attain it.**

Data deposit
------------

> INSTRUCTIONS: Most deposits will be at openICPSR, but all need to be checked for complete metadata. Detailed guidance is at [https://aeadataeditor.github.io/aea-de-guidance/data-deposit-aea-guidance.html](https://aeadataeditor.github.io/aea-de-guidance/data-deposit-aea-guidance.html). 

### Requirements 

> INSTRUCTIONS: Check that these requirements are met. 

- [ ] README is in TXT, MD, PDF format
- [ ] openICPSR deposit has no ZIP files
- [ ] Title conforms to guidance (starts with "Data and Code for:" or "Code for:", is properly capitalized)
- [ ] Authors (with affiliations) are listed in the same order as on the paper

> **The authors did not provide any of the above materials.**

> INSTRUCTIONS: If any of the above are NOT checked, leave the related [REQUIRED] element here. Otherwise, delete the line.

> [REQUIRED] Please ensure that a ASCII (txt), Markdown (md), or PDF version of the README are available in the data and code deposit.

> [REQUIRED] openICPSR should not have ZIP files visible. ZIP files should be uploaded to openICPSR via "Import from ZIP" instead of "Upload Files". Please delete the ZIP files, and re-upload using the "Import from ZIP" function.

> [REQUIRED] Please review the title of the openICPSR deposit as per our guidelines (below).

> [REQUIRED] Please review authors and affiliations on the openICPSR deposit. In general, they are the same, and in the same order, as for the manuscript; however, authors can deviate from that order.

> **The authors also did not provide any of these materials.**

### Deposit Metadata

> INSTRUCTIONS: Some of these are specific to openICPSR (JEL, Manuscript Number). Others may or may not be present at other trusted repositories (Dataverse, Zenodo, etc.). Verify all items for openICPSR, check with supervisor for other deposits.

- [ ] JEL Classification (required)
  + Did not specify the JEL Classification, but given the paper, we can assume that it follows under the **Labor, and Demographic Economics system (J)** and the final classification would be under, **Mobility, Unemployment, Vacancies, and Immigrant Workers (J6)** and finally underneath **Geographic Labor Mobility; Immigrant Workers (J610)**  which retreived from [here](https://www.aeaweb.org/jel/guide/jel.php)
- [ ] Manuscript Number (required)
  + DOI:10.1086/694616
- [ ] Subject Terms (highly recommended)
  + Brain Drain, Expatriates, Geographic Mobility, Guestworker, Immigrant, Immigrant Labor, Immobility, International Migration, Labor Migration, Labor Mobility, Migrant Workers, Mobility, Out Migration
- [ ] Geographic coverage (highly recommended)
  + Data should consist of all individuals who have worked in Italy
- [ ] Time period(s) (highly recommended)
  + Including workers from Italy from 1985 to 2004
- [ ] Collection date(s) (suggested)
  + Not specified.
- [ ] Universe (suggested)
  + Not specified
- [ ] Data Type(s) (suggested)
  + STATA .dta
- [ ] Data Source (suggested)
  + Not stated in the manuscript, but given the [WHIP website stated above](http://www.laboratoriorevelli.it/whip/whip_datahouse.php?lingua=ita&pagina=dati), weknow that it comes in the form of _comma separated values_ .csv file.
- [ ] Units of Observation (suggested)
  + 1,447,312 units with 22,685 in final sample.

> INSTRUCTIONS: Go through the checklist above, and then choose ONE of the following results:

- [NOTE] openICPSR metadata is sufficient.

or

- [REQUIRED] Please update the openICPSR metadata fields marked as (required), in order to improve findability of your data and code supplement. 

and/or

- [SUGGESTED] We suggest you update the openICPSR metadata fields marked as (suggested), in order to improve findability of your data and code supplement. 

For additional guidance, see [https://aeadataeditor.github.io/aea-de-guidance/data-deposit-aea-guidance.html](https://aeadataeditor.github.io/aea-de-guidance/data-deposit-aea-guidance.html).
> **I would recommend both the [REQUIRED] and [SUGGESTED] sections.**

Data checks
-----------

> INSTRUCTIONS: When data are present, run checks:
> - can data be read (using software indicated by author)?
  + Yes, .dta file can be read.
> - Is data in archive-ready formats (CSV, TXT) or in custom formats (DTA, SAS7BDAT, Rdata)? Note: Numbers and Mathematica data files are not considered archive-safe and cannot be accepted. 
    + In custom formats
> - Does the data have variable labels (Stata: run `describe using (name of DTA)` and check that there is content in the column "variable label")?
    + Yes it has variable labels
> - Run check for PII ([PII_stata_scan.do](PII_stata_scan.do), sourced from [here](https://github.com/J-PAL/stata_PII_scan) if using Stata) and report results. Note: this check will have lots of false positives - fields it thinks might be sensitive that are not, in fact, sensitive. Apply judgement.

 #### Results from PII scan
 > Consider the following table of result: 

 file | var | varlabel | most freq value	| unique values	| total obs	| first reason | flagged |	samp1 |	samp2  | 	samp3 | samp4 |	samp5 
 -----|-----|----------|------------------|---------------|-----------|--------------|---------|--------|--------|--------|-------|-------
 D:/PhotonUser/My Files/OneDrive/Files/Who Migrates and Why - April 2017.dta | gender | gender | M | 2 | 1447312 | search term gender found in gender (label = gender) | M | F |   |   |   |
 D:/PhotonUser/My Files/OneDrive/Files/Who Migrates and Why - April 2017.dta | reg_nascita | place of birth - regions (28) | 13	| 28 | 1447312 | search term birth found in reg_nascita (label = place of birth - regions (28))	| 28	| 27 | 26 |	25 |	24  |
 D:/PhotonUser/My Files/OneDrive/Files/Who Migrates and Why - April 2017.dta | occupation	| apprentice, blue collar, white collar, manager | white collar | 3	| 1447312	| occupation (label = apprentice, blue collar, white collar, manager) has length > 3 | white collar | manager | blue collar |  |  
 D:/PhotonUser/My Files/OneDrive/Files/Who Migrates and Why - April 2017.dta | industry_3m | manufacturing, construction, services	| manufacturing	| 3	| 1447312	| i |  |   |  |  |  |

Code description
----------------
> INSTRUCTIONS: Review the code (but do not run it yet). Identify programs that create "analysis files" ("data preparation code"). Identify programs that create tables and figures. Not every deposit will have separate programs for this.
#### Data Preparation Code
```
use "migration_final.dta", clear

**** FINAL SAMPLE SELECTION - TAKE THOSE NORN IN SOUTH AND START WORKING IN SOUTH
keep if born=="S"
keep if first_job=="S"
bysort id:egen n_obs=count(id)
drop if n_obs == 1
label variable n_obs "no. of observations for individual"

* CREATE INDICATORS FOR MIGRANTS, NON-MIGRANTS, RETURN MIGRANTS

gen migrant=(work=="N")
label variable migrant "1 if working in North"
bysort id: egen max_migrant=max(migrant)
label variable max_migrant "1 if ever worked in North in sample"

bysort id (year sdate):gen r=(work=="S" & work[_n-1]=="N")
bysort id: egen max_returnee=max(r)
label variable max_returnee "1 if ever worked in South after having worked in North in sample"
* Old code defined return migrant "returnee"
gen return_migrant = (r==1)
bysort id (year sdate):replace return_migrant = return_migrant[_n-1] if return_migrant[_n-1]==1
label variable return_migrant "1 if working/worked in South, but worked in North previously (in sample)"

***
drop r born deflator_weekly_wage deflator_s_wage weekly_wage s_wage full_year n_obs
gen female = 0
replace female=1 if gender=="F"
tab year, gen(d_year)

iis id
tis year

*** Generate dummy variables if one of the move variables is zero, allowing a discontinuity there
gen moves_ai_1d0 = (moves_ai_1d==0)
gen moves_avg0 = (moves_avg==0)
gen moves_ar0 = (moves_ar==0)

gen moves_ar2=moves_ar*moves_ar
gen moves_ai_1d2=moves_ai_1d*moves_ai_1d
gen moves_avg2=moves_avg*moves_avg
drop migrant
compress

save "migration_sample.dta", replace
```
#### Tables and Figures
```
/****************************************************************/
/* Table 1 descriptive statistics ***/
/****************************************************************/

by work, sort: sum pot_exp tenure ten_north d_occ1 d_occ2 d_occ3 ptime multi_firm moves_avg  moves_ai_1d0 lnwage lnincome if female!=1


/****************************************************************/
/* Table 2 (Males, with returnees, for wages) ***/
/****************************************************************/

do "heckmanfe_std.do"
keep if female!=1
drop d_year1 d_year20
heckmanfe lnwage ptime tenure ten_trk d_occ1 d_occ3 pot_exp pot_exp2 tenure2  multi_firm  ten_north ten_north2 d_y*,  selection(d  ptime  tenure  tenure2 ten_trk ten_north ten_north2  d_occ1 d_occ3 pot_exp pot_exp2 multi_firm  moves_avg  moves_ai_1d0 d_y*)


/****************************************************************/
/* Table 3 (Males, with returnees, for income) **/
/****************************************************************/
clear all
use "migration_sample.dta", clear
do "heckmanfe_std.do"
keep if female!=1
drop d_year1 d_year20
heckmanfe lnincome ptime tenure ten_trk d_occ1 d_occ3 pot_exp pot_exp2 tenure2  multi_firm  ten_north ten_north2 d_y*,  selection(d  ptime  tenure  tenure2 ten_trk ten_north ten_north2  d_occ1 d_occ3 pot_exp pot_exp2 multi_firm  moves_avg  moves_ai_1d0 d_y*)


/****************************************************************/
/* Table 5 Placebo test    (males for wages and income) **/
/****************************************************************/

use "migration_sample.dta", clear

keep if max_migrant==0
keep if female!=1
keep if returnees==0

set seed 12345
gen random=runiform()
sort random

gen placebo=0
replace placebo=1 if _n/_N<=0.1

replace d=0 if placebo==1

do "heckmanfe_std.do"

drop d_year1 d_year20 

heckmanfe lnwage ptime tenure ten_trk d_occ1 d_occ3 pot_exp pot_exp2 tenure2  multi_firm  d_y*,  selection(d  ptime  tenure  tenure2 ten_trk   d_occ1 d_occ3 pot_exp pot_exp2 multi_firm  moves_avg  moves_ai_1d0 d_y*)
heckmanfe lnincome ptime tenure ten_trk d_occ1 d_occ3 pot_exp pot_exp2 tenure2  multi_firm  d_y*,  selection(d  ptime  tenure  tenure2 ten_trk   d_occ1 d_occ3 pot_exp pot_exp2 multi_firm  moves_avg  moves_ai_1d0 d_y*)

/****************************************************************/
/* Table 6: Migration from Northern to South  (males for wages and income) **/
/****************************************************************/

use "migration_final.dta", clear

/**** TAKE THOSE BORN IN NORTH AND START WORKING IN NORTH *****/

rename tenure_south ten_south
label variable ten_south "tenure in the firm in the south at start of spell"

gen ten_south2=ten_south*ten_south

keep if born=="N"
keep if first_job=="N"
bysort id:egen n_obs_rev=count(id)
drop if n_obs == 1
label variable n_obs "no. of observations for individual"

* CREATE INDICATORS FOR MIGRANTS, NON-MIGRANTS, RETURN MIGRANTS

gen migrant=(work=="S")
label variable migrant "1 if working in South"
bysort id: egen max_migrant=max(migrant)
label variable max_migrant "1 if ever worked in South in sample"

bysort id (year sdate):gen r=(work=="N" & work[_n-1]=="S")
bysort id: egen max_returnee=max(r)
label variable max_returnee "1 if ever worked in North after having worked in South in sample"
gen return_migrant = (r==1)
bysort id (year sdate):replace return_migrant = return_migrant[_n-1] if return_migrant[_n-1]==1
label variable return_migrant "1 if working/worked in North, but worked in South previously (in sample)"

***

drop r born deflator_weekly_wage deflator_s_wage weekly_wage s_wage n_obs
gen female = 0
replace female=1 if gender=="F"
tab year, gen(d_year)

iis id
tis year

*** Generate dummy variables if one of the move variables is zero, allowing a discontinuity there
gen moves_ai_1d0 = (moves_ai_1d==0)
gen moves_avg0 = (moves_avg==0)
gen moves_ar0 = (moves_ar==0)

gen moves_ar2=moves_ar*moves_ar
gen moves_ai_1d2=moves_ai_1d*moves_ai_1d
gen moves_avg2=moves_avg*moves_avg
drop migrant
compress

keep if female!=1

do "heckmanfe_std.do"

drop d_year1 d_year20
heckmanfe lnwage ptime tenure ten_trk d_occ1 d_occ3 pot_exp pot_exp2 tenure2  multi_firm  ten_south ten_south2 d_y*,  selection(d  ptime  tenure  tenure2 ten_trk ten_south ten_south2  d_occ1 d_occ3 pot_exp pot_exp2 multi_firm  moves_avg  moves_ai_1d0 d_y*)
heckmanfe lnincome ptime tenure ten_trk d_occ1 d_occ3 pot_exp pot_exp2 tenure2  multi_firm  ten_south ten_south2 d_y*,  selection(d  ptime  tenure  tenure2 ten_trk ten_south ten_south2  d_occ1 d_occ3 pot_exp pot_exp2 multi_firm  moves_avg  moves_ai_1d0 d_y*)
```

> INSTRUCTIONS: Identify all **Figure, Table, and any in-text numbers**. Create a list, mapping each of them to a particular program and line number within the program (use [this template](code-check-TEMPLATE.xlsx)). Commit that list. You will come back to the list in your findings. IN THIS SECTION, point out only a summary description, including of shortcomings. E.g.

There are four provided Stata do files, three Matlab .m files, including a "master.do".

- Table 5: could not identify code that produces Table 5
- Neither the program codes, nor the README, identify which tables are produced by what program.

> NOTE: In-text numbers that reference numbers in tables do not need to be listed. Only in-text numbers that correspond to no table or figure need to be listed.

#### Figure, Table, and any in-text numbers
> There are two provided STATA do files known as "heckmanfe_std.do" and "Who Migrates and Why-results April 2017.do" .
- Could not identify the code that produces any of the figures or graphs within the programs.
  + **Figures** : None of them, Figure 1, 2, 3, 4, 5, 6 are in the code.
  + **Tables** : All six tables were reported.
- No comments for any calculations.
- Do not understand the .do file heckmanfe_std.do as it is poorly commented. Thus, how do we connect this to utilizing the other .do file that analyzes and produces the results.

Stated Requirements
---------------------

> INSTRUCTIONS: The authors may have specified specific requirements in terms of software, computer hardware, etc. Please list them here. This is **different** from the Computing Environment of the Replicator. You have the option to amend these with unstated requirements later. If all requirements are listed, check the box "Requirements are complete".

- [ ] No requirements specified
- [ ] Software Requirements specified as follows:
  - STATA
- [ ] Computational Requirements specified as follows:
  - N/A
- [ ] Time Requirements specified as follows:
 
- [ ] Requirements are complete.

> If easier, simply copy-and-paste the authors' stated requirements here:


Actual Requirements, if different
---------------------------------

> INSTRUCTIONS: If it turns out that some requirements were not stated/ are incomplete (software, packages, operating system), please list the *complete* list of requirements here. If the stated requirements are complete, delete this section, including the requirement at the end.

- [ ] Software Requirements 
  - [ ] Stata
    - Packages go here
  - [ ] Matlab
  - [ ] R
    - R packages go here
  - [ ] REPLACE ME WITH OTHER
- [ ] Computational Requirements specified as follows:
  - Cluster size, etc.
- [ ] Time Requirements 
  - Length of necessary computation required was not stated, but given that you have to sort out to get the final data sample, this might take a longer time than usual.

> [REQUIRED] Please amend README to contain complete requirements. 

You can copy the section above, amended if necessary.

Computing Environment of the Replicator
---------------------

> INSTRUCTIONS: This might be automated, for now, please fill in manually. Remove examples that are not relevant, adjust examples to fit special circumstances. Some of this is available from the standard log output in Stata or R. Some frequently used details are below. Some of these details can be found as follows:
>
> - (Windows) by right-clicking on "This PC"
> - (Mac) Apple-menu > "About this Mac"
> - (Linux) see code in `tools/linux-system-info.sh`

- Windows Laptop, Ubuntu 18.04, Intel core i7, 8 GB of RAM

> INSTRUCTIONS: Please also list the software you used (specific versions). List only the ones you used, add any not listed in the examples:

- Stata/SE-64 16.1 

Replication steps
-----------------

> INSTRUCTIONS: provide details about your process of accessing the code and data.
> Do NOT detail things like "I save them on my Desktop".
> DO describe actions   that you did  as per instructions ("I added a config.do")
> DO describe any other actions you needed to do ("I had to make changes in multiple programs"), without going into detail (the commit log can provide that information)

Example:

1. Downloaded code and data from [ here ](https://www-journals-uchicago-edu.proxy-remote.galib.uga.edu/doi/suppl/10.1086/694616).
2. Made changes to the directory used and then changed the name of the original data to fit the title of the .dta file that was uploaded.
3. Created a log file to show the output of the code.
4. Ran code and there were no errors
5. No changes were made, but it is important to note that Table 4 was not reproduced as well as none of the figures.

Findings
--------

> INSTRUCTIONS: Describe your findings both positive and negative in some detail, for each **Data Preparation Code, Figure, Table, and any in-text numbers**. You can re-use the Excel file created under *Code Description*. When errors happen, be as precise as possible. For differences in figures, provide both a screenshot of what the manuscript contains, as well as the figure produced by the code you ran. For differences in numbers, provide both the number as reported in the manuscript, as well as the number replicated. If too many numbers, contact your supervisor.

### Data Preparation Code

Examples:
**Note that the data preparation portion is embedded within the analysis code**
- Program `1-Who Migrates and Why - results April 2017.do` ran without error, output expected data

### Tables

Examples:

- Table 1,2,3,5,6 were produced, Table 4 was not produced from the code. Refer to the [log file](https://github.com/mbell15/Replication-Template/blob/master/Replication_log.log)
  + Table 1: Really close answers.
  + Table 2: shows really close results for south and north, however, not all results are similar for selection, mainly for potential experience and its squared value, however, if we negate the other answers, we get really close answers, which suggests that the selection equation was not coded with respect to the literature.
  + Table 3: Similar to Table 2.
  + Table 4: Not in program.
  + Table 5: Looking at the secttion BIAS-CORTD of the results table, we see that they are close, however, there a bit of by $\pm$ 5 o so.
  + Table 6: The results are different but it also seems like the values of south and north for Income were switched for the Inverse Mills Ratio. Ability is approximately similar.
  
### Figures

> INSTRUCTIONS: Please provide a comparison with the paper when describing that figures look different. Use a screenshot for the paper, and the graph generated by the programs for the comparison. Reference the graph generated by the programs as a local file within the repository.

Example:

- No program provided for any of the figures.


### In-Text Numbers

> INSTRUCTIONS: list page and line number of in-text numbers. If ambiguous, cite the surrounding text, i.e., "the rate fell to 52% of all jobs: verified".

[ ] There are in-text numbers, but they are not identified in the code
  

Classification
--------------

> INSTRUCTIONS: Make an assessment here.
>
> Full reproduction can include a small number of apparently insignificant changes in the numbers in the table. Full reproduction also applies when changes to the programs needed to be made, but were successfully implemented.
>
> Partial reproduction means that a significant number (>25%) of programs and/or numbers are different.
>
> Note that if any data is confidential and not available, then a partial reproduction applies. This should be noted in the Reasons
>
> Note that when all data is confidential, it is unlikely that this exercise should have been attempted.
>
> Failure to reproduce: only a small number of programs ran successfully, or only a small number of numbers were successfully generated (<25%)

- [ ] full reproduction
- [ ] full reproduction with minor issues
- [ ] **partial reproduction (see above)**
- [ ] not able to reproduce most or all of the results (reasons see above)

### Reason for incomplete reproducibility

> INSTRUCTIONS: mark the reasons here why full reproduciblity was not achieved, and enter this information in JIRA

- [ ] **`Discrepancy in output` (either figures or numbers in tables or text differ)**
- [ ] `Bugs in code`  that  were fixable by the replicator (but should be fixed in the final deposit)
- [ ] **`Code missing`, in particular if it  prevented the replicator from completing the reproducibility check**
- [ ] `Code not functional` is more severe than a simple bug: it  prevented the replicator from completing the reproducibility check
- [ ] `Software not available to replicator`  may happen for a variety of reasons, but in particular (a) when the software is commercial, and the replicator does not have access to a licensed copy, or (b) the software is open-source, but a specific version required to conduct the reproducibility check is not available.
- [ ] `Insufficient time available to replicator` is applicable when (a) running the code would take weeks or more (b) running the code might take less time if sufficient compute resources were to be brought to bear, but no such resources can be accessed in a timely fashion (c) the replication package is very complex, and following all (manual and scripted) steps would take too long.
- [ ] `Data missing` is marked when data *should* be available, but was erroneously not provided, or is not accessible via the procedures described in the replication package
- [ ] `Data not available` is marked when data requires additional access steps, for instance purchase or application procedure. 
