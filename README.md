## Distribution Alignment Decoder (DAD)
This repo contains code to run the Distribution Alignment Decoder (DAD) method described in this paper.

__Eva L Dyer, Mohammad Gheshlaghi Azar, Hugo L Fernandes, Matthew Perich, Stephanie Naufel, Lee Miller, Konrad Kording: A cryptography-based approach for movement decoding, doi: [https://doi.org/10.1101/080861](https://doi.org/10.1101/080861)__

If you use any of the datasets and/or code in this repository, please cite this preprint. If you have questions, please contact evaLdyer{at}gmail{dot}com.
___
### Overview
The main idea behind DAD is to decode movement kinematics from a neural dataset consisting of the firing rates of d neurons at N points in time. Typically, the number of time points exceeds the number of neurons.

DAD takes a neural dataset __Y__ as its input, along with a target kinematics dataset __X__ to align __Y__ to. In our implementation, we assume __X__ is a Tx2 matrix and __Y__ is a Nxd matrix, where $N$ and $T$ are not assumed to be equal.
___
### What's here... ###
* __code__
    - _main_. this folder contains the main codes and helper tools needed to run DAD.
    - _supdecoder_. this folder contains code to implement a supervised decoder trained via 10-fold cross-validation to fit the regularization parameter in the supervised case.
    - _utils_. this folder contains helper functions (i.e., compute R2 scores, plot data, bin and split neural datasets).
* __data__.
    - this folder contains multiple neural (spikes) and kinematics datasets collected from the M1 area of three non-human primate (NHP) subjects, Subject M (Mihi), Subject C (Chewie), and Subject J (Jango). See our paper for details about these datasets.

### Getting started...
1. Download Laurens van der Maaten's [dimensionality reduction toolbox](https://lvdmaaten.github.io/drtoolbox/code/drtoolbox.tar.gz)
2. In Matlab, run our demo:
``` matlab
script_runDAD
```
This script will run DAD on data collected from Subject M and visualize the results.
___

<img width="1100" src="https://github.com/KordingLab/DAD/blob/master/images/MainFig_GitHubSite.jpg" data-action="zoom">

If you have difficulties running the mex files in the dimensionality reduction toolbox (above), please see the Section entitled "Pitfalls" in the Readme.txt in the drtoolbox.
