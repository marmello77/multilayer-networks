# multilayer-networks

A tutorial on how to draw multilayer networks in R.

[Ecological Synthesis Lab](https://marcomellolab.wordpress.com) (SintECO).

Authors: Marco Mello & Renata Muylaert.

E-mail: marmello@usp.br. 

First published on November 23rd, 2017 (English version).

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4122503.svg)](https://doi.org/10.5281/zenodo.4122503)

Run in R version 4.0.2 (2020-06-22) -- "Taking Off Again"

Disclaimer: You may use this software freely for any purposes at your own risk. We assume no responsibility or liability for the use of this software, convey no license or title under any patent, copyright, or mask work right to the product. We reserve the right to make changes in the software without notification. We also make no representation or warranty that such application will be suitable for the specified use without further testing or modification. If this software helps you produce any academic work (paper, book, chapter, dissertation, report, talk, lecture or similar), please acknowledge the authors and cite the source, using the DOI or URL of this GitHub repository.


## Functionality and origin

The first version of this script was written as part of the analysis carried out by [Mello et al. (2019, NatureEcoEvo)](https://doi.org/10.1038/s41559-019-1002-3). Since then, we have been working on making the code shorter, faster, and easier to be used by other people interested in the same topics. You may use this code to learn how to input data on multilayer networks in R, as well to visualize those data as multilayer graphs.


## List of folders and files

1. data (folder)

    a. net1.xlsx -> complete data set from Genrich et al. (2017). Interactions between marsupials, rodents, and plants.

    b. net1an.txt -> angatonistic layer of net1. Seed destruction by marsupials and rodents.

    c. net1links.txt -> the links (edges) of net1 with additional attributes.

    d. net1mu.txt -> mutualistic layer of net1. Seed dispersal by marsupials and rodents.

    e. net1nodes.txt -> the nodes (vertices) of net1 with additional attributes.


2. figures (folder)

    a. net1.png -> multilayer graph of net1.
    

3. multilayer-networks -> script to draw and analyze multilayer networks.


## Instructions

Follow the instructions provided in the script "multilayer-networks.R".


## Data source

* Genrich, C. M., Mello, M. A. R., Silveira, F. A. O., Bronstein, J. L., & Paglia, A. P. (2017). [Duality of interaction outcomes in a plant-frugivore multilayer network](https://doi.org/10.1111/oik.03825). Oikos, 126(3), 361–368. doi: 10.1111/oik.03825


## Feedback

If you have any questions, corrections, or suggestions, please feel free to open and [issue](https://github.com/marmello77/multilayer-networks/issues) or make a [pull request](https://github.com/marmello77/multilayer-networks/pulls).


## Acknowledgments

We thank our labmates and our sponsors, especially the Alexander von Humboldt-Stiftung, CNPq, CAPES, and FAPESP, who gave us grants, fellowships, and scholarships. Pedro Jordano and Carsten Dormann helped us take our first steps in analyzing and drawing networks in R. Special thanks go to Katherine Ognyanova, who gave us invaluable tips on advanced network drawing in R. We strongly recommend her [online tutorial](http://kateto.net/network-visualization). Last, but not least, we thank the [Stack Overflow Community](https://stackoverflow.com), where we solve most of our coding dilemmas. A dilemma related to converting incidence matrices to make a multilayer network was solved [here](https://stackoverflow.com/questions/64486982/how-to-unite-two-graphs-in-r-to-form-a-multilayer-network).


## Suggested readings

* Barabasi, A.L. (2016) [Network Science](http://barabasi.com/networksciencebook/), 1st ed. Cambridge University Press, Cambridge.

* Bianconi, G. (2018). [Multilayer Networks: Structure and Function](https://amzn.to/31SAdRl). (1st ed.). Oxford: Oxford University Press.

* Mello MAR, Muylaert RL, Pinheiro RBP & Félix GMF. 2016. [Guia para análise de redes ecológicas](https://marcomellolab.wordpress.com/software/). Edição dos autores, Belo Horizonte. 112 p. ISBN-13: 978-85-921757-0-2.

* Mello, M. A. R., Felix, G. M., Pinheiro, R. B. P., Muylaert, R. L., Geiselman, C., Santana, S. E., … Stevens, R. D. (2019). [Insights into the assembly rules of a continent-wide multilayer network](https://doi.org/10.1038/s41559-019-1002-3). Nature Ecology & Evolution, 3(11), 1525–1532.

* Ognyanova K. 2019. [Static and dynamic network visualization with R](http://kateto.net/network-visualization).

* Pilosof, S., Porter, M. A., Pascual, M., & Kéfi, S. (2017). [The multilayer nature of ecological networks](https://doi.org/10.1038/s41559-017-0101). Nature Ecology & Evolution, 1(4), 0101.
