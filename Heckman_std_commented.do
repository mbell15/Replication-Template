*> This file contains the program that is used in the authors modified heckman selection method.*
*> It, firstly, involves utilizing a different version of the iterative method.*
*> Secondly, due to the utilization of fixed effects for the panel regression, there exists a form of heterogeneity that relates to the use of the incidental parameters. Hence, the authors aim to solve this issue through using the jacknife bas correction method.*
*> Finally, for the estimators associated with the jacknife bias correction, bootstrap sandard errors and p-value was calculated.

**********************************************************************************
*> Hence, we start with describing the function/ program that will be used.*
*>"capture" function is used to suppress outputs not relevant to the final result as this program as specific parts that are needed rather than everything*
*>"program" function defines a function or program that can be used to act on something else.*
*>"program drop" removes all the programs stored in memory*
capture program drop heckmanfe 

**********************************Beginning Stuff*******************************
program define heckmanfe, rclass
*>"rclass" refers to the type of program that returns results in r() class (returned results) *
syntax varlist [if],  selection(varlist)
*>"syntax" function is used to interpret whatever the user of the program types in. This is interpreted based on the stata syntax rather than a specific order like in "args".*
*> "selection(varlist)"  selects a certain amount of variables specified by the syntax and is then used to create a subset of variables.*
marksample touse
*>"marksample" denotes which variables are to be left behind after the above syntax is used*
local samples=`touse'
*>"local" assigns strings to local macro names, i.e., it assigns `touse' as a string to everything in the memory until this .do file ends.*

tempname migrant etahat0 etahatS etahatN D obs1 maxD minD esample
*> This associates the listed var names with a temporarily assigned value until the conclusion of this .do file.*

*> Firstly, from the varlists provided, we need to isolate the categorical variable denoting if one works in the south 
local a= word("`selection'",1)
*> Given a string var, in this case "`selection'", "word" function gives you the 1st word in the string, which the authors wanted to make local.*
*> Which in this case , we get the first variable, D in the selection equation.

*> Hence we can capture this by doing:
qui gen D = `a'
*> which means that we quietly (suppress output of) generated variable D. Would help to understand the intended value of `D'.

*> Then, we need to create a categorical variable to make sure it only involves ones and zeros,
bys id: egen maxD=max(D)
*> Generates w.r.t. the sorted id variable. the maximum value of the variable `D' and making sure that thi is 1.*
qui drop if maxD==0
*>Quietly drop if the maximum is 0*
bys id: egen minD=min(D)
*> Try to isolate the ones that work in the north.*

*>Denote that the categorical variable for migrant is if they work in the south.*
bys id: gen migrant = 1-minD	

*>Similarly, we can denote Y is the outcome which could either be lnwage or lnincome.*
local Y= word("`varlist'",1)
qui gen Y = `Y' 

****************************Body of the Code***************************************
capture drop etahat

*> Now to start the iterative process that was described in the paper:
******************
	*Steps 1) and 2): This section has to do with estimating the coefficients for the outcome equation as stated in the procedure of the paper.
	*************************This section is for the ones that moved*******************
	*>We can estimate the initial coefficients from using a fixed effects regression for the outcome onto the rest.*
	qui xtreg `varlist' if (D==1), fe
	
	*> Get the predicted values of the fixed error component `u' associated with the outcome regression.*
	qui predict etahat0,u
	
	*> get the max fixed error with respect to the sorted id.*
	qui bys id: egen etahat=max(etahat0)
	
	*> Drop the rest that is not the max of each group, not sure why?*
	drop etahat0
	
	*> Categorical variable that marks aspects of the sample that were used in regression.*
	gen esample = e(sample)
	
	*> generate a temporary variable that marks what was and was not used in the above regression.*
	gen idS = id*esample
	
	*> generate which observation id was used in the regression above with the first of every group.*
	qui bys idS: gen obs1 = (_n==1) if idS!=0
	
	
	drop idS
	*disp in red "Number of observations in the outcome equation 1" (Comment of the authors)
	count if esample==1
	*disp in red "Number of individuals in the outcome equation 1" (Comment of the authors)
	count if esample==1 & obs1==1
	*disp in red "Number of movers-observations in the outcome equation 1" 
	 count if esample==1 & migrant==1
	
	*> return and store the  cumulative number of observations of migrants*
	local migobsS= r(N)
	
	*disp in red "Number of movers-individuals in the outcome equation 1" (Comment of the authors)
	count if esample==1 & migrant==1 & obs1==1
	
	*> return the cumulative nmber of movers-individuals.*
	local migindS= r(N)
	
	
	drop esample obs1
	
	*> Define a matrix that has Coefficient vector associated with the regression.*
	mat define coeff2st=e(b)' 
	***********************************************************************************
	
	*************************This section is for the ones that stayed*******************
	qui xtreg `varlist' if (D==0), fe
	mat define coeff3st=e(b)'
	gen esample = e(sample)
	gen idN = id*esample
	qui bys idN: gen obs1 = (_n==1) if idN!=0
	drop idN
	*disp in red "Number of observations in the outcome equation 2"
	 count if esample==1 & migrant==1
	local migobsN= r(N)
	*disp in red "Number of individuals in the outcome equation 2"
	 count if esample==1 & migrant==1 & obs1==1
	local migindN= r(N) 
	drop esample obs1
	**********************************************************************************
	
***************************This secction involves estimating a probit*****************
* 3) This involves step 3),4),5) of the iterative algorithm from the paper.
qui probit `selection'
*> Quietly estimate the probit for the selection equation.*
mat define coeff1st=e(b)'
*> Coefficient vector associated with probit.*
**************************************************************************************

********************Create vector and iterate until convergence***********************
* This section follows step 6) in the iterative method proposed by the authors.

*> Define a coefficient matrix that involves all the previous coefficients
mat define COEFF=coeff2st\0\coeff3st\0\coeff1st\0

*> Create a matrix only utilizing the first set of coefficients.
mat define coeff1=coeff2st\0\coeff1st\0

*> Create counters for the convergence (perd) and the number of iterations (niter).*
local perd=1
local niter=1

*> While loop for the iteration.*
while (`perd'>=0.00001){
	
	*> Start with a temporary holder for the vector*
	mat define coeff0=coeff1
	
	* > Use these for the code only*
	capture drop Pxb predictedxb IMRS IMRN
	
	*> Re-estimate the selection model with respect to the fixed effects error calculated above.*
	qui probit `selection' etahat
	
	*> utilize all the stored memory generated by capture.
	local rcprobit = _rc
	
	if (`rcprobit'==0){
		*> If nothing is stored:
		
		* The cumulative observation associated with those used in the probit estimation.
		local Nprobit = e(N)
		
		*> Re-estimate the coefficient vector.*
		mat define coeff1st=e(b)'
		
		*> Estimate the variance-covariance matrix.*
		mat define Var1st=e(V)
		
		*> Given this, predict the outcome from the probit, i.e., who will migrate.
		qui predict predictedxb, xb
		
		*> From this, generates the probability phi(xb)
		qui predict Pxb
		
		*> Calculate the Inverse Mills Ratio of those migrating from the source.
		qui gen IMRS=normalden(predictedxb)/(Pxb)
		
		*> Calculate the Inverse Mills Ratio of those staying in the location.
		qui gen IMRN=normalden(predictedxb)/(1-Pxb)
		
		*************Repeat what we did above for step 1 and 2******************
		*> Now regress with the IMRS in mind with fixed effects of those who migrated.*
		qui xtreg `varlist' IMRS if (D==1), fe
		*> Store the nmber of observations based on this regression .*
		local Nreg = e(N)
		*> Collect the new coefficients
		mat define coeff2st=e(b)'
		*> Predict the fixed error associated with the above regression.*
		qui predict etahat0,u
		capture drop etahat
		*> Generate the max from this.*
		qui bys id: egen etahat=max(etahat0)
		drop  etahat0 
		*> Define a coefficient matrix.*
		mat define coeff1=coeff2st\coeff1st
		*> Calculate the difference between M and M-1*
		mat define coeffdiff=coeff1-coeff0
		*> Square this matrices.*
		mat define coeffMSS= coeffdiff'*coeffdiff
		*> let the counter be the value in the first element.*
		*> Hope that this gets smaller so that it converges.*
		local perd = coeffMSS[1,1]
		disp in green " Convergence Criteria: `perd' - Iterations: `niter'"
		
		*> If no convergence, then record it as a failure for this round*
		if (`niter'>500){
			local perd=0
			local failed = `failed'+1
			display in red "convergence not achieved after 1000 iterations"
			}
		*> Else continue.*
		else{
		local niter = `niter'+1
		}
	}
	*> If the there is something in _rc, then convergence failed.
	if (`rcprobit'!=0){
		local perd=0
		local failed = `failed'+1
	}
	*> Now  regress the outcome on to the rest including the IMRN and the error term when they stayed.*
	qui reg `varlist' IMRN etahat if (D==0)
	*> Generate the coefficient matrix for this.*
	mat define coeff3st=e(b)'

}
	*> Now create the final coefficient vector.*
	mat define COEFF=coeff2st\coeff3st\coeff1st

*> This section involves displaying the results as above in order to check the values.*
disp in green "________________________________________________________________________________" 
*> Store the estimated dependent variable
local DV2st= e(depvar)
mat define results = COEFF
*> Utilize the first coefficient matrix for later purposes, mainly in the Jacknife bias correction.*
mat define coeff1_ORIG = coeff1
mat define coeffORIG = COEFF
*> Display the results of the coefficient matrix with the use of st_matrix() function which is under the matrix programming language mata.*
mata Results= st_matrix("COEFF")
*> Show the results of the above estimations.*
mat list results

mata results= st_matrix("results")
*> Returns the fixed error associated with the regression.*
mata ETAHAT= st_data(.,"etahat")
*> Returns the Inverse miller Ratios.*
mata IMRS= st_data(.,"IMRS")
mata IMRN= st_data(.,"IMRN")
************************************************************************************************

********************************JACKNIFE BIAS CORRECTION****************************************
*> Following from the  problem,, note the authors calculated the regressions with fixed effects.*
*> This shrinks the estimated standard error asssociated with a given time period and thus presents a bias which is known as the ``Incidental problem''.
*> Thus, in order to correct for this, they considered using this bias correction method proposed by Hahn & Newey(2004).*
disp in green "________________________________________________________________________________"
disp in green " Calculating JACKNIFE Bias Correction (Hahn & Newey Econometrica(72)4 July 2004 "
disp in green "________________________________________________________________________________"

*> Find the year range of the data being analyzed by using min(year) and max(year).
*> Most recent year
egen maxyear = max(year)
*> Earliest year
egen minyear = min(year)

local maxyearS = maxyear[1]
local minyearS = minyear[1]
drop maxyear minyear

*> Develop a counter to keep track of the years that were excluded.*
local yearEXCLUDED = `minyearS'
*> Define the first orignal coefficient matrix.*
mat define coeff1 = coeff1_ORIG
*> Firstly, they preserved the data that has been stored so far
preserve

*> Now, start a while loop that goes through the years, note that this is supposed to simulate the proposed correction formula:
*> [T\hat{\theta} -(T-1)\sum_{t=1}^{T}(\hat{\theta}_{t})]/T -----> written in latex format.*
while (`yearEXCLUDED'<=`maxyearS'){
	*> Since this is a while loop, and the data will be dropped or altered later, restore it now.
	restore
	*> and preserve again.
	preserve
	*> add missing values for each year that is excluded for the selection and outcome dependent variables.*
	replace D=. if year==`yearEXCLUDED'
	replace Y=. if year==`yearEXCLUDED'
	
	*> Define the counters once again
	local perd=1
	local niter=1
	local failed=0
	
		*> Start while loop.
		*> Similarly with the above iterative method we have the following:*
		while (`perd'>=0.0000001){
				*> Seen before ....******************
				capture drop Pxb predictedxb IMRS IMRN
				mat define coeff0=coeff1
				capture probit `selection' etahat
				local Nprobit = e(N)
				mat define coeff1st=e(b)'
				qui predict predictedxb, xb
				qui predict Pxb
				qui gen IMRS=normalden(predictedxb)/(Pxb)
				qui gen IMRN=normalden(predictedxb)/(1-Pxb)
				qui xtreg `varlist' IMRS if (D==1), fe
				local Nreg = e(N)
				mat define coeff2st=e(b)'
				qui predict etahat0,u
				capture drop etahat
				qui bys id: egen etahat=max(etahat0)
				drop etahat0
				mat define coeff1=coeff2st\coeff1st
				*>... up to here*******************
				
				mata coeff1II= st_matrix("coeff1")
				mata coeff0II= st_matrix("coeff0")
				*> Select all the parts of the vector `coeff1II' and `coeff0II'  for the dimensions for when `coeff0II ! = 0'.*
				mata coeff1II= select(coeff1II,(coeff0II:!=0))
				mata coeff0II= select(coeff0II,(coeff0II:!=0))
				*> Note that this is also slightly similar to the section fof finding a new value for perd.*
				mata coeffdiffII = ((coeff1II-coeff0II):/coeff0II)'((coeff1II-coeff0II):/coeff0II)
				mata st_matrix("coeffMSS",coeffdiffII)
				
				*> Back to the remaining part of the iterative method
				local perd = coeffMSS[1,1]
				*> Unsure of why a smaller iterative limitation was used.
				if (`niter'>100){
					local perd=0
					local failed = `failed'+1
				}
				if (`niter'<=100){
					local niter = `niter'+1
				}

			qui reg `varlist' IMRN etahat if (D==0)
			mat define coeff3st=e(b)'
			*> End of iterative method.*
			}

	mat define COEFF=coeff2st\coeff3st\coeff1st
	mat define results = results, (COEFF)  
	sort id year
	*> Keep on adding the estimates (IMRs and etahat) to a vector.
	mata ETAHAT = ETAHAT, st_data(.,"etahat")
	mata IMRN = IMRN, st_data(.,"IMRN")
	mata IMRS = IMRS, st_data(.,"IMRS")
	
	*> Increase counter for the time
	local yearEXCLUDED=`yearEXCLUDED'+1
	local iterD = `yearEXCLUDED'-`minyearS'
	local iterT = `maxyearS'-`minyearS'+1
	disp in green "N. of iterations done `iterD' Total number of iterations `iterT'" 
	disp in green "N. of obs. in Sel. Eq: `Nprobit' - N. of obs. in Wage Eq.: `Nreg'"
	disp in green "________________________________________________________________________________"
	*>End of Jacknife method.*
	*> Note that this calculated for each year.
}

sort id year
mata id=st_data(.,"id")
mata year=st_data(.,"year")
mata results= st_matrix("results")

*> Utilize the Jacknife formula that was stated above for the important estimates.
*> cols() returns number of columns of the results, in this case, represents T for `cols(results)-1' .*
*> J(m,n,0) represents an m X n matrix filled with 0. In this case it returns a `[cols(results)-1] X 1' matrix of `1/(cols(results)-1)'. (which is esesentially 1/T).*
*> `:' is placed before an operator to suggest that it involves element by element operation.
*> b[|(i,j)\(m,n)|] involves stating a submatrix in b with `(m-i+1) X (n-j+1)' dimensions.
mata resultsBC = (cols(results)-1):*results[.,1] -  (cols(results)-2):*results[|1,2\rows(results),cols(results)|]*J(cols(results)-1, 1,1/(cols(results)-1))
mata ETAHATBC = (cols(ETAHAT)-1):*ETAHAT[.,1] -  (cols(ETAHAT)-2):*ETAHAT[|1,2\rows(ETAHAT),cols(ETAHAT)|]*J(cols(ETAHAT)-1, 1,1/(cols(ETAHAT)-1))
mata IMRNBC = (cols(IMRN)-1):*IMRN[.,1] -  (cols(IMRN)-2):*IMRN[|1,2\rows(IMRN),cols(IMRN)|]*J(cols(IMRN)-1, 1,1/(cols(IMRN)-1))
mata IMRSBC = (cols(IMRS)-1):*IMRS[.,1] -  (cols(IMRS)-2):*IMRS[|1,2\rows(IMRS),cols(IMRS)|]*J(cols(IMRS)-1, 1,1/(cols(IMRS)-1))
*> Note that the above calculations could be incorrect in the jacknife formula, I tihnk that there are parantheses missing, in terms of it should probably be:*
*> `(' (cols(results)-1):*results[.,1] -  (cols(results)-2):*results[|1,2\rows(results),cols(results)|] `)' *J(cols(results)-1, 1,1/(cols(results)-1))
*> Once again, I am unsure of this, and I might be wrong, but it could also be a possibility of why some of the estimates are not the exact same as the values reported in the paper.*


restore
*> store the values.*
mata st_store(.,"etahat",ETAHATBC)
mata st_store(.,"IMRN",IMRNBC)
mata st_store(.,"IMRS",IMRSBC)


mata st_matrix("resultsBC",resultsBC)
matrix colnames resultsBC = BIAS-CORTD 
mata st_matrix("resultsORIG",results[.,1])
matrix colnames resultsORIG = Coeff 
mat define coeff1 = COEFF

***************************************BOOTSTRAP*****************************************
*> Finally, the authors obtain the standard errors and p-values associated with estimation above.
disp in green "                                                                          "
disp in green "Dependent Variable of the 2nd Stage : `DV2st'"
disp in green "Dependent Variable of the 1st Stage takes the value 1 if `DV2st' is not missing"
disp in green "First set of coefficients, until the first _cons correspond to the second stage"
disp in green "________________________________________________________________________________"
disp in green "                                                                          "
disp in green "N. of obs. in Sel. Eq: `Nprobit' - N. of obs. in Wage Eq.: `Nreg'"
disp in green "________________________________________________________________________________"
disp in green "___________________________________________________________________________________________________"
disp in green "                                                                                                   "
disp in green "                        Calculating BOOTSTRAP Standard Errors                                      "
disp in green "___________________________________________________________________________________________________"

local maxiter = 100
local iter = 1
local failed=0
while (`iter' <= `maxiter'){
	preserve
	rename id id_orig
	set seed `iter'
	*> Generate a bootstrap sample clustered w.r.t the id
	bsample, cluster(id_orig) idcluster(id)
	
		
	local perd=1
	local niter=1
	*> Perform the iterative method (as seen before) on the bootstrap sample*****
	while (`perd'>=0.00001){
		mat define coeff0=coeff1
		capture drop  predictedxb Pxb IMRN IMRS
		qui probit `selection' etahat
		local rcprobit = _rc
		if (`rcprobit'==0){
			local Nprobit = e(N)
			mat define coeff1st=e(b)'
			mat define Var1st=e(V)
			qui predict predictedxb, xb
			qui predict Pxb
			qui gen IMRS=normalden(predictedxb)/(Pxb)
			qui gen IMRN=normalden(predictedxb)/(1-Pxb)
			capture drop etahat
			qui xtreg `varlist' IMRS if (D==1), fe
			local Nreg = e(N)
			mat define coeff2st=e(b)'
			qui predict etahat0,u
			qui bys id: egen etahat=max(etahat0) 
			qui reg `varlist' IMRN etahat if (D==0)
			mat define coeff3st=e(b)'
			
			drop etahat0 IMRN IMRS Pxb predictedxb
			mat define coeff1=coeff2st\coeff3st\coeff1st	
			mat define coeffdiff=coeff1-coeff0
			mat define coeffMSS= coeffdiff'*coeffdiff
			local perd = coeffMSS[1,1]
			disp in green " Convergence Criteria: `perd' - Iterations: `niter'"
	
			if (`niter'>200){
				local perd=0
				display in red "convergence not achieved after 200 iterations"
				}
			else{
			local niter = `niter'+1
			}
		}
		
		if (`rcprobit'!=0){
			local perd=0
			local failed = `failed'+1
		}
}	
	
	mata Results= Results,st_matrix("coeff1")
	restore
	local iter=`iter'+1
	if (`rcprobit'==0) local rcprobitC="Yes"
	if (`rcprobit'!=0) local rcprobitC="No"
	local iterC=`iter'-1
	disp in green "Total number of itarations: `maxiter' - Completed: `iterC' -  Failed: `failed'"
	disp in green "CURRENT ITERATION: Probit converges: `rcprobitC'  with `iterprobit' iteration- Iterations of Internal Loop: `niter'"
	disp in green "___________________________________________________________________________________________________"

	}
	*> End of iterative method*****
	
	
drop  Y D maxD minD migrant etahat

*> Print the final results 
disp in green "                                                                          "
disp in green "Dependent Variable of the 2nd Stage : `DV2st'"
disp in green "Dependent Variable of the 1st Stage takes the value 1 if `DV2st' is not missing"
disp in green "First set of coefficients, until the first _cons correspond to the second stage"
disp in green "________________________________________________________________________________"
disp in green "                                                                          "
disp in green "N. of obs. in Sel. Eq: `Nprobit' - N. of obs. in Wage Eq.: `Nreg'"
disp in green "________________________________________________________________________________"
disp in green "                                                                                "
disp in green "                             FINAL RESULTS                                      "       
disp in green "________________________________________________________________________________"

*> Calculate the mean of the coefficient vectors from the bootstrap sample
mata meancoeff = mean(Results')'
*> Calculate the variance of the coefficient vectors from the bootstrap sample
mata Variancecoeff = variance(Results')'
*> Calculate the p-value.
mata pvalue = 1:- ((resultsBC:>0):*((Results:>0)*J(cols(Results),1,(1/cols(Results))))+ (resultsBC:<=0):*((Results:<=0)*J(cols(Results),1,(1/cols(Results)))))
*> Calculate the standard errors from the above 
mata stderror =  (diagonal(variance(Results'))):^0.5

*> Display and label the results in a tabular format.*
mata st_matrix("pvalue",pvalue)
matrix colnames pvalue = P-value
mata STDcoeff=diagonal(Variancecoeff):^0.5
mata st_matrix("meanCOEFF",meancoeff)
matrix colnames meanCOEFF = BTP-MEAN
mata st_matrix("STDCOEFF",STDcoeff)
matrix colnames STDCOEFF = BTP-STD
mata st_matrix("stderror",stderror)
matrix colnames stderror = STD-DEV

*> Final tabulated format.
mat define results = (coeffORIG, meanCOEFF, STDCOEFF, pvalue, resultsBC, stderror)
mat list results

capture drop etahat
gen etahat=.
mata st_store(.,"etahat",ETAHATBC)
*> End of program***************************************************************
end
