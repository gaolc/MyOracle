#!/bin/bash
S_UpdateVersion="${S_version}"
G_Version=`echo $S_version|awk -F '.'  '{print $1"."$2"."$3}'`
S_commitidstorageIP="172.19.192.46"
envname=`echo ${envname}|awk -F "-" '{print $2}'`
USER[0]=3038     #高龙成
WorkSpace=`pwd`
WORKPATH=/export/home/ccm/TS_db_Deploy/release_${S_version}
if [ -d $"WORKPATH" ];then
mkdir -p $WORKPATH
fi 
RETVAL=0
S_JenkinsMastetIp="172.19.192.46"
S_JenkinsMastetPort="8080"
S_UpdatedbProjectName="TS-DB-DEPLOY"
Desplay_Dir=/export/home/ccm/TS_db_Deploy
BUILDNUMBER=$(curl http://${S_JenkinsMastetIp}:${S_JenkinsMastetPort}/jenkins/job/${S_UpdatedbProjectName}-${G_Version}/lastBuild/buildNumber --user gaolongcheng_zwx:gaolongcheng_zwx)
S_BaseEncoded="UTF-8"
branches_name="http://200.31.147.77/TS/TS-DataBase.git"


INTERACTIVE_MODE=on
if [ $INTERACTIVE_MODE = off ];then
    LOG_DEFAULT_COLOR=""
    LOG_INFO_COLOR=""
    LOG_SUCCESS_COLOR=""
    LOG_WARN_COLOR=""
    LOG_ERROR_COLOR=""
else
    LOG_DEFAULT_COLOR=$(tput sgr 0)
    LOG_INFO_COLOR=$(tput sgr 0)
    LOG_SUCCESS_COLOR=$(tput setaf 2)
    LOG_WARN_COLOR=$(tput setaf 3)
    lOG_DEBUG_COLOR=$(tput setaf 4)
    LOG_ERROR_COLOR=$( tput bold && tput setaf 1)
fi

color_log() {
    local log_text=$1
    local log_level=$2
    local log_color=$3
    
    printf "${log_color}[$(date +"%Y-%m-%d %H:%M:%S %Z")] [$log_level] ${log_text} ${LOG_DEFAULT_COLOR}\n"
}
flag_log() {
echo "-------------------------------------------------------------------------------------"
}
log_info() { color_log "$1" "INFO" "$LOG_INFO_COLOR"; }
log_success() { color_log "$1" "SUCCESS" "$LOG_SUCCESS_COLOR"; }
log_warning() { color_log "$1" "WARNNING" "$LOG_WARN_COLOR"; }
log_error() { color_log "$1" "ERROR" "$LOG_ERROR_COLOR"; }
log_debug() { color_log "$1" "DEBUG" "$lOG_DEBUG_COLOR"; }
error_exit() {
    #send error massage to USER
    encoding=GBK
    msg=$(echo "Event：辅助交易系统 ${envname} 数据库部署失败!\
    Log:http://${S_JenkinsMastetIp}:${S_JenkinsMastetPort}/jenkins/job/${S_UpdatedbProjectName}-${G_Version}/${BUILDNUMBER}/console \
    Date：$(date +%Y/%m/%d-%H:%M:%S)    --Jenkins" | iconv -t $encoding)
    for user in ${USER[@]}
    do
        curl "http://200.31.147.138:6680/post.sdk?recv=${user}&send=3038&msg=$msg" &>/dev/null
    done
    
    exit 1
}


f_build_sql(){
log_info "Begin run f_build_sql function."
#更新之前每次执行一次删除所有目录的操作
ls -l | grep '^d'|awk '{print $NF}'|xargs rm -rf
#拉取本次项目的代码到本地
git clone ${branches_name}
if [ $? = 0 ];then
   log_success "git clone ${branches_name} code is successfuly."
else
   log_error "git clone ${branches_name} code is failed."
   error_exit
fi
cd TS-DataBase
#git checkout release_${S_branchname}
git checkout release_${G_Version}
git pull
if [ x"${pull_flag}" = x"Y" ];then
    log_info "Now Begin run update \"${S_UpdateVersion}\" Project sql file."
    if [ x"${full_update_flag}" = x"Y" ];then
        echo ${full_update_flag} > ${WORKPATH}/full_update_flag.txt
		log_info "get start_Revision..."
        #start_Revision=`git log --pretty=format:"%h %an %ar %s"|awk '{print $1}'|tail -1`
        #start_Revision="c54c5df"
        test -f /export/home/ccm/TS_db_Deploy/release_${S_version}/release_${S_version}_start_commitid
        if [ $? = 0 ];then
            log_info "Server {S_commitidstorageIP}:/export/home/ccm/TS_db_Deploy/release_${S_version}/release_${S_version}_start_commitid file exists." 
            start_Revision=`cat /export/home/ccm/TS_db_Deploy/release_${S_version}/release_${S_version}_start_commitid`
        else
            log_error "Server ${S_commitidstorageIP}:/export/home/ccm/TS_db_Deploy/release_${S_version}/release_${S_version}_start_commitid file not exists ." 
            error_exit
        fi
		if [ $? = 0 ];then
		   log_success "get start_Revision ${start_Revision} is successfuly."
		   echo ${start_Revision} > ${WORKPATH}/start_Revision.txt
		else
		   log_error "get start_Revision is Failed."
		   error_exit
		fi
		log_info "get end_Revision..."
        end_Revision=`git log --pretty=format:"%h %an %ar %s"|awk '{print $1}'|head -1`
		if [ $? = 0 ];then
		   log_success "get end_Revision ${end_Revision} is successfuly."
		   echo ${end_Revision} > ${WORKPATH}/end_Revision.txt
           echo "${end_Revision}" > ${WORKPATH}/${S_UpdateVersion}_start_Revision
		else
		   log_error "get end_Revision is Failed."
		   error_exit
		fi
		log_info "Current full_update_flag is \"${full_update_flag}\".so need run all update \"${S_UpdateVersion}\" Project sql file.and Revision is from \"${start_Revision}\" to \"${end_Revision}\"."
    elif [ x"${full_update_flag}" = x"N" ];then
        if [ -f ${WORKPATH}/${S_UpdateVersion}_start_Revision ];then
           echo ${full_update_flag} > ${WORKPATH}/full_update_flag.txt
		   log_info "get start_Revision..."
           start_Revision=`cat ${WORKPATH}/${S_UpdateVersion}_start_Revision`
		   if [ $? = 0 ];then
		      log_success "get start_Revision ${start_Revision} is successfuly."
		      cat ${WORKPATH}/${S_UpdateVersion}_start_Revision > ${WORKPATH}/start_Revision.txt
		   else
		      log_error "get start_Revision is Failed."
		      error_exit
		   fi
		   log_info "get end_Revision..."
           end_Revision=`git log --pretty=format:"%h %an %ar %s"|awk '{print $1}'|head -1`
		   if [ $? = 0 ];then
		      log_success "get end_Revision ${end_Revision} is successfuly."
		      echo ${end_Revision} > ${WORKPATH}/end_Revision.txt
		      echo "${end_Revision}" > ${WORKPATH}/${S_UpdateVersion}_start_Revision
		   else
		      log_error "get end_Revision is Failed."
		      error_exit
		   fi
        else
           log_error "Current full_update_flag is \"${full_update_flag}\".\"${WORKPATH}/${S_UpdateVersion}_start_Revision\" file not exists."
           error_exit
        fi
		log_info "Current full_update_flag is \"${full_update_flag}\".so not need all update \"${S_UpdateVersion}\" Project sql file.only update Revision is from \"${start_Revision}\" to \"${end_Revision}\"."
    fi
    
    if [ -f ${WORKPATH}/data.txt ];then
       rm -rf ${WORKPATH}/data.txt
    fi
	log_info "get ${WORKPATH}/data.txt..."
    git diff ${start_Revision} ${end_Revision} --name-only  > ${WORKPATH}/data.txt
    #开始排除因为合并代码引入的02_update目录下的sql文件
    echo 
    cat ${WORKPATH}/data.txt|egrep "01_scripts|02_update/update_TS_V${G_Version}" > ${WORKPATH}/data-tmp.txt
    mv ${WORKPATH}/data-tmp.txt ${WORKPATH}/data.txt
    ##结束排除因为合并代码引入的02_update目录下的sql文件
    cat ${WORKPATH}/data.txt|grep -i sql$ > ${WORKPATH}/data-tmp.txt
    mv ${WORKPATH}/data-tmp.txt ${WORKPATH}/data.txt
	if [ -s ${WORKPATH}/data.txt ];then
	   log_success "get release-${S_version} Revision ${start_Revision} ${end_Revision} change sql file is successfuly"
	else
	   log_warning "release-${S_version} Revision ${start_Revision} ${end_Revision} not exists change sql."
	   error_exit
	fi
    
    if [ -d ${Desplay_Dir}/${S_UpdateVersion} ];then
       rm -rf ${Desplay_Dir}/${S_UpdateVersion}
    fi
	log_info "begin cp $branches_name ${master_branch} change sql file..."
    cat ${WORKPATH}/data.txt|while read line
    do
    filepath=`echo $line |awk -F "/" 'gsub($(NF),"",$0)'`
    mkdir -p ${Desplay_Dir}/${S_UpdateVersion}/${filepath}
    cp ${line} ${Desplay_Dir}/${S_UpdateVersion}/${filepath}
    done
    rm -rf ${WORKPATH}/data.txt
    
    #begin tar sql file and run update srcipts
    cd $Desplay_Dir/${S_UpdateVersion}/
	#开始检查 sql 文件的编码
	S_Ckecktableorprocedure=`find . -type f -print|egrep "01_TSBASE|02_TSDEV|03_TSDEAL"`
	if [ -n "${S_Ckecktableorprocedure}" ];then
	   #find . -type f -print|egrep "05-table|10-procedure"|xargs file|awk -F "[:,]+" '{print $1 " "$2}' > Sqlfilelist
       find . -type f -print|egrep "01_TSBASE|02_TSDEV|03_TSDEAL"|xargs file|awk -F "[:,]+" '{if ($2 ~/C source/){print $1 " "$3}else{print $1 " "$2}}' > Sqlfilelist
	   log_success "${S_UpdateVersion} exists 01_TSBASE|02_TSDEV|03_TSDEAL update so need check files encoded."
	   while read line
	      do
	          S_Filepath=`echo $line|awk '{print $1}'|sed "s#^./##g"`
	          S_fileEncoded=`echo $line|cut -d " " -f 2-|sed "s/^[ \t]*//g"`
			  S_CheckfileEncoded=`echo ${S_fileEncoded}|egrep -w "${S_BaseEncoded}|ASCII"|grep -vw BOM`
	          if [ -n "${S_CheckfileEncoded}" ];then
	             log_success "${S_Filepath} is \"${S_fileEncoded}\" Encoded"
	          else
	             cd ${WorkSpace}/TS-DataBase
                 hash=`git log --pretty=oneline $S_Filepath |awk '{print $1}'|head -1`
	             S_SqlAutor=`git log --pretty=format:"%H %an %cd %s" |grep $hash |awk '{print $2}'`
	             cd $Desplay_Dir/${S_UpdateVersion}/
	             log_error "${S_SqlAutor}'${S_Filepath} is not \"${S_BaseEncoded}\" Encoded and it is \"${S_fileEncoded}\" Encoded"
				 echo "${S_SqlAutor}'${S_Filepath} is not \"${S_BaseEncoded}\" Encoded and it is \"${S_fileEncoded}\" Encoded" > SqlEncodedError
	          fi
	      done < Sqlfilelist
	   rm -rf Sqlfilelist
	   if [ -s SqlEncodedError ];then
	       if [ x"${full_update_flag}" = x"N" ];then
	   	    log_success "Rsetore start_Revision to ${start_Revision} is successfuly."
	   	    echo ${start_Revision} > $WORKPATH/${S_UpdateVersion}_start_Revision
	   	   fi
	       rm -rf $WORKPATH/*.txt
	       rm -rf SqlEncodedError
	       error_exit
	   fi	   
	else
	   log_error "${S_UpdateVersion} not exists 01_TSBASE|02_TSDEV|03_TSDEAL update .so need check files ."
    fi
	#结束检查 sql 文件的编码
	
	dirname=`ls -l | grep '^d'|awk '{print $NF}'`
	for dir in $dirname
    do
        find ${Desplay_Dir}/${S_UpdateVersion}/$dir/ -type f |grep build|xargs rm -rf 
        #开始剔除因版本合并带入的sql文件
        #find $dir -type f|egrep -v "build|02_update"|sort -n > ${WORKPATH}/${S_UpdateVersion}-update-files.txt
        find $dir -type f|egrep -v "build"|sort -n > ${WORKPATH}/${S_UpdateVersion}-update-files.txt
        if [ -s ${WORKPATH}/${S_UpdateVersion}-update-files.txt ];then
           log_info "current exists 01_scripts and TS_${S_version} exclude files .so need exclude-files"
           flag_log
           while read line
           do
               log_debug $line
           done < ${WORKPATH}/${S_UpdateVersion}-update-files.txt
           flag_log  		
           find $dir -type d -empty|xargs rm -rf 
        else
           log_info "Current $dir not  exists sql file .  ."
       fi
       #结束剔除因版本合并带入的sql文件
       find $dir -type f|egrep -v "build"|sort -n > ${WORKPATH}/${S_UpdateVersion}-end-update-files.txt
       sql=`find ./$dir -type f|grep -v build|sort -n`
       log_info "start get build-${dir}.sql..."
       for i in $sql; 
       do
               echo "prompt  ----Begin to execute @$i;" >> ${Desplay_Dir}/${S_UpdateVersion}/$dir/build-${dir}.sql
               echo "@$i;" >> ${Desplay_Dir}/${S_UpdateVersion}/$dir/build-${dir}.sql
               echo "prompt  ----End to execute @$i;" >> ${Desplay_Dir}/${S_UpdateVersion}/$dir/build-${dir}.sql
               echo "" >> ${Desplay_Dir}/${S_UpdateVersion}/$dir/build-${dir}.sql
       done
       if [ -s ${Desplay_Dir}/${S_UpdateVersion}/$dir/build-${dir}.sql ];then
           log_success "get \"${Desplay_Dir}/${S_UpdateVersion}/$dir/build-${dir}.sql\" is successfuly."
       else
           log_error "get \"${Desplay_Dir}/${S_UpdateVersion}/$dir/build-${dir}.sql\" is failed."
           error_exit
       fi	 
    done
    rm -f ${WORKPATH}/${S_UpdateVersion}-update-files.txt
    rm -f ${WORKPATH}/${S_UpdateVersion}-end-update-files.txt
    cd $Desplay_Dir/
    log_info "get TS_V${S_UpdateVersion}.${full_update_flag}-${start_Revision}-${end_Revision}.db.tgz..."
    tar zcf TS_V${S_UpdateVersion}.${full_update_flag}-${start_Revision}-${end_Revision}.db.tgz ${S_UpdateVersion}
    if [ $? = 0 ];then
      log_success "get TS_V${S_UpdateVersion}.${full_update_flag}-${start_Revision}-${end_Revision}.db.tgz successfuly."
    else
      log_error "get TS_V${S_UpdateVersion}.${full_update_flag}-${start_Revision}-${end_Revision}.db.tgz Failed."
      error_exit
    fi
    
    ssh ts@${envname} 'ls /home/ts/dbUpdate/ts_database' &> /dev/null
    if [ $? != 0 ];then
        ssh ts@${envname} 'mkdir -p /home/ts/dbUpdate/ts_database'
    fi
    echo ${S_UpdateVersion} > ${WORKPATH}/VERSION_NEW.txt
    scp *.tgz ts@${envname}:/home/ts/dbUpdate/ts_database
    scp ${WORKPATH}/*.txt ts@${envname}:/home/ts/dbUpdate/ts_database
    rm -rf *.tgz *.txt
    log_info "Begin run \"/home/ts/scripts/ts_db_upgrade.sh\" on the ${envname}"
	ssh ts@${envname} 'bash /home/ts/scripts/ts_db_upgrade.sh > /dev/null'
    if [ $? = 0 ];then
       log_success "\"/home/ts/scripts/ts_db_upgrade.sh\" on the ${envname} run is successfuly."
    else
       RETVAL=$?
       log_error "\"/home/ts/scripts/ts_db_upgrade.sh\" on the ${envname} run is failed." 
    fi
	log_info "End run \"/home/ts/scripts/ts_db_upgrade.sh\" on the ${envname}"
    
    scp ts@${envname}:/home/ts/dbUpdate/ts_db_upgrade.log ts_db-${envname}.log
    ssh ts@${envname} "rm -rf /home/ts/dbUpdate/ts_db_upgrade.log"
    echo "-------------------------------------------------------------------------------------"
    echo "@              journal of ts_db_upgrade.sh from ${envname}                       @"
    echo "-------------------------------------------------------------------------------------"
    cat ts_db-${envname}.log
	db_update_result=`cat ts_db-${envname}.log|grep -E "ERROR|ORA-"`
    db_compile_error=`cat ts_db-${envname}.log|grep "compile database object is failed"`
	if [ -z "${db_update_result}" -a -z "${db_compile_error}" ];then
	   log_success "update \"TS_V${S_UpdateVersion}.${full_update_flag}-${start_Revision}-${end_Revision}.db.tgz\" on the database ${envname} is successfuly."
       rm -rf ts_db-${envname}.log
	else
	   RETVAL=1
	   log_error "update \"TS_V${S_UpdateVersion}.${full_update_flag}-${start_Revision}-${end_Revision}.db.tgz\" on the database ${envname} is failed."
	fi
    echo '-------------------------------------------------------------------------------------';echo
	log_info "Now End run update \"${S_UpdateVersion}\" Project sql file."
elif [ x"${pull_flag}" = x"N" ];then
	log_info "Now Begin Create \"${S_UpdateVersion}\" Project update Package."
    if [ x"${full_update_flag}" = x"Y" ];then
        echo ${full_update_flag} > $WORKPATH/full_update_flag.txt
		log_info "get start_Revision..."
        #start_Revision=`git log --pretty=format:"%h %an %ar %s"|awk '{print $1}'|tail -1`
        #start_Revision="c54c5df"
        test -f /export/home/ccm/TS_db_Deploy/release_${S_version}/release_${S_version}_start_commitid
        if [ $? = 0 ];then
            log_info "remote Server exists ${S_commitidstorageIP}:/export/home/ccm/TS_db_Deploy/release_${S_version}/release_${S_version}_start_commitid file." 
            start_Revision=`cat /export/home/ccm/TS_db_Deploy/release_${S_version}/release_${S_version}_start_commitid`
        else
            log_error "remote Server not exists ${S_commitidstorageIP}:/export/home/ccm/TS_db_Deploy/release_${S_version}/release_${S_version}_start_commitid file." 
            error_exit
        fi
		if [ $? = 0 ];then
		   log_success "get start_Revision ${start_Revision} is successfuly."
		   echo ${start_Revision} > $WORKPATH/start_Revision.txt
		else
		   log_error "get start_Revision is Failed."
		   error_exit
		fi
		log_info "get end_Revision..."
        end_Revision=`git log --pretty=format:"%h %an %ar %s"|awk '{print $1}'|head -1`
		if [ $? = 0 ];then
		   log_success "get end_Revision ${end_Revision} is successfuly."
		   echo ${end_Revision} > $WORKPATH/end_Revision.txt
           echo "${end_Revision}" > $WORKPATH/${S_UpdateVersion}_last_Revision
		else
		   log_error "get end_Revision is Failed."
		   error_exit
		fi
	log_info "Current full_update_flag is \"${full_update_flag}\".so need all package \"${S_UpdateVersion}\" Project sql file.and Revision is from \"${start_Revision}\" to \"${end_Revision}\"."
    elif [ x"${full_update_flag}" = x"N" ];then
        if [ -f ${WORKPATH}/${S_UpdateVersion}_last_Revision ];then
           echo ${full_update_flag} > full_update_flag.txt
		   log_info "get start_Revision..."
           start_Revision=`cat ${WORKPATH}/${S_UpdateVersion}_last_Revision`
		   if [ $? = 0 ];then
		      log_success "get start_Revision ${start_Revision} is successfuly."
		      cat ${S_UpdateVersion}_last_Revision > ${WORKPATH}/start_Revision.txt
		   else
		      log_error "get start_Revision is Failed."
		      error_exit
		   fi
		   log_info "get end_Revision..."
           end_Revision=`git log --pretty=format:"%h %an %ar %s"|awk '{print $1}'|head -1`
		   if [ $? = 0 ];then
		      log_success "get end_Revision ${end_Revision} is successfuly."
		      echo ${end_Revision} > ${WORKPATH}/end_Revision.txt
		   else
		      log_error "get end_Revision is Failed."
		      error_exit
		   fi
         else
           log_error "Current full_update_flag is \"${full_update_flag}\".\"${WORKPATH}/${S_UpdateVersion}_last_Revision\" files not exists."
           error_exit
         fi
	log_info "Current full_update_flag is \"${full_update_flag}\".so not need all package \"${S_UpdateVersion}\" Project sql file.only package Revision is from \"${start_Revision}\" to \"${end_Revision}\"."
    fi
    
    if [ -f ${WORKPATH}/data.txt ];then
       rm -rf ${WORKPATH}/data.txt
    fi
    log_info "get ${WORKPATH}/data.txt..."
    git diff ${start_Revision} ${end_Revision} --name-only > ${WORKPATH}/data.txt
    #开始排除因为合并代码引入的02_update目录下的sql文件
    cat ${WORKPATH}/data.txt|egrep  "01_scripts|02_update/update_TS_V${G_Version}" > ${WORKPATH}/data-tmp.txt
    mv ${WORKPATH}/data-tmp.txt ${WORKPATH}/data.txt
    #结束排除因为合并代码引入的02_update目录下的sql文件
    cat ${WORKPATH}/data.txt|grep -i sql$ > ${WORKPATH}/data-tmp.txt
    mv ${WORKPATH}/data-tmp.txt ${WORKPATH}/data.txt
    if [ -s ${WORKPATH}/data.txt ];then
       log_success "get release-${S_version} Revision ${start_Revision} ${end_Revision} change sql file is successfuly"
    else
       log_warning "release-${S_version} Revision ${start_Revision} ${end_Revision} not exists change sql."
       error_exit
    fi

    if [ -d ${Desplay_Dir}/${S_UpdateVersion} ];then
       rm -rf ${Desplay_Dir}/${S_UpdateVersion}
	fi
    log_info "begin cp $branches_name ${master_branch} change sql file..."
    cat ${WORKPATH}/data.txt|while read line
    do
    filepath=`echo $line |awk -F "/" 'gsub($(NF),"",$0)'`
    mkdir -p ${Desplay_Dir}/${S_UpdateVersion}/${filepath}
    cp ${line} ${Desplay_Dir}/${S_UpdateVersion}/${filepath}
    done

    #begin tar sql file and run update srcipts
    cd ${Desplay_Dir}/${S_UpdateVersion}/
	dirname=`ls -l | grep '^d'|awk '{print $NF}'`
	
    for dir in $dirname
    do
        find ${Desplay_Dir}/${S_UpdateVersion}/$dir/ -type f |grep build|xargs rm -rf 
        #开始剔除因版本合并带入的sql文件
        #find $dir -type f|egrep -v "build|02_update"|sort -n > ${WORKPATH}/${S_UpdateVersion}-update-files.txt
        find $dir -type f|egrep -v "build"|sort -n >${WORKPATH}/${S_UpdateVersion}-update-files.txt
        if [ -s ${WORKPATH}/${S_UpdateVersion}-update-files.txt  ];then
           log_info "Current exists sql file. So need exclude-files"
           flag_log
           while read line
           do
               log_debug $line
           done < ${WORKPATH}/${S_UpdateVersion}-update-files.txt
           flag_log  
           find $dir -type d -empty|xargs rm -rf 
        else
           log_error "The file of ${WORKPATH}/${S_UpdateVersion}-update-files.txt is empty . Please check git push files "
        fi
        #结束剔除因版本合并带入的sql文件
        find $dir -type f|egrep -v "build"|sort -n > ${WORKPATH}/${S_UpdateVersion}-end-update-files.txt
        sql=`find ./$dir -type f|grep -v build|sort -n`
        log_info "start get build-${dir}.sql..."
        for i in $sql; 
        do
            echo "prompt  ----Begin to execute @$i;" >> ${Desplay_Dir}/${S_UpdateVersion}/$dir/build-${dir}.sql
            echo "@$i;" >> ${Desplay_Dir}/${S_UpdateVersion}/$dir/build-${dir}.sql
            echo "prompt  ----End to execute @$i;" >> ${Desplay_Dir}/${S_UpdateVersion}/$dir/build-${dir}.sql
            echo "" >> ${Desplay_Dir}/${S_UpdateVersion}/$dir/build-${dir}.sql
        done
      if [ -s ${Desplay_Dir}/${S_UpdateVersion}/$dir/build-${dir}.sql ];then
         log_success "get \"${Desplay_Dir}/${S_UpdateVersion}/$dir/build-${dir}.sql\" is successfuly."
      else
         log_error "get \"${Desplay_Dir}/${S_UpdateVersion}/$dir/build-${dir}.sql\" is failed."
         error_exit
      fi	 
    done
    rm -f ${WORKPATH}/${S_UpdateVersion}-update-files.txt
    rm -f ${WORKPATH}/${S_UpdateVersion}-end-update-files.txt
    cd $Desplay_Dir/
    log_info "get \"TS_V${S_UpdateVersion}.${full_update_flag}-${start_Revision}-${end_Revision}.db.tgz\"..."
    tar zcf TS_V${S_UpdateVersion}.${full_update_flag}-${start_Revision}-${end_Revision}.db.tgz ${S_UpdateVersion}
    if [ $? = 0 ];then
      log_success "get \"TS_V${S_UpdateVersion}.${full_update_flag}-${start_Revision}-${end_Revision}.db.tgz\" successfuly."
    else
      log_error "get \"TS_V${S_UpdateVersion}.${full_update_flag}-${start_Revision}-${end_Revision}.db.tgz\" Failed."
      error_exit
    fi
    
    ssh ts@${envname} "test -d /home/ts/tmp/ts_database/${S_UpdateVersion}"
    if [ $? = 0 ];then
        log_info "remote server ${envname} exists /home/ts/tmp/ts_database/${S_UpdateVersion}. so need delete it."
		ssh ts@${envname} "rm -rf /home/ts/tmp/ts_database/${S_UpdateVersion}"
	else
	    log_info "remote server ${envname} not exists /home/ts/tmp/${S_UpdateVersion}. so not need delete it."
    fi
	ssh ts@${envname} "mkdir -p /home/ts/tmp/ts_database/${S_UpdateVersion}"
    echo ${S_UpdateVersion} > $WORKPATH/VERSION_NEW.txt
	log_info "Begin scp \"TS_V${S_UpdateVersion}.${full_update_flag}-${start_Revision}-${end_Revision}.db.tgz\" to \"ts@${envname}:/home/ts/tmp/ts_database/${S_UpdateVersion}/\""
	scp ${WORKPATH}/*.txt ts@${envname}:/home/ts/tmp/ts_database/${S_UpdateVersion}/
    scp *.tgz ts@${envname}:/home/ts/tmp/ts_database/${S_UpdateVersion}/
	if [ $? = 0 ];then
	   log_success "scp \"TS_V${S_UpdateVersion}.${full_update_flag}-${start_Revision}-${end_Revision}.db.tgz\" to \"ts@${envname}:/home/ts/tmp/ts_database/${S_UpdateVersion}/\" is successfuly."
	else
	   RETVAL=$?
	   log_error "scp \"TS_V${S_UpdateVersion}.${full_update_flag}-${start_Revision}-${end_Revision}.db.tgz\" to \"ts@${envname}:/home/ts/tmp/ts_database/${S_UpdateVersion}/\" is failed." 
	fi
	log_info "End scp \"TS_V${S_UpdateVersion}.${full_update_flag}-${start_Revision}-${end_Revision}.db.tgz\" to \"ts@${envname}:/home/ts/tmp/ts_database/${S_UpdateVersion}/\""
    rm -rf *.tgz *.txt
	log_info "Now End Create \"${S_UpdateVersion}\" Project update Package."
fi
log_info "End run f_build_sql function."
}
message() {
    if [ $RETVAL != 0 ];then
        error_exit
    else
        encoding=GBK
        msg=$(echo "Event：外汇辅助系统 ${envname} 数据库部署成功!\
        Log:http://${S_JenkinsMastetIp}:${S_JenkinsMastetPort}/jenkins/job/${S_UpdatedbProjectName}-${G_Version}/${BUILDNUMBER}/console\
        Date：$(date +%Y/%m/%d-%H:%M:%S)    --Jenkins"|iconv -t $encoding)
		for user in ${USER[@]}
		do
		    curl "http://200.31.147.138:6680/post.sdk?recv=${user}&send=3038&msg=$msg" &>/dev/null
		done
    fi
}

f_build_sql
message
