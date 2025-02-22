# !/bin/bash

function get_container_id()
{
    contianers=$(docker container ls)
    results=(${contianers// / })
    
    container_name=$1
    echo $container_name Finding... 
    
    num=${#results[@]}
    for ((i=1;i<=num;i++))
    do
        item=${results[$i]}
        if [ "$item" == "$container_name" ] ; then
            container_id=${results[$i-1]}
        fi
    done
}

image_name="ginhoor/py3"

target_num=$1
if [ "$target_num" = "1" ]; then
    docker run -d --memory=2G --oom-kill-disable $image_name
    echo "run "$image_name
elif [ "$target_num" = "2" ] ; then
    docker run -it --memory=2G --oom-kill-disable $image_name
    echo "run "$image_name
elif [ "$target_num" = "3" ] ; then

    get_container_id $image_name
    if [ -z "$container_id" ]
    then
        echo "Container ID UNFOUND!"
    else 
        docker rm -f $container_id
        echo "stop "$image_name $container_id
    fi
elif [ "$target_num" = "4" ] ; then
    get_container_id $image_name
    if [ -z "$container_id" ]
    then
        echo "Container ID UNFOUND!"
    else 
        docker restart $container_id
        echo "restart "$image_name $container_id
    fi   
else
    echo "*** 提示:"
    echo "*** 后台创建"$image_name":\n\t"${0##*/}" 1"
    echo "*** 前台创建"$image_name":\n\t"${0##*/}" 2"
    echo "*** 删除"$image_name":\n\t"${0##*/}" 3"
    echo "*** 重启"$image_name":\n\t"${0##*/}" 4"
    exit 1
fi
