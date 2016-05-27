## Distribution Alignment Decoder (DAD) 
This repo contains code to run the Distribution Alignment Decoder (DAD) method described in this paper. 

__Dyer EL, Azar MG, Fernandes HL, and Kording KP "Cracking the neural code: A cryptography-inspired approach to movement decoding", arXiv 2016.__

If you have questions, please contact edyer{at}northwestern{dot}edu.
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
    - this folder contains multiple neural (spikes) and kinematics datasets collected from the M1 area of two non-human primate (NHP) subjects, Subject M (Mihili) and C (Chewie). See our paper for details about these datasets.

### Getting started...
In Matlab, run our DAD demo:
``` matlab
script_runDAD
```
This script will run DAD for three cases: within subject ('M'), combined subject ('MC'), and across subject ('C'). The output includes three structs, ResM, ResMC, and ResC, containing the embeddings for each case. If you decide to run the supervised decoder (which takes some time!), you can also find Xsup (supervised), Xave (average between DAD and Sup outputs), and Xls (the oracle estimate).
___

<img width="1100" src="https://github.com/KordingLab/DAD/blob/master/images/MainFig_GitHubSite.jpg" data-action="zoom">
