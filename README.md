# lai_scr
Computing summary LAI statistics for the Santa Clara River 

So far, just some simple interrogation to look at leaf area index (LAI) values for target plant species on the Santa Clara River (CA, USA) and some tests of diurnal stability in LP-80 ceptometer measurements. 

First, looked at how average LAI varied between individual instrumented plants from three species: _Arundo donax_ (AruDon), _Baccharis salicifolia_ (BacSal), and _Salix lasiolepis_ (SalLas). _A. donax_ had higher LAI values at the 'wet' sites in comparison to 'dry' sites. We saw no significant difference in LAI for wet and dry areas in _S. lasiolepis_, which had consistently high LAI. _A. donax_ LAI values were similar to _S. lasiolepis_ for the wet sites, but lower for dry sites.

![Leaf area index by plant type and hydrology](https://github.com/conormcmahon/lai_scr/blob/main/lai_physio.png)

_B. salicifolia_ had inconsistent differences between wet and dry sites for the two portions of the river that we studied - at the Lost Creek (upstream, slightly higher evaporative demand) and Freeman Diversion (downstream, slightly lower evaporative demand) sites. 

![Leaf area index by plant type and hydrology](https://github.com/conormcmahon/lai_scr/blob/main/lai_bacsal.png)

Tests of ceptometer measurement stability involved repeated sampling from the same individual trees, shrubs, and forbs in a suburban backyard setting over the course of a single sunny day - July 19, 2024. 

![Leaf area index by plant type and hydrology](https://github.com/conormcmahon/lai_scr/blob/main/lai_diurnal_change.png)

Light lines show diurnal changes in LAI retrieval for each individual sampling site. Darker lines show average values across each plant structural type. 

In general, measurements were relatively stable within the period from 2 hours before to 2 hours after solar noon (indicated above by dotted vertical lines). Outside of that period, the taller trees and shrubs showed pronounced decreases in LAI estimates during early or late periods, while the lower-form, less dense plants had less diurnal change. 

All of these results are using default parameters for the ceptometer, including χ = 1.0 for a spherical leaf distribution. Future work will require updates to use different leaf distribution parameters across species, especially for _A. donax_.
