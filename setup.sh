
mkdir data lib 
# Install darwin
#git clone https://github.com/sgould/drwn.git
#cd external
#./install.sh Eigen
#cd ..
#cd external
#./install.sh zlib
#./install.sh OpenCV
#./install.sh wxWidgets
#./install.sh lua
#cd ..
#export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${DARWIN}/external/opencv/lib
#make
#make drwnprojs

# piotr dollar's toolbox
cd lib/
git clone https://github.com/pdollar/toolbox.git
cd ../

# graz dataset
cd data/
wget http://www.vision.ee.ethz.ch/~rhayko/paper/cvpr2012_riemenschneider_lattice/graz50_facade_dataset.zip
unzip graz50_facade_dataset.zip
mv graz50_facade_dataset graz
cd graz/
mkdir data
mv images data/
mv labels_used labels
mv labels data/
rm -rf labels_full
wget http://files.is.tue.mpg.de/vjampani/graz_folds.zip 
unzip graz_folds.zip
mv graz_folds/set*.txt .
rm -rf graz_folds graz_folds.zip
cd ../
rm -rf graz50_facade_dataset.zip graz50_facade_dataset_readme.txt
cd ../


