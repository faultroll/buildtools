
PRFX=$1
MAKE=$2
PKG=cutest-1.5.zip
DIR=cutest-1.5
OUT=`pwd`/out
rm ${DIR}/ ${OUT}/ -rf

unzip -qo ${PKG}
mkdir -p ${OUT}
mv ${DIR}/CuTest.h ${OUT}/CuTest.h
mv ${DIR}/CuTest.c ${OUT}/CuTest.c
mv ${DIR}/make-tests.sh ${OUT}/make-tests.sh && chmod +x ${OUT}/make-tests.sh

rm ${DIR} -rf

