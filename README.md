# 学生信息管理系统 Web 版

这是一个基于 Python + Flask + MySQL 的学生信息管理系统，包含注册、登录、学生信息增删改查和搜索功能。

## 目录结构

```text
.
├── app.py
├── db.py
├── schema.sql
├── requirements.txt
├── static/
│   └── style.css
└── templates/
    ├── base.html
    ├── login.html
    ├── register.html
    ├── student_form.html
    └── students.html
```

## 初始化数据库

先登录 MySQL，然后执行建表 SQL：

```bash
mysql -u root -p < schema.sql
```

## 安装依赖

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## 配置数据库连接

默认连接本机 MySQL 的 `student_management` 数据库，用户名为 `root`，密码为空。可以通过环境变量修改：

```bash
export MYSQL_HOST=127.0.0.1
export MYSQL_PORT=3306
export MYSQL_USER=root
export MYSQL_PASSWORD=你的MySQL密码
export MYSQL_DATABASE=student_management
export SECRET_KEY=任意随机字符串
```

## 启动项目

```bash
flask --app app run --debug
```

浏览器打开：

```text
http://127.0.0.1:5000
```
