sudo apt-get install csh cmake g++
mkdir data lib 

# Install darwin
cd lib/
git clone https://github.com/sgould/drwn.git
cd drwn/external
./install.sh Eigen
./install.sh zlib
./install.sh OpenCV
./install.sh wxWidgets
./install.sh lua
cd ..
export DARWIN="./"
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${DARWIN}/external/opencv/lib
make
make drwnprojs
cd ../../

# piotr dollar's toolbox
cd lib/
git clone https://github.com/pdollar/toolbox.git
cd ../

# graz dataset
cd data/
wget http://www.vision.ee.ethz.ch/~rhayko/paper/cvpr2012_riemenschneider_lattice/graz50_facade_dataset.zip
unzip graz50_facade_dataset.zip
rm -rf graz
mv graz50_facade_dataset graz
cd graz/
mkdir data
mv images data/
mv labels_used labels
mv labels data/
rm -rf labels_full
wget http://files.is.tue.mpg.de/vjampani/fsdata/graz_folds.zip
unzip graz_folds.zip
mv graz_folds/set*.txt .
rm -rf graz_folds graz_folds.zip
cd ../
rm -rf graz50_facade_dataset.zip graz50_facade_dataset_readme.txt
cd ../


