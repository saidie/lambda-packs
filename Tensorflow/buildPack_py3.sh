dev_install () {
    yum -y update
    yum -y upgrade
    yum install -y \
        python36-devel \
        python36-virtualenv \
        python36-pip \
        zip
}

pip_rasterio () {
    cd /home/
    rm -rf env
    python3 -m virtualenv env --python=python3
    source env/bin/activate
    pip install -U pip wheel numpy pillow tensorflow
    deactivate
}


gather_pack () {
    # packing
    cd /home/
    source env/bin/activate

    rm -rf lambdapack
    mkdir lambdapack
    cd lambdapack

    cp -R /home/env/lib{,64}/python3.6/site-packages/* .
    echo "original size $(du -sh /home/lambdapack | cut -f1)"

    # cleaning
    rm -rf external pip pip-* wheel wheel-* setuptools setuptools-* grpc tensorboard tensorboard-* easy_install.py
    find . -type d -name "test*" -exec rm -rf {} +
    find . -type d -name 'example*' -exec rm -rf {} +
    find . -type d -name 'include' -exec rm -rf {} +
    find . -name "*.so" -o -name "*.so.*" | xargs strip
    find . -name \*.pyc -delete

    echo "stripped size $(du -sh /home/lambdapack | cut -f1)"

    # compressing
    zip -FS -r9 /tmp/pack.zip * > /dev/null
    echo "compressed size $(du -sh /tmp/pack.zip | cut -f1)"
}

main () {
    dev_install
    pip_rasterio
    gather_pack
}

main
