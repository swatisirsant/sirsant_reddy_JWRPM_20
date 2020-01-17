These are the sample codes for performing multi-objective design for Two loop WDN for cost minimization and RSM maximization. 
Note that the codes require epanet file and functions to run.
The description of each of the files is as follows:

NSGA_TL_CERI_ext : Main function for performing multi-objective design of TL WDN for cost minimization and CERI maximization

TL_netcost : Function for estimating cost for TL WDN

Entp_TL_ext : Function for estimating entropy for TL WDN for EPS

Res_TL_ext : Function for estimating resiliency for TL WDN for EPS

Net_Res_TL_ext : Function for estimating network resilience for TL WDN for EPS

CERI_TL_ext : Function for estimating CERI (combined entropy resiliency index) for TL WDN for EPS

CENRI_TL_ext : Function for estimating CENRI (combined entropy network resilience index) for TL WDN for EPS

Discrete_TL : Function for discretizing the decision variables

evaluate_objective : Function for estimating the objective function values

GA_new_gen : Function for generating the new population via NSGA-II algorithm

genetic_operator : Function for performing genetic operations

non_domination_sort_mod : Function for performing non-dominated sorting 

replace_chromosome : Function to select the population members for the next iteration

tournament_selection : Function for performing tournament selection
