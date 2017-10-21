## Distribution Alignment Decoder (DAD)
This repo contains code to run the Distribution Alignment Decoder (DAD) method described in this paper.

__Eva L Dyer, Mohammad Gheshlaghi Azar, Matthew Perich, Hugo L Fernandes, Stephanie Naufel, Lee Miller, Konrad Kording: A cryptography-based approach for movement decoding, doi: [https://doi.org/10.1101/080861](https://doi.org/10.1101/080861)__

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

### Getting started...
1. Download Laurens van der Maaten's [dimensionality reduction toolbox](https://lvdmaaten.github.io/drtoolbox/code/drtoolbox.tar.gz). If you have difficulties running the mex files in the dimensionality reduction toolbox, please see the Section entitled "Pitfalls" in the Readme.txt in the drtoolbox.
2. To run the scripts and examples in this repository, download the data [here](https://www.dropbox.com/s/nrgnte5m34xb18n/DAD-data-10-21-2017.zip?dl=0). Once you download and unzip this folder, put both of the folders (data and parameter_matfiles) in the /data folder.
3. In Matlab, run our demo:
``` matlab
script_runDAD
```
This script will run DAD on data collected from Subject M and visualize the results.
___

<img width="1100" src="https://github.com/KordingLab/DAD/blob/master/images/MainFig_GitHubSite.jpg" data-action="zoom">


