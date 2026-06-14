<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ title or "学生信息管理系统" }}</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
    <header class="topbar">
        <div class="brand">学生信息管理系统</div>
        <nav>
            {% if session.get("user_id") %}
                <span>{{ session.get("username") }}</span>
                <a href="{{ url_for('students') }}">学生列表</a>
                <a href="{{ url_for('logout') }}">退出</a>
            {% else %}
                <a href="{{ url_for('login') }}">登录</a>
                <a href="{{ url_for('register') }}">注册</a>
            {% endif %}
        </nav>
    </header>

    <main class="container">
        {% with messages = get_flashed_messages(with_categories=true) %}
            {% if messages %}
                <div class="messages">
                    {% for category, message in messages %}
                        <div class="message {{ category }}">{{ message }}</div>
                    {% endfor %}
                </div>
            {% endif %}
        {% endwith %}

        {% block content %}{% endblock %}
    </main>
</body>
</html>
