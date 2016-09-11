**Efficient Facade Segmentation Using Auto-context**

This package contains the code for "Efficient Facade Segmentation Using Auto-context". If you use this code, please consider citing the following papers.

```
#!bibtex


@inproceedings{jampani2015efficient,
  title={Efficient facade segmentation using auto-context},
  author={Jampani, Varun and Gadde, Raghudeep and Gehler, Peter V},
  booktitle={2015 IEEE Winter Conference on Applications of Computer Vision},
  pages={1038--1045},
  year={2015},
  organization={IEEE}
}

@article{gadde2016efficient,
  title={Efficient 2D and 3D Facade Segmentation using Auto-Context},
  author={Gadde, Raghudeep and Jampani, Varun and Marlet, Renaud and Gehler, Peter V},
  journal={arXiv preprint arXiv:1606.06437},
  year={2016}
}


```

The code has been tested to work on Ubuntu 14.04 using Matlab R2012a. Please follow the below steps to use this code. 
1) run setup.sh This will install the [Darwin](https://github.com/sgould/drwn) library and the [Piotr's Computer Vision Matlab Toolbox](https://github.com/pdollar/toolbox). Note that the [Graz dataset](http://www.vision.ee.ethz.ch/~rhayko/paper/cvpr2012_riemenschneider_lattice/) is also downloaded.
2) run src/run.sh This will use the auto-context framework to train and test on the Graz dataset. 

* Upon running the code successfully, you should get around on the Graz dataset.
* The training may take several hours. If you have more multiple-cores on your machine consider changing the "drwnThreadPool" attribute. Currently it is set to 8.
* Results are stored in out/graz/fold[1-5]. The dataset is divided into 5 folds (see data/graz folder). For fold1, set[1,2,3,4] are used for training and set5 for testing. For fold2, set[1,2,3,5] as training and set4 for testing.