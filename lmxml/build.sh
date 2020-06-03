
PRFX=$1
MAKE=$2
PKG=mxml-2.12.tar.gz
DIR=mxml-2.12
OUT=`pwd`/out
rm ${DIR}/ ${OUT}/ -rf

tar -xf ${PKG}
cd ${DIR}/
./configure --host=${PRFX%-*} \
    --prefix=${OUT} --exec-prefix=${OUT} \
    --enable-threads --enable-shared
sed -i "/^ARFLAGS/c ARFLAGS=-crD" Makefile
sed -i "/^RANLIB/c RANLIB=${PRFX}ranlib -D" Makefile
${MAKE}
${MAKE} -i install # -i ignore warning
# ${MAKE} -i install-exec
# ${MAKE} -i install-data
cd -
mv ${OUT}/include ${OUT}/inc
rm ${OUT}/bin -rf
rm ${OUT}/share -rf
rm ${OUT}/lib/pkgconfig -rf
rm ${OUT}/lib/*.so* -f

rm ${DIR} -rf

