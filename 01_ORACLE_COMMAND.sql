远程桌面连接 win+r --> mstsc   3389

SVN URL : https://192.168.2.9:8443/svn/r1/atreasury/ATS_PORJECT/10 Document/01 Input/Haier/170210HAIER-YK

Jenkins URL：http://192.168.2.12:8080/jenkins
jenkins web登录用户：admin/Zi5xian , sdg/wkopny976  ,  developer/developer
jenkins安装服务器：192.168.2.12  jenkins/jenkins
Start Jenkins
----------------------
/opt/jenkins/SOFTWARE/apache-tomcat-7.0.59/bin/startup.sh


Stop Jenkins
----------------------
/opt/jenkins/SOFTWARE/apache-tomcat-7.0.59/bin/shutdown.sh


Start Nginx
---------------------
cd /opt/jenkins/SOFTWARE/nginx/sbin
./nginx


Stop Nginx
-----------------------
cd /opt/jenkins/SOFTWARE/nginx/sbin
./nginx -s stop


企微云第三方：超级管理员：zhenyi.hu@meridian.com.cn 密码zi5xian@Shengyin

盛银服务器：
172.20.0.40  root/zi5xian
172.20.0.20  root/zi5xian$vm
172.20.0.30  root/rootroot
172.20.0.48 用户名是administrator，密码是test123！@#

###################
http://nexus.teamlinker.net/index.html#welcome
nexus_admin/Zi5xian


uat 打包log logachive  data 目录不用打包

修改配置文件
hosts
control/
.bash_profile


pbox
接入报价对接入数据进行处理

quoteser 

RMDSConnect_new.ini
FXP【PSSVr】  nohup ./start_pricingserver_ceda.sh 2>&1 &

update PAIRKEYS set SOURCE_SHORTNAME='ELEKTRON_DD';
update POINTKEYS set SOURCE_SHORTNAME='ELEKTRON_DD';
update RCV_DATA_CFG_TBL set EXT_SVC_NM='ELEKTRON_DD';