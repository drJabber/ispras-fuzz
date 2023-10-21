FROM aflplusplus/aflplusplus:stable

WORKDIR /build

RUN cat /etc/os-release && \
    apt update && \
    apt install -y libssl-dev libpcap-dev && \
    echo "install libssl 1.0.0" && \    
    wget -c http://security.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0.0_1.0.2n-1ubuntu5_amd64.deb && \
    dpkg -x libssl1.0.0_1.0.2n-1ubuntu5_amd64.deb /build/libssl1.0.0 && \
    cp -arfv /build/libssl1.0.0/lib/x86_64-linux-gnu/* /usr/local/lib/ && \
    cp -arfv /build/libssl1.0.0/usr/lib/x86_64-linux-gnu /usr/local/lib/ && \
    cp -arfv /build/libssl1.0.0/usr/lib/* /usr/local/lib/ && \
    cp -arfv /build/libssl1.0.0/usr/share/* /usr/local/share/ && \
    cp -arfv /build/libssl1.0.0/lib/x86_64-linux-gnu/* /usr/lib/  && \
    cp -arfv /build/libssl1.0.0/usr/lib/x86_64-linux-gnu /usr/lib/ && \
    cp -arfv /build/libssl1.0.0/usr/lib/* /usr/lib/ && \
    cp -arfv /build/libssl1.0.0/usr/share/* /usr/share/ && \
    echo "install libssl 1.0.0-dev" && \    
    wget -c http://security.ubuntu.com/ubuntu/pool/main/o/openssl1.0/libssl1.0-dev_1.0.2n-1ubuntu5.13_amd64.deb && \
    dpkg -x libssl1.0-dev_1.0.2n-1ubuntu5.13_amd64.deb /build/libssl1.0-dev && \
    cp -arfv /build/libssl1.0-dev/usr/include/openssl /usr/include/openssl1.0.2n && \
    cp -arfv /build/libssl1.0-dev/usr/include/x86_64-linux-gnu/openssl /usr/include/x86_64-linux-gnu/openssl1.0.2n && \
    cp -arfv /build/libssl1.0-dev/usr/lib/x86_64-linux-gnu/pkgconfig/libcrypto.pc /usr/lib/x86_64-linux-gnu/pkgconfig/libcrypto1.0.2n.pc && \
    cp -arfv /build/libssl1.0-dev/usr/lib/x86_64-linux-gnu/pkgconfig/libssl.pc /usr/lib/x86_64-linux-gnu/pkgconfig/libssl1.0.2n.pc && \
    cp -arfv /build/libssl1.0-dev/usr/lib/x86_64-linux-gnu/pkgconfig/openssl.pc /usr/lib/x86_64-linux-gnu/pkgconfig/openssl1.0.2n.pc && \
    cp -arfv /build/libssl1.0-dev/usr/lib/x86_64-linux-gnu/libcrypto.a /usr/lib/x86_64-linux-gnu/libcrypto1.0.2n.a && \
    cp -arfv /build/libssl1.0-dev/usr/lib/x86_64-linux-gnu/libcrypto.so /usr/lib/x86_64-linux-gnu/libcrypto1.0.0.so && \ 
    cp -arfv /build/libssl1.0-dev/usr/lib/x86_64-linux-gnu/libssl.so /usr/lib/x86_64-linux-gnu/libssl1.0.0.so


