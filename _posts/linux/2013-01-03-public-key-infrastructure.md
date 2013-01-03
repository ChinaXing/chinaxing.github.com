---
layout: post
title: 公钥认证体系
category: linux
change_frequency: monthly
tag: ca,digtal-sign
---

[Public Key Infrastructure]<http://en.wikipedia.org/wiki/Public_key_infrastructure> 目的是进行数字认证

它的各个组成部分如图：
<img src=/images/Public-Key-Infrastructure.svg>

CA：certifacate Authority :权威认证机构，被完全信赖的。
RA：Regstration Authority :注册机构，执行实际的绑定。
VA：Validation Authority : 验证机构，根据CA的信息，对用户身份进行验证。

### 过程：
1. 用户产生自己的public-private key对和自己需要认证的身份信息，提交给RA进行认证(CSR)。
2. RA 根据用户提供的信息，确认符合（valid）后，提交与CA，CA对用户信息和公钥进行签名生成证书(Cert)，发给用户。
3. 用户发布数字产品的时候，对产品使用私钥进行签名，连同CA颁发给自己的证书一同发布。
4. 客户收到产品和证书，将证书发给VA，请求VA进行验证。
5. VA根据证书内容和CA的信息（公钥），判断此证书是CA签发的。告诉客户，该证书有效。
6. 客户使用证书里面的公钥解密产品，得到用户发布的产品。

### 自签名证书：
是使用自己的私钥进行签名生成的证书。而一般的证书是通过CA的私钥进行签名的。

**用途** [根CA]<http://en.wikipedia.org/wiki/Root_certificate>机构。因为没有更高层的CA来签发的证书(CA分级，低级别的CA由高级别的CA来进行认证)。

### 公钥认证在Web浏览器中应用：
当使用https协议浏览网站的时候，浏览器和网站服务器之间进行了对服务器身份的认证过程：
1. 服务器将自己的证书和公钥发给浏览器。
2. 浏览器根据内置的信赖CA列表中找到证书的签发CA，如果没找到，认为证书是不可信赖的，提示用户Dangerous。
3. 根据证书提供的或者是CA提供的证书有效性验证信息获取地址，获取证书有效性数据（CRL），判断证书是否还有效（Revocation）。如果无效，则同样认为不可信赖。 此步骤使用CRL协议或OCSP协议获取CRL信息。
4. 证书认证完毕，信息可靠。进入密钥协商过程。
5. 浏览器选择一个密钥和对称加密算法，使用服务器的公钥进行加密后发给服务器。
6. 服务器知道了后续通信使用的密钥和算法，之后的通信都使用这个对称加密算法和密钥来对数据加密进行。

#### **[CRL]<http://en.wikipedia.org/wiki/Certificate_revocation_list>**：
certificate revocation list: 是CA生成的用来发布告知哪些被签名的公钥现在是无效的（无效不等于过期）。一般是用户私钥丢失等，用户主动通知CA标记为无效，类似信用卡密码丢了，卡挂失的道理。

CRL使用 http协议来传输(不过为了客服其问题，一般已经使用[OCSP]<http://en.wikipedia.org/wiki/Online_Certificate_Status_Protocol>这个协议来代替它了)，由浏览器发起，chrome里面可以在高级设置->安全里面进行设置，打开*"Check for server certificate revocation"*, 来让浏览器对每个https域名证书都进行CRL验证。这个选项默认是关闭的。


### openssl 进行证书的签名过程：
**TODO**

### 其它:
1. 数字签名中CA/Web browser/developer关系图:

<img src=/images/Usage-of-Digital-Certificate.svg>

2. CA的Wiki:(http://en.wikipedia.org/wiki/Certificate_authority), 很不错的比较全面的介绍。