# Definitions

* N = Number of mainline links
* T = Number of time steps with boundary conditions specified

# Data Structures

## Output States

### Density

* rho: (T+1) x (N) matrix
* rho(k,i) = density cars/ meter on link i at time k

### Ramp queues

* l: (T+1) x (N) matrix
* l(k,i) = cars on the onramp ENTERING link i at time k

### Fluxes

* For each link, time:
	* flux in
	* flux out
	* ramp flux
	