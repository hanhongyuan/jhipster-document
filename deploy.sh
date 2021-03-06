#!/bin/bash

project_path=$(cd `dirname $0`;pwd)
project_parent_path="$(dirname "$project_path")" 
deploy_project_path=$project_parent_path"/deploy-jh-zh-doc-"`date +%Y%m%d%H%M%S`

mkdir $deploy_project_path  && cd "$_"
cp -r  $project_path/* $deploy_project_path

mv $deploy_project_path/index.zh.html $deploy_project_path/index.html
mv $deploy_project_path/_layouts/default.zh.html $deploy_project_path/_layouts/default.html
mv $deploy_presentation/index.zh.html $deploy_presentation/index.html

deploy_project_page_dir=$deploy_project_path/pages/*

for file_url in $deploy_project_page_dir;do 
	if [ -f "$file_url" ];then
		file_name=$(basename $file_url)
		file_name_end_fix=${file_name#*.}
		end_fix_two_ch=${file_name_end_fix:0:2}
		if [[ $end_fix_two_ch = "zh" ]];then
			echo "$file_name 是中文翻译，替换文件"
			origin_file=${file_url/.zh./.}
			mv $file_url $origin_file
		fi
	fi
done

nohup ./run-jekyll.sh >out.log 2>&1 &
