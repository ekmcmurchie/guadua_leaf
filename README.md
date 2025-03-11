## GENERAL INFORMATION 

DATA TITLE: *Guadua* micromorphology data, data wrangling, analysis, graphics, and associated documents
PROJECT TITLE: Foliage leaf and floral bract micromorphology vary by habitat and habit in *Guadua* (Poaceae: Bambusoideae: Bambuseae)  
DATA ABSTRACT: This repository contains the raw data, tidied data, associated documents, and code for data wrangling, data analysis, and graphics generation for the manuscript "Foliage leaf and floral bract micromorphology vary by habitat and habit in *Guadua* (Poaceae: Bambusoideae: Bambuseae)"

AUTHORS: 

	Author: Elizabeth K. McMurchie
	ORCID: 0000-0002-4917-4314
	Institution: Iowa State University
	Email: elkamcmurchie@gmail.com; mcmurch@iastate.edu

    	Author: Josephine A. Crock
	Institution: Iowa State University
	Email: jaccrock@iastate.edu

   	 Author: Devin Molnau
	Institution: Iowa State University
	Email: demolnau@iastate.edu

	Author: Haldre S. Rogers
	ORCID: 0000-0003-4763-5006
	Institution: Virginia Tech
	Email: haldre@vt.edu

	Author: Dean C. Adams
	ORCID: 0000-0001-9172-7894
	Institution: Iowa State University
	Email: dcadams@iastate.edu

	Author: Lynn G. Clark
	ORCID: 0000-0001-5564-4688
	Institution: Iowa State University
	Email: lgclark@iastate.edu

	Corresponding author: Elizabeth K. McMurchie 

ASSOCIATED PUBLICATIONS: Foliage leaf and floral bract micromorphology vary by habitat and habit in *Guadua* (Poaceae: Bambusoideae: Bambuseae)


### FILE DIRECTORY 

#### FILE LIST

1. 'analysis'

	-'README_analysis.MD' contains the README information for the 'analysis' subdirectory

	-'guadua_leaf_micromorphology_analysis.Rmd' contains R code used analyze *Guadua* foliage leaf data. The 'RRPP' (Collyer and Adams, 2024, 2018), 'geomorph'(Baken et al, 2021; Adams et al., 2025), 'tidyverse' (Wickham et al., 2023, 2019),'ade4' (Bougeard and Dray, 2018; Chessel et al., 2004; Dray et al., 2023, 2007; Dray and Dufour, 2007; Thioulouse et al., 2018), 'vegan' (Oksanen et al., 2025), and 'pander' (Daróczi and Tsegelskyi, 2022) R packages were used to assist in data analysis, including visualization of statistics using tables and principal coordinates analysis (PcoA).

	-'guadua_floret_micromorphology_analysis.Rmd' contains R code used analyze *Guadua* floral bract data. The 'RRPP' (Collyer and Adams, 2024, 2018), 'geomorph'(Baken et al, 2021; Adams et al., 2025), 'tidyverse' (Wickham et al., 2023, 2019),'ade4' (Bougeard and Dray, 2018; Chessel et al., 2004; Dray et al., 2023, 2007; Dray and Dufour, 2007; Thioulouse et al., 2018), 'vegan' (Oksanen et al., 2025), and 'pander' (Daróczi and Tsegelskyi, 2022) R packages were used to assist in data analysis, including visualization of statistics using tables and principal coordinates analysis (PcoA).



2. 'data' contains 'README_data.MD', which includes the README information for the 'data' subdirectory, and two further subdirectories: 
	
	A. 'data_raw' contains 'README_data_raw', the README information for the 'data_raw' subdirectory, was well as the raw data files 'guadua_leaf_raw_3.xlsx' and 'guadua_lemmas_paleas_raw_3.xlsx'.
		
	-'guadua_leaf_raw_3.xlsx' is the original raw data file for raw *Guadua* leaf micromorphology data. For definitions of all variables, see 'Appendix A data_dictionary_leaf.docx' for the foliage leaf data dictionary. 
		
	-'guadua_lemmas_paleas_raw_3.xlsx' is the original raw data file for raw *Guadua* floral bract micromorphology data. For definitions of all variables, see 'Appendix B data_dictionary_floret.docx' for the floral bract data dictionary. 
	
	B. 'data_tidy' contains 'README_data_tidy', the README information for the 'data_tidy' subdirectory, 'guadualeaf.csv', and 'guaduafloret.csv'.
	
	-'guadualeaf.csv' includes tidied *Guadua* foliage leaf data prepared for analysis. It is the product of using 'tidying_guadua_leaf.Rmd' on 'guadua_leaf_raw_3.xlsx' for tidying.
	
	-'guaduafloret.csv' includes tidied *Guadua* floral bract data prepared for analysis. It is the product of using 'tidying_guadua_floret.Rmd' on 'guadua_lemmas_paleas_raw_3.xlsx' for tidying. 


3. 'data_wrangling'

	-'README_data_wrangling.MD' contains the README information for the 'data_wrangling' subdirectory

	-'tidying_guadua_leaf.Rmd' contains R code used to tidy data from 'guadua_leaf_raw_3.xlsx' for analysis. The 'tidyverse' (including 'readr') (Wickham et al., 2023, 2019) and 'readxl' (Wickham and Bryan, 2023) R packages were used to assist in tidying of data. 

	-'tidying_guadua_floret.Rmd' contains R code used to tidy data from 'guadua_lemmas_paleas_raw_3.xlsx' for analysis. The 'tidyverse' (including 'readr') (Wickham et al., 2023, 2019) and 'readxl' (Wickham and Bryan, 2023) R packages were used to assist in tidying of data. 


4. 'documents'

	-'README_documents.MD' contains the README information for the 'documents' subdirectory

	-'specimen_data.xlsx' contains basic information about all specimens used in this study. These data include specimen collector and number, species (and subspecies, when applicable) identification, country in which specimens were collected, general habit for the species, general habitat for the species, herbarium at which the specimen is deposited, photographer (Elizabeth K. McMurchie, EKM, or Lynn G. Clark, LGC) who imaged each floral bract and/or foliage leaf specimen, which researcher (Elizabeth K. McMurchie, EKM, or Josephine A. Crock, JAC) categorized presence/absence of micromorphological features on foliage leaves and floral bracts, and metal sputter coating used on foliage leaves and floral bracts (Au, gold, Pt, platinum, or Ir, iridium) prior to imaging. 
	
	-'Appendix A data_dictionary_leaf.docx' contains the data dictionary for foliage leaf micromorphology classification. This includes the definitions for all variables used in 'guadua_leaf_raw_3.xlsx'. Variables are primarily defined with reference to Ellis (1979), with additional reference to Cunha Santana (2017) and ICPT (2019).

	-'Appendix B data_dicitonary_floret.docx' contains the data dictionary for floral bract micromorphology classification. This includes the definitions for all variables used in 'guadua_lemmas_paleas_raw_3.xlsx'. Variables are primarily defined with reference to Ellis (1979), with additional reference to Cunha Santana (2017) and ICPT (2019).


5. 'graphics'
	-'README_graphics.MD' contains the README information for the 'graphics' subdirectory

	-'guadua_leaf_micromorphology_graphics.Rmd' contains R code used to create the graphics related to foliage leaf micromorphology data used in the manuscript and supplementary material. 'tidyverse' was used to run 'ggplot2', which was required for graphics (Wickham et al., 2023, 2019). The packages 'ade4' (Bougeard and Dray, 2018; Chessel et al., 2004; Dray et al., 2023, 2007; Dray and Dufour, 2007; Thioulouse et al., 2018) and 'vegan' (Oksanen et al., 2025) were required for PCoA. Correlation tables were created using 'ggcorrplot' (Kassambara, 2023; Kassambara and Patil, 2023). ColorBrewer 2.0 was used to assist in selection of colors used in the PCoA (Brewer et al, 2013).

	-'guadua_floret_micromorphology_graphics.Rmd' contains R code used to create the graphics related to floral bract micromorphology data used in the manuscript and supplementary material. 'tidyverse' was used to run 'ggplot2', which was required for graphics (Wickham et al., 2023, 2019). The packages 'ade4' (Bougeard and Dray, 2018; Chessel et al., 2004; Dray et al., 2023, 2007; Dray and Dufour, 2007; Thioulouse et al., 2018) and 'vegan' (Oksanen et al., 2025) were required for PCoA. Correlation tables were created using 'ggcorrplot' (Kassambara, 2023; Kassambara and Patil, 2023). ColorBrewer 2.0 was used to assist in selection of colors used in the PCoA (Brewer et al, 2013).


### PACKAGE REFERENCES

Adams, D., Collyer, M., Kaliontzopoulou, A., Baken, E., 2025. geomorph: Geometric Morphometric Analyses of 2D/3D Landmark Data. 4.0.10 (Version 4.0.10). GitHub. 
	https://github.com/geomorphR/geomorph.

Baken, E.K., Collyer, M.L., Kaliontzopoulou, A., Adams, D.C., 2021. geomorph v4.0 and gmShiny: Enhanced analytics and a new graphical interface for a comprehensive 	morphometric experience. Methods Ecol. Evol. 12, 2355–2363. https://doi.org/10.1111/2041-210X.13723.

Bougeard, S., Dray, S., 2018. Supervised multiblock analysis in R with the ade4 package. J. Stat. Soft. 86. https://doi.org/10.18637/jss.v086.i01.

Chessel, D., Dufour, A., Thioulouse, J., 2004. The ade4 package - I : One-table methods. R News 4, 5–10. ISSN 1609–3631.

Collyer, M., Adams, D., 2024. RRPP: Linear Model Evaluation with Randomized Residuals in a Permutation Procedure. 2.1.0 (Version 2.1.0). GitHub. 	https://github.com/mlcollyer/RRPP.

Collyer, M.L., Adams, D.C., 2018. RRPP: An r package for fitting linear models to high-	dimensional data using residual randomization. Methods Ecol. Evol. 9, 1772–1779. 	https://doi.org/10.1111/2041-210X.13029.

Daróczi, G., Tsegelskyi, R., 2022. pander: An R “Pandoc” Writer. 0.6.5 (Version 0.6.5). GitHub.	https://github.com/Rapporter/pander.

Dray, S., Dufour, A., Chessel, D., 2007. The ade4 package - II: Two-table and K-table methods. R News 7, 47–52. ISSN 1609-3631.

Dray, S., Dufour, A.-B., 2007. The ade4 Package: Implementing the duality diagram for ecologists. J. Stat. Soft. 22. https://doi.org/10.18637/jss.v022.i04.

Dray, S., Dufour, A.-B., Thioulouse, and J., Jombart, with contributions from T., Pavoine, S., Lobry, J.R., Ollier, S., Borcard, D., Legendre, P., Chessel, S.B. and A.S.B. on 	earlier work by D., 2023. ade4: Analysis of Ecological Data: Exploratory and Euclidean Methods in Environmental Sciences. 1.7-22 (Version 1.7-22). GitHub. 	
	http://pbil.univ-lyon1.fr/ADE-4/.

Kassambara, A., 2023. ggcorrplot: Visualization of a Correlation Matrix using 'ggplot2'. 0.1.4.1 (Version 0.1.4.1). CRAN: The Comprehensive R Archive Network. 	https://CRAN.R-	project.org/package=ggcorrplot.

Kassambara, A., Patil, I., 2023. ggcorrplot: Visualization of a Correlation Matrix using “ggplot2.” 0.1.4.1 (Version 0.1.4.1). STHDA: Statistical tools for high-throughput 	data analysis. http://www.sthda.com/english/wiki/ggcorrplot-visualization-of-a-correlation-matrix-using-ggplot2.

Oksanen, J., Simpson, G.L., Blanchet, F.G., Kindt, R., Legendre, P., Minchin, P.R., O’Hara, R.B., Solymos, P., Stevens, M.H.H., Szoecs, E., Wagner, H., Barbour, M., Bedward, 	M., Bolker, B., Borcard, D., Carvalho, G., Chirico, M., De Caceres, M., Durand, S., Evangelista, H.B.A., FitzJohn, R., Friendly, M., Furneaux, B., Hannigan, G., Hill, 	M.O., Lahti, L., McGlinn, D., Ouellette, M.-H., Ribeiro Cunha, E., Smith, T., Stier, A., Ter Braak, C., Weedon, J., Borman, T. 2025. vegan: Community Ecology Package. 	2.6-10 (Version 2.6-10). GitHub. https://github.com/vegandevs/vegan.


### ADDITIONAL REFERENCES

Brewer, C., Harrower, M., Sheesley, B., Woodruff, A., Heyman, D., 2013. ColorBrewer: Color advice for cartography. 2.0 (Version 2.0). Axis Maps. https://colorbrewer2.org/#.

Cunha Santana, J.M., 2017. Análise estrutural e micromorfológica da lâmina foliar de populações de *Guadua* Kunth (Poaceae: Bambusoideae: Guaduinae) ocorrentes no Brasil 	(Master). Universidade de Brasília. https://doi.org/10.26512/2017.01.D.24783.

Ellis, R.P., 1979. A procedure for standardizing comparative leaf anatomy in the Poaceae. II. The epidermis as seen in surface view. Bothalia 12, 641–671. 	https://doi.org/10.4102/abc.v12i4.1441.

International Committee for Phytolith Taxonomy (ICPT), Neumann, K., Strömberg, C.A.E., 	Ball, T., Albert, R.M., Vrydaghs, L., Cummings, L.S., 2019. International Code for 	Phytolith Nomenclature (ICPN) 2.0. Ann. Bot. 124, 189–199. https://doi.org/10.1093/aob/mcz064.


### LICENSING 

This work is licensed under the Creative Commons Attribution (CC-BY) 4.0 International License. 
For more information visit: [https://creativecommons.org/licenses/by/4.0 ](https://creativecommons.org/licenses/by/4.0)