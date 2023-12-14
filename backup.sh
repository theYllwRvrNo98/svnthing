#!/bin/bash

start_time=$(date "+%Y-%m-%d %H:%M:%S")
echo "开始时间：$start_time"


# 备份到
targetdir='/data-backup/svn-backup'
#历史备份目录
targetdirhis='/data-backup/svn-backup/history'


# 仓库目录
source_path="/data-svn/svn-dir/repo"

#备份账号文件
cp -f $source_path/passwd $targetdir/passwd
cp -f $source_path/authz  $targetdir/authz



# 使用find命令来搜索文件夹路径下的子文件夹
repos=$(find "$source_path" -mindepth 1 -maxdepth 1  -type d)

for repo in $repos
do
    cd ${targetdir}

    echo "$repo"
    reponame=${repo##*/}

    if [ -d "$reponame" ]; then
        file_count=$(ls -l "$reponame" | grep ^- | wc -l)
        if [ $file_count -gt 30 ]; then
            if [ -d "$targetdirhis/$reponame.2" ]; then
                rm -rf $targetdirhis/$reponame.2
            fi

            if [ -d "$targetdirhis/$reponame.1" ]; then
                mv $targetdirhis/$reponame.1 $targetdirhis/$reponame.2
            fi
            mv $reponame  $targetdirhis/$reponame.1
        fi
    fi

    mkdir -p ${reponame}
    cd ${reponame}
    # 已经备份的版本号
    if [ ! -e "ver.txt" ]; then
        touch ver.txt
        echo -1 > ver.txt
    fi
    #已备份的版本号
    ver1=$(cat ver.txt)
    #要备份到的版本号
    ver2=$(svnlook youngest ${repo})
    if [ $ver1 -ne $ver2 ]; then
        ver11=`expr $ver1 + 1`
        #增量备份
        svnadmin dump ${repo} --revision $ver11:$ver2 --incremental > $reponame.$ver11-$ver2.dump
        echo $ver2 > ver.txt
    fi
    
done



end_time=$(date "+%Y-%m-%d %H:%M:%S")
echo "结束时间：$end_time"


