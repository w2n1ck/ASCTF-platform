#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Author：w2n1ck
@Index：http://www.w2n1ck.com/
@server.py
the main flask server module
"""

import os
import re
import dataset
import json
import random
import time
import hashlib

from base64 import b64decode
from functools import wraps

from flask import Flask
from flask import jsonify
from flask import make_response
from flask import redirect
from flask import render_template
from flask import request
from flask import session
from flask import url_for
from flask import abort

app = Flask(__name__, static_folder='static', static_url_path='')

db = None
lang = None
config = None
user_re = re.compile("^[a-zA-Z0-9-_.&]+$")

def is_valid_username(u):
    """用户名合规判断模块"""

    if(user_re.match(u)) and len(u) > 4:
        return True
    return False

def is_valid_password(u):
    """密码合规判断模块"""

    if(user_re.match(u)) and len(u) > 7:
        return True
    return False

def login_required(f):
    """判断登陆模块"""

    @wraps(f)
    def decorated_function(*args, **kwargs):
        if 'user_id' not in session:
            return redirect(url_for('error', msg='loginRequired'))
        return f(*args, **kwargs)
    return decorated_function

def during_ctf(f):
    """时间判断模块"""

    @wraps(f)
    def decorated_function(*args,**kwargs):
        cur_time = int(time.time())
        if cur_time <= config['start'] or cur_time >= config['stop']:
            return redirect(url_for('error',msg='only_during_ctf'))
        return f(*args,**kwargs)
    return decorated_function

def ensure_action_during_ctf(f):
    """确保在比赛期间可操作"""

    @wraps(f)
    def decorated_function(*args,**kwargs):
        cur_time = int(time.time())
        if cur_time >= config['stop']:
            return redirect(url_for('error',msg='ctf_over'))
        return f(*args,**kwargs)
    return decorated_function


def get_user():
    """数据库用户验证模块"""

    login = 'user_id' in session
    # print login
    if login:
        return (True, db['users'].find_one(id=session['user_id']))

    return (False, None)

def get_task(category, score):
    """关卡信息模块"""

    task = db.query('''select t.* from tasks t, categories c, cat_task ct 
        where t.id = ct.task_id and c.id = ct.cat_id 
        and t.score=:score and lower(c.short_name)=:cat''',
        score=score, cat=category)
    # print task
    return list(task)[0]

def get_flags():
    """用户解题模块"""

    flags = db.query('''select f.task_id from flags f 
        where f.user_id = :user_id''',
        user_id=session['user_id'])
    return [f['task_id'] for f in list(flags)]

@app.before_request
def csrf_protect():
    """CSRF模块验证模块"""

    if request.method == "POST":
        token = session.pop('_csrf_token', None)
        if not token or token != request.form.get('_csrf_token'):
            abort(403)

def some_random_string():
    return  hashlib.sha256(os.urandom(16)).hexdigest()

def generate_csrf_token():
    """CSRF生成模块"""

    if '_csrf_token' not in session:
        session['_csrf_token'] = some_random_string()
    return session['_csrf_token']

@app.context_processor
def inject_ctftime():
    start = time.strftime("%Y-%m-%d,%H:%M:%S (%Z)", time.localtime(config['start']))
    stop = time.strftime("%Y-%m-%d,%H:%M:%S (%Z)", time.localtime(config['stop']))
    return dict(ctf_start = start, ctf_stop = stop)

@app.route('/error/<msg>')
def error(msg):
    """错误信息输出模块"""
    # print msg
    if msg in lang['error']:
        message = lang['error'][msg]
        # print message
    else:
        message = lang['error']['unknown']

    login, user = get_user()

    render = render_template('frame.html', lang=lang, page='error.html', 
        message=message, login=login, user=user)
    return make_response(render)

def session_login(username):
    """session模块"""
    user = db['users'].find_one(username=username)
    session['user_id'] = user['id']
    # print session['user_id']

@app.route('/login', methods = ['POST'])
def login():
    """用户登陆模块"""

    from werkzeug.security import check_password_hash

    username = request.form['user']
    password = request.form['password']

    if not is_valid_username(username) or not is_valid_password(password):
        return redirect('/error/username_or_password_unavailable')

    user = db['users'].find_one(username=username)
    if user is None:
        return redirect('/error/invalidCredentials')

    if check_password_hash(user['password'], password):
        session_login(username)
        return redirect('/tasks')

    return redirect('/error/invalidCredentials')

@app.route('/register')
@ensure_action_during_ctf
def register():
    """注册表单模块"""

    # Render template
    render = render_template('frame.html', lang=lang, 
        page='register.html', login=False)
    return make_response(render) 

@app.route('/register/submit', methods = ['POST'])
@ensure_action_during_ctf
def register_submit():
    """用户注册模块"""

    from werkzeug.security import generate_password_hash

    username = request.form['user']
    password = request.form['password']

    if not is_valid_username(username) or not is_valid_password(password):
        return redirect('/error/username_or_password_unavailable')

    if len(username) > 15 or len(password) > 15:
        return redirect('/error/username_or_password_unavailable')

    user_found = db['users'].find_one(username=username)
    if user_found:
        return redirect('/error/alreadyRegistered')
            
    new_user = dict(hidden=0, username=username, 
        password=generate_password_hash(password))
    # print new_user
    db['users'].insert(new_user)

    # 开始会话
    session_login(username)

    return redirect('/tasks')

@app.route('/tasks')
@login_required
@during_ctf
def tasks():
    """展示所有关卡模块"""

    login, user = get_user()
    flags = get_flags()

    categories = db['categories']

    tasks = db.query('''select c.id as cat_id, t.id as id, c.short_name, 
        t.score, t.row from categories c, tasks t, cat_task c_t 
        where c.id = c_t.cat_id and t.id = c_t.task_id''')
    tasks = list(tasks)
    # print tasks

    grid = []
    # 找出最大等级(确定行)
    max_row = max(t['row'] for t in tasks)

    for row in range(max_row + 1):

        row_tasks = []
        for cat in categories:

            # 根据等级找出关卡
            for task in tasks:
                if task['row'] == row and task['cat_id'] == cat['id']:
                    #print task['row']+'++++++'+row+'++++++'+cat['id']
                    break
            else:
                task = None

            row_tasks.append(task)
            # print row_tasks

        grid.append(row_tasks)
        # print grid

    # Render template
    render = render_template('frame.html', lang=lang, page='tasks.html', 
        login=login, user=user, categories=categories, grid=grid, 
        flags=flags)
    return make_response(render) 

@app.route('/tasks/<category>/<score>')
@login_required
@during_ctf
def task(category, score):
    """单个关卡详情模块"""

    login, user = get_user()

    task = get_task(category, score)
    if not task:
        return redirect('/error/taskNotFound')

    flags = get_flags()
    task_done = task['id'] in flags

    solutions = db['flags'].find(task_id=task['id'])
    solutions = len(list(solutions))

    render = render_template('frame.html', lang=lang, page='task.html', 
        task_done=task_done, login=login, solutions=solutions,
        user=user, category=category, task=task, score=score)
    return make_response(render)

@app.route('/submit/<category>/<score>/<flag>')
@during_ctf
@login_required
def submit(category, score, flag):
    """处理提交的flag模块"""

    # print "ok1"
    """
    category = request.form['category']
    score = request.form['score']
    flag = request.form['flag']
    """
    login, user = get_user()

    task = get_task(category, score)
    flags = get_flags()
    task_done = task['id'] in flags
    print "ok2"

    # result = {'success': False, 'csrf': generate_csrf_token()}
    result = {'success': False}
    if not task_done and task['flag'] == b64decode(flag):

        timestamp = int(time.time() * 1000)

        # 插入数据
        new_flag = dict(task_id=task['id'], user_id=session['user_id'], 
            score=score, timestamp=timestamp)
        db['flags'].insert(new_flag)

        result['success'] = True

    return jsonify(result)

@app.route('/scoreboard')
@login_required
def scoreboard():
    """积分板模块"""

    login, user = get_user()
    scores = db.query('''select u.username, ifnull(sum(f.score), 0) as score, 
        max(timestamp) as last_submit from users u left join flags f 
        on u.id = f.user_id where u.hidden = 0 group by u.username 
        order by score desc, last_submit asc, u.username asc''')

    scores = list(scores)
    # print scores

    render = render_template('frame.html', lang=lang, page='scoreboard.html', 
        login=login, user=user, scores=scores)
    return make_response(render)

@app.route('/about')
@login_required
def about():
    """关于模块"""

    login, user = get_user()

    render = render_template('frame.html', lang=lang, page='about.html', 
        login=login, user=user)
    return make_response(render)

@app.route('/rules')
def rules():
    """规则模块"""

    login, user = get_user()
    render = render_template('frame.html', lang=lang, page='rules.html',
        login=login, user=user)
    return  make_response(render)

@app.route('/logout')
@login_required
def logout():
    """注销模块"""

    del session['user_id']
    return redirect('/')

@app.route('/')
def index():
    """系统主界面"""

    login, user = get_user()

    render = render_template('frame.html', lang=lang, 
        page='main.html', login=login, user=user)
    return make_response(render)

app.jinja_env.globals['csrf_token'] = generate_csrf_token

if __name__ == '__main__':
    """初始化数数据库 配置文件"""

    # 加载配置文件
    config_str = open('config.json', 'rb').read()
    config = json.loads(config_str)

    app.secret_key = config['secret_key']

    # 加载信息
    lang_str = open(config['language_file'], 'rb').read()
    lang = json.loads(lang_str)
    # print lang

    lang = lang[config['language']]

    # 连接数据库
    db = dataset.connect(config['db'])

    # 初始化flags表
    if 'flags' not in db.tables:
        db.query('''create table flags (
            task_id INTEGER, 
            user_id INTEGER, 
            score INTEGER, 
            timestamp BIGINT, 
            PRIMARY KEY (task_id, user_id))''')

    # 启动 web server
    app.run(host=config['host'], port=config['port'], 
        debug=config['debug'], threaded=True)
