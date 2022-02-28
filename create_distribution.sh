DIST_DIR=FRENKIEL_David-5MM50_projet_2020

rm $DIST_DIR.zip
rm -fr $DIST_DIR

mkdir $DIST_DIR

cp -R src $DIST_DIR
cp -R test $DIST_DIR

cp install_packages.jl $DIST_DIR
cp README.txt $DIST_DIR
cp out/slides.pdf $DIST_DIR

zip -r $DIST_DIR.zip $DIST_DIR
