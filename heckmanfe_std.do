capture program drop heckmanfe
program define heckmanfe, rclass
syntax varlist [if],  selection(varlist)
marksample touse
local samples=`touse'

tempname migrant etahat0 etahatS etahatN D obs1 maxD minD esample
local a= word("`selection'",1)
qui gen D = `a'
bys id: egen maxD=max(D)
qui drop if maxD==0
bys id: egen minD=min(D)
bys id: gen migrant = 1-minD	
local Y= word("`varlist'",1)
qui gen Y = `Y'

capture drop etahat
	qui xtreg `varlist' if (D==1), fe
	qui predict etahat0,u
	qui bys id: egen etahat=max(etahat0)
	drop etahat0
	gen esample = e(sample)
	gen idS = id*esample
	qui bys idS: gen obs1 = (_n==1) if idS!=0
	drop idS
	*disp in red "Number of observations in the outcome equaiton 1"
	count if esample==1
	*disp in red "Number of individuals in the outcome equaiton 1"
	count if esample==1 & obs1==1
	*disp in red "Number of movers-observations in the outcome equation 1"
	 count if esample==1 & migrant==1
	local migobsS= r(N)
	*disp in red "Number of movers-individuals in the outcome equation 1"
	count if esample==1 & migrant==1 & obs1==1
	local migindS= r(N)
	drop esample obs1
	mat define coeff2st=e(b)' 
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
qui probit `selection'
mat define coeff1st=e(b)'
mat define COEFF=coeff2st\0\coeff3st\0\coeff1st\0
mat define coeff1=coeff2st\0\coeff1st\0


local perd=1
local niter=1
while (`perd'>=0.00001){
	mat define coeff0=coeff1
	capture drop Pxb predictedxb IMRS IMRN
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
		qui xtreg `varlist' IMRS if (D==1), fe
		local Nreg = e(N)
		mat define coeff2st=e(b)'
		qui predict etahat0,u
		capture drop etahat
		qui bys id: egen etahat=max(etahat0)
		drop  etahat0 
		mat define coeff1=coeff2st\coeff1st
		mat define coeffdiff=coeff1-coeff0
		mat define coeffMSS= coeffdiff'*coeffdiff
		local perd = coeffMSS[1,1]
		disp in green " Convergence Criteria: `perd' - Iterations: `niter'"
		if (`niter'>500){
			local perd=0
			local failed = `failed'+1
			display in red "convergence not achieved after 1000 iterations"
			}
		else{
		local niter = `niter'+1
		}
	}
	if (`rcprobit'!=0){
		local perd=0
		local failed = `failed'+1
	}
	qui reg `varlist' IMRN etahat if (D==0)
	mat define coeff3st=e(b)'

}

	mat define COEFF=coeff2st\coeff3st\coeff1st

disp in green "________________________________________________________________________________" 
local DV2st= e(depvar)
mat define results = COEFF
mat define coeff1_ORIG = coeff1
mat define coeffORIG = COEFF
mata Results= st_matrix("COEFF")
mat list results

mata results= st_matrix("results")
mata ETAHAT= st_data(.,"etahat")
mata IMRS= st_data(.,"IMRS")
mata IMRN= st_data(.,"IMRN")

disp in green "________________________________________________________________________________"
disp in green " Calculating JACKNIFE Bias Correction (Hahn & Newey Econometrica(72)4 July 2004 "
disp in green "________________________________________________________________________________"

egen maxyear = max(year)
egen minyear = min(year)
local maxyearS = maxyear[1]
local minyearS = minyear[1]
drop maxyear minyear
local yearEXCLUDED = `minyearS'
mat define coeff1 = coeff1_ORIG
preserve

while (`yearEXCLUDED'<=`maxyearS'){
	restore
	preserve
	replace D=. if year==`yearEXCLUDED'
	replace Y=. if year==`yearEXCLUDED'
	local perd=1
	local niter=1
	local failed=0
		while (`perd'>=0.0000001){
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
				mata coeff1II= st_matrix("coeff1")
				mata coeff0II= st_matrix("coeff0")
				mata coeff1II=select(coeff1II,(coeff0II:!=0))
				mata coeff0II=select(coeff0II,(coeff0II:!=0))
				mata coeffdiffII=((coeff1II-coeff0II):/coeff0II)'((coeff1II-coeff0II):/coeff0II)
				mata st_matrix("coeffMSS",coeffdiffII)

				local perd = coeffMSS[1,1]
				if (`niter'>100){
					local perd=0
					local failed = `failed'+1
				}
				if (`niter'<=100){
					local niter = `niter'+1
				}

			qui reg `varlist' IMRN etahat if (D==0)
			mat define coeff3st=e(b)'
			
			}

	mat define COEFF=coeff2st\coeff3st\coeff1st
	mat define results = results, (COEFF)  
	sort id year
	mata ETAHAT = ETAHAT, st_data(.,"etahat")
	mata IMRN = IMRN, st_data(.,"IMRN")
	mata IMRS = IMRS, st_data(.,"IMRS")
	local yearEXCLUDED=`yearEXCLUDED'+1
	local iterD = `yearEXCLUDED'-`minyearS'
	local iterT = `maxyearS'-`minyearS'+1
	disp in green "N. of iterations done `iterD' Total number of iterations `iterT'" 
	disp in green "N. of obs. in Sel. Eq: `Nprobit' - N. of obs. in Wage Eq.: `Nreg'"
	disp in green "________________________________________________________________________________"
}
sort id year
mata id=st_data(.,"id")
mata year=st_data(.,"year")
mata results= st_matrix("results")
mata resultsBC = (cols(results)-1):*results[.,1] -  (cols(results)-2):*results[|1,2\rows(results),cols(results)|]*J(cols(results)-1, 1,1/(cols(results)-1))
mata ETAHATBC = (cols(ETAHAT)-1):*ETAHAT[.,1] -  (cols(ETAHAT)-2):*ETAHAT[|1,2\rows(ETAHAT),cols(ETAHAT)|]*J(cols(ETAHAT)-1, 1,1/(cols(ETAHAT)-1))
mata IMRNBC = (cols(IMRN)-1):*IMRN[.,1] -  (cols(IMRN)-2):*IMRN[|1,2\rows(IMRN),cols(IMRN)|]*J(cols(IMRN)-1, 1,1/(cols(IMRN)-1))
mata IMRSBC = (cols(IMRS)-1):*IMRS[.,1] -  (cols(IMRS)-2):*IMRS[|1,2\rows(IMRS),cols(IMRS)|]*J(cols(IMRS)-1, 1,1/(cols(IMRS)-1))
restore
mata st_store(.,"etahat",ETAHATBC)
mata st_store(.,"IMRN",IMRNBC)
mata st_store(.,"IMRS",IMRSBC)


mata st_matrix("resultsBC",resultsBC)
matrix colnames resultsBC = BIAS-CORTD 
mata st_matrix("resultsORIG",results[.,1])
matrix colnames resultsORIG = Coeff 
mat define coeff1 = COEFF


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
	bsample, cluster(id_orig) idcluster(id)
	local perd=1
	local niter=1
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
	
drop  Y D maxD minD migrant etahat


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

mata meancoeff = mean(Results')'
mata Variancecoeff = variance(Results')'
mata pvalue = 1:- ((resultsBC:>0):*((Results:>0)*J(cols(Results),1,(1/cols(Results))))+ (resultsBC:<=0):*((Results:<=0)*J(cols(Results),1,(1/cols(Results)))))
mata stderror =  (diagonal(variance(Results'))):^0.5
mata st_matrix("pvalue",pvalue)
matrix colnames pvalue = P-value
mata STDcoeff=diagonal(Variancecoeff):^0.5
mata st_matrix("meanCOEFF",meancoeff)
matrix colnames meanCOEFF = BTP-MEAN
mata st_matrix("STDCOEFF",STDcoeff)
matrix colnames STDCOEFF = BTP-STD
mata st_matrix("stderror",stderror)
matrix colnames stderror = STD-DEV
mat define results = (coeffORIG, meanCOEFF, STDCOEFF, pvalue, resultsBC, stderror)
mat list results
capture drop etahat
gen etahat=.
mata st_store(.,"etahat",ETAHATBC)
end
