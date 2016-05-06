## Distribution Alignment Decoder (DAD) 
This repo contains code to run the Distribution Alignment Decoder (DAD) method described in following paper. 

__Dyer EL, Azar MG, Fernandes HL, Perich M, Miller L, and Kording KP "Cracking the neural code: A cryptography-inspired approach to movement decoding", arXiv 2016.__

If you use any of the code or data in this repository, please cite this paper.

### Overview
The main idea behind DAD is to decode movement kinematics from a neural dataset consisting of the firing rates of d neurons at N points in time. Typically, the number of time points exceeds the number of neurons.

DAD takes a neural dataset __Y__ as its input, along with a target kinematics dataset __X__ to align __Y__ to. In our implementation, we assume __X__ is a Tx2 matrix and __Y__ is a Nxd matrix, where N and T are, in general, not equal.

### 1. Getting started...
To start, run the script __script_main_may_5_2016.m__. This script will create a random partition of the dataset into a training and test set and then run DAD for different amounts of training and test.

The main function needed to run DAD is called __runDAD.m__. To use this function, simply define __Yte__ as the matrix of neural activity (test set), __Xtr__ as the training 2D kinematics (train set), and the __gridsz__ as the number of grid points (in each dimension) to minimize the 3D KL over. 

```matlab
Res = runDAD(Yte,Xtr,gridsz,Tte,Xte);
```
The output is a structure with the final and intermediate results. To plot the resulting predicted kinematics and ground truth side by side, use the following command.
```matlab
figure; subplot(1,2,1); colorData2014(Xte,Tte); title('Ground truth kinematics'); 
subplot(1,2,1); colorData2014(Res.Xrec,Tte);
```
