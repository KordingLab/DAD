## Distribution Alignment Decoder (DAD)
This repo contains code to run the Distribution Alignment Decoder (DAD) method described in this paper.

__Dyer, E. L., Azar, M. G., Perich, M. G., Fernandes, H. L., Naufel, S., Miller, L. E., & Körding, K. P. (2017). A cryptography-based approach for movement decoding. Nature Biomedical Engineering, 1(12), 967. [doi:10.1038/s41551-017-0169-7](http://rdcu.be/Bafy)__

If you use any of the datasets and/or code in this repository, please cite this paper. If you have questions, please contact evaLdyer{at}gmail{dot}com.
___
### Overview
The main idea behind DAD is to decode movement kinematics from a neural dataset consisting of the firing rates of d neurons at N points in time. Typically, the number of time points exceeds the number of neurons.

DAD takes a neural dataset __Y__ as its input, along with a target kinematics dataset __X__ to align __Y__ to. In our implementation, we assume __X__ is a Tx2 matrix and __Y__ is a Nxd matrix, where N and T are not assumed to be equal.
___
### What's here... ###
* __code__
    - _main_. this folder contains the main codes and helper tools needed to run DAD.
    - _supdecoder_. this folder contains code to implement a supervised decoder trained via 10-fold cross-validation to fit the regularization parameter in the supervised case.
    - _utils_. this folder contains helper functions (i.e., compute R2 scores, plot data, bin and split neural datasets).

### Running DAD on data from Subject M ...
1. In Matlab, include all of the folders in this repo to your path and then run our demo:
``` matlab
script_runDAD
```
This script will run DAD on data collected from Subject M and visualize the results.
* Note: To run this demo, you will need the Statistics toolbox in Matlab.* 

### Running DAD on data from Subject C ...
1. Our method can be used with a variety of different dimensionality reduction methods. To run this demo and try different methods for dimensionality reduction, download Laurens van der Maaten's [dimensionality reduction toolbox](https://lvdmaaten.github.io/drtoolbox/code/drtoolbox.tar.gz). If you have difficulties running the mex files in the dimensionality reduction toolbox, please see the Section entitled "Pitfalls" in the Readme.txt in the drtoolbox.
1. In Matlab, include all of the folders in this repo to your path and then run our demo:
``` matlab
script_runDAD_comparewithsup
```
This script will run DAD, the oracle decoder, linear supervised method, and Kalman filter on data collected from Subject C.
* Note: To run this demo, you will need the Statistics toolbox in Matlab.* 

### Exploring DAD on more datasets...
1. To run the other scripts and examples in this repository, you will need to download the data [here](https://www.dropbox.com/s/nrgnte5m34xb18n/DAD-data-10-21-2017.zip?dl=0). Once you download and unzip this folder, put both of the folders (data and parameter_matfiles) in the /data folder.
___

<img width="1100" src="https://github.com/KordingLab/DAD/blob/master/images/MainFig_GitHubSite.jpg" data-action="zoom">


