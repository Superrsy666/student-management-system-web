{% extends "base.html" %}

{% block content %}
<section class="auth-box">
    <h1>登录</h1>
    <form method="post" class="form">
        <label>
            用户名
            <input type="text" name="username" required>
        </label>
        <label>
            密码
            <input type="password" name="password" required>
        </label>
        <label>
            验证码
            <div class="captcha-row">
                <input type="text" name="captcha" maxlength="4" autocomplete="off" required>
                <img id="login-captcha" src="{{ url_for('captcha_image') }}" alt="验证码">
                <button type="button" class="button secondary captcha-refresh" onclick="refreshCaptcha('login-captcha')">换一张</button>
            </div>
        </label>
        <button type="submit">登录</button>
    </form>
    <p class="hint">没有账号？<a href="{{ url_for('register') }}">立即注册</a></p>
</section>
<script>
function refreshCaptcha(id) {
    var image = document.getElementById(id);
    image.src = "{{ url_for('captcha_image') }}?t=" + Date.now();
}
</script>
{% endblock %}
