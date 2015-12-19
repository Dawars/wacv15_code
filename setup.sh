sudo apt-get install csh cmake g++ libgtk2.0-dev pkg-config
mkdir data lib out

# Install darwin
cd lib/
git clone https://github.com/sgould/drwn.git
cd drwn/external
./install.sh Eigen
./install.sh zlib
./install.sh OpenCV
./install.sh wxWidgets
./install.sh lua

wget -O rapidxml-1.13.zip "http://downloads.sourceforge.net/project/rapidxml/rapidxml/rapidxml%201.13/rapidxml-1.13.zip?r=http%3A%2F%2Frapidxml.sourceforge.net%2F&ts=1364493742&use_mirror=garr"
unzip rapidxml-1.13.zip
mv rapidxml-1.13 rapidxml
cd ..

export DARWIN="$PWD"
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${DARWIN}/external/opencv/lib

make -j
make drwnprojs -j
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

