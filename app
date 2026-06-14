import os
import secrets
from functools import wraps
from html import escape

from flask import (
    Flask,
    Response,
    flash,
    redirect,
    render_template,
    request,
    session,
    url_for,
)
from mysql.connector import IntegrityError
from werkzeug.security import check_password_hash, generate_password_hash

from db import execute, fetch_all, fetch_one


app = Flask(__name__)
app.config["SECRET_KEY"] = os.getenv("SECRET_KEY", "change-this-secret-key")

CAPTCHA_CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
CHINA_PROVINCES = [
    "北京市",
    "天津市",
    "河北省",
    "山西省",
    "内蒙古自治区",
    "辽宁省",
    "吉林省",
    "黑龙江省",
    "上海市",
    "江苏省",
    "浙江省",
    "安徽省",
    "福建省",
    "江西省",
    "山东省",
    "河南省",
    "湖北省",
    "湖南省",
    "广东省",
    "广西壮族自治区",
    "海南省",
    "重庆市",
    "四川省",
    "贵州省",
    "云南省",
    "西藏自治区",
    "陕西省",
    "甘肃省",
    "青海省",
    "宁夏回族自治区",
    "新疆维吾尔自治区",
    "台湾省",
    "香港特别行政区",
    "澳门特别行政区",
]


def login_required(view):
    @wraps(view)
    def wrapped_view(*args, **kwargs):
        if not session.get("user_id"):
            flash("请先登录。", "warning")
            return redirect(url_for("login"))
        return view(*args, **kwargs)

    return wrapped_view


@app.route("/")
def index():
    if session.get("user_id"):
        return redirect(url_for("students"))
    return redirect(url_for("login"))


@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")
        confirm_password = request.form.get("confirm_password", "")
        captcha = request.form.get("captcha", "")

        if not validate_captcha(captcha):
            flash("验证码错误。", "error")
            return render_template("register.html")

        if not username or not password:
            flash("用户名和密码不能为空。", "error")
            return render_template("register.html")
        if password != confirm_password:
            flash("两次输入的密码不一致。", "error")
            return render_template("register.html")

        password_hash = generate_password_hash(password)
        try:
            user_id = execute(
                "INSERT INTO users (username, password_hash) VALUES (%s, %s)",
                (username, password_hash),
            )
        except IntegrityError:
            flash("用户名已存在。", "error")
            return render_template("register.html")

        session["user_id"] = user_id
        session["username"] = username
        flash("注册成功。", "success")
        return redirect(url_for("students"))

    return render_template("register.html")


@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")
        captcha = request.form.get("captcha", "")

        if not validate_captcha(captcha):
            flash("验证码错误。", "error")
            return render_template("login.html")

        user = fetch_one("SELECT * FROM users WHERE username = %s", (username,))

        if not user or not check_password_hash(user["password_hash"], password):
            flash("用户名或密码错误。", "error")
            return render_template("login.html")

        session["user_id"] = user["id"]
        session["username"] = user["username"]
        flash("登录成功。", "success")
        return redirect(url_for("students"))

    return render_template("login.html")


@app.route("/logout")
def logout():
    session.clear()
    flash("已退出登录。", "success")
    return redirect(url_for("login"))


@app.route("/captcha.svg")
def captcha_image():
    code = "".join(secrets.choice(CAPTCHA_CHARS) for _ in range(4))
    session["captcha"] = code

    chars = []
    for index, char in enumerate(code):
        x = 20 + index * 28 + secrets.randbelow(6)
        y = 42 + secrets.randbelow(10)
        rotate = secrets.choice((-12, -8, -4, 4, 8, 12))
        chars.append(
            f'<text x="{x}" y="{y}" transform="rotate({rotate} {x} {y})">{escape(char)}</text>'
        )

    lines = []
    for _ in range(5):
        x1 = secrets.randbelow(130)
        y1 = 8 + secrets.randbelow(46)
        x2 = secrets.randbelow(130)
        y2 = 8 + secrets.randbelow(46)
        color = secrets.choice(("#8aa2c4", "#b46a6a", "#5d8f73", "#8a7cc4"))
        lines.append(
            f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{color}" stroke-width="1.4" opacity="0.65" />'
        )

    dots = []
    for _ in range(28):
        cx = secrets.randbelow(130)
        cy = secrets.randbelow(56)
        dots.append(f'<circle cx="{cx}" cy="{cy}" r="1" fill="#9aa8b8" opacity="0.55" />')

    svg = f"""
    <svg xmlns="http://www.w3.org/2000/svg" width="130" height="56" viewBox="0 0 130 56">
        <rect width="130" height="56" rx="6" fill="#eef3f8" />
        {''.join(dots)}
        {''.join(lines)}
        <g fill="#12355b" font-family="Arial, sans-serif" font-size="28" font-weight="700" letter-spacing="2">
            {''.join(chars)}
        </g>
    </svg>
    """
    response = Response(svg, mimetype="image/svg+xml")
    response.headers["Cache-Control"] = "no-store, no-cache, must-revalidate, max-age=0"
    return response


@app.route("/students")
@login_required
def students():
    keyword = request.args.get("keyword", "").strip()
    if keyword:
        like_keyword = f"%{keyword}%"
        student_rows = fetch_all(
            """
            SELECT *
            FROM students
            WHERE student_no LIKE %s
               OR name LIKE %s
               OR grade LIKE %s
               OR class_name LIKE %s
               OR major LIKE %s
               OR phone LIKE %s
               OR email LIKE %s
            ORDER BY id DESC
            """,
            (
                like_keyword,
                like_keyword,
                like_keyword,
                like_keyword,
                like_keyword,
                like_keyword,
                like_keyword,
            ),
        )
    else:
        student_rows = fetch_all("SELECT * FROM students ORDER BY id DESC")

    return render_template("students.html", students=student_rows, keyword=keyword)


@app.route("/students/new", methods=["GET", "POST"])
@login_required
def create_student():
    if request.method == "POST":
        data = get_student_form_data()
        error = validate_student_data(data)
        if error:
            flash(error, "error")
            return render_student_form(data, "添加学生")

        try:
            execute(
                """
                INSERT INTO students
                    (student_no, name, grade, class_name, gender, major, phone, email, exam_score, province)
                VALUES
                    (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                """,
                student_params(data),
            )
        except IntegrityError:
            flash("该学号已存在。", "error")
            return render_student_form(data, "添加学生")

        flash("学生信息已添加。", "success")
        return redirect(url_for("students"))

    return render_student_form({}, "添加学生")


@app.route("/students/<int:student_id>/edit", methods=["GET", "POST"])
@login_required
def edit_student(student_id):
    student = fetch_one("SELECT * FROM students WHERE id = %s", (student_id,))
    if not student:
        flash("学生不存在。", "error")
        return redirect(url_for("students"))

    if request.method == "POST":
        data = get_student_form_data()
        error = validate_student_data(data)
        if error:
            flash(error, "error")
            data["id"] = student_id
            return render_student_form(data, "编辑学生")

        try:
            execute(
                """
                UPDATE students
                SET student_no = %s,
                    name = %s,
                    grade = %s,
                    class_name = %s,
                    gender = %s,
                    major = %s,
                    phone = %s,
                    email = %s,
                    exam_score = %s,
                    province = %s
                WHERE id = %s
                """,
                (*student_params(data), student_id),
            )
        except IntegrityError:
            flash("该学号已存在。", "error")
            data["id"] = student_id
            return render_student_form(data, "编辑学生")

        flash("学生信息已更新。", "success")
        return redirect(url_for("students"))

    return render_student_form(student, "编辑学生")


@app.route("/students/<int:student_id>/delete", methods=["POST"])
@login_required
def delete_student(student_id):
    execute("DELETE FROM students WHERE id = %s", (student_id,))
    flash("学生信息已删除。", "success")
    return redirect(url_for("students"))


def get_student_form_data():
    exam_score = request.form.get("exam_score", "").strip()
    try:
        normalized_exam_score = int(exam_score) if exam_score else None
    except ValueError:
        normalized_exam_score = -1

    return {
        "student_no": request.form.get("student_no", "").strip(),
        "name": request.form.get("name", "").strip(),
        "grade": request.form.get("grade", "").strip(),
        "class_name": request.form.get("class_name", "").strip(),
        "gender": request.form.get("gender", "").strip(),
        "major": request.form.get("major", "").strip(),
        "phone": request.form.get("phone", "").strip(),
        "email": request.form.get("email", "").strip(),
        "exam_score": normalized_exam_score,
        "province": request.form.get("province", "").strip(),
    }


def validate_student_data(data):
    required_fields = {
        "student_no": "学号",
        "name": "姓名",
        "grade": "年级",
        "class_name": "班级",
        "gender": "性别",
        "major": "专业",
    }
    for key, label in required_fields.items():
        if not data.get(key):
            return f"{label}不能为空。"
    if data["gender"] not in ("男", "女"):
        return "性别只能选择男或女。"
    if data["exam_score"] is not None and not 0 <= data["exam_score"] <= 750:
        return "高考分数需在 0 到 750 之间。"
    if data["province"] and data["province"] not in CHINA_PROVINCES:
        return "生源地请选择列表中的省份。"
    return None


def validate_captcha(value):
    expected = session.pop("captcha", "")
    return bool(value) and value.strip().upper() == expected


def render_student_form(student, title):
    return render_template(
        "student_form.html",
        student=student,
        title=title,
        provinces=CHINA_PROVINCES,
    )


def student_params(data):
    return (
        data["student_no"],
        data["name"],
        data["grade"],
        data["class_name"],
        data["gender"],
        data["major"],
        data["phone"] or None,
        data["email"] or None,
        data["exam_score"],
        data["province"] or None,
    )


if __name__ == "__main__":
    app.run(debug=True)
