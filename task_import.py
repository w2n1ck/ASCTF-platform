#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Author：w2n1ck
@Index：http://www.w2n1ck.com/
@task_import.py
imports tasks from 'tasks.json' into the database
"""

import dataset
import json
import sys

reload(sys)
sys.setdefaultencoding('utf-8')

if __name__ == '__main__':

    purge = False

    # 清除数据
    if len(sys.argv) > 1:
        if sys.argv[1] == 'purge':

            purge = True
            print "[*] Purge mode is on, old tasks deleted"

    # 更新tasks.json中的数据
    tasks_str = open('tasks.json').read().decode('utf-8')
    # print tasks_str
    # print json.dumps(tasks_str, sort_keys=True, indent=2)
    tasks_json = json.loads(tasks_str.decode('utf-8'))
    # print tasks_json

    # 连接数据库
    db = dataset.connect('mysql://root:abcABC123.@192.168.2.8/ctf?charset=utf8')
    # db = dataset.connect('sqlite:///ctf.db')
    # mysql://username:password@10.10.10.10/onlinedb?charset=utf8'

    # 题目类别表
    cat_table = db['categories']
    # 题目详情表
    tasks_table = db['tasks']
    # 题目所属类别表
    cat_task_table = db['cat_task']

    if purge:
        cat_table.delete()
        tasks_table.delete()
        cat_task_table.delete()

# 重新处理tasks.json文件，并添加到表中
    old_cat_count = len(list(cat_table))
    old_task_count = len(list(tasks_table))

    # 导入分类
    for category in tasks_json['categories']:

        cat = category.copy()
        del cat['tasks']
        
        if cat_table.find_one(id=cat['id']):

            # 更新已经存在的分类
            cat_table.update(cat, ['id'])

        else:
            cat_table.insert(cat)

    new_cat_count = len(list(cat_table))
    print "[*] Imported %d new categories" % (new_cat_count - old_cat_count)

    # 导入题目
    for category in tasks_json['categories']:
        for task in category['tasks']:
            
            if tasks_table.find_one(id=task['id']):

                # 更新已经存在的题目
                tasks_table.update(task, ['id'])
            else:
                tasks_table.insert(task)

                # 更新题目所属分类表
                row = dict(cat_id=category['id'], task_id=task['id'])
                cat_task_table.insert(row)

    new_task_count = len(list(tasks_table))
    print "[*] Imported %d new tasks" % (new_task_count - old_task_count)
