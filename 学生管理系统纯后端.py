# 学生管理系统
# 功能:信息录入，查询，删除，修改，扩展。
students = []
genders = ["男","女"]
def add_student():
    """1.增添学生(信息录入)功能:学号，姓名，年级，班级，性别，专业，电话，邮箱"""
    try:
        add_id = input("请输入添加学生学号:")
        global students
        for i in students:
            if i["学号"] == add_id:
                print("该学生已经存在!")
                return add_student()
        add_name = input("请输入添加学生姓名:")
        add_grade = input("请输入添加学生的年级:")
        add_class = input("请输入添加学生的班级:")
        add_gender = input("请输入添加学生的性别:")
        while add_gender not in genders:
            print("性别输入出错!")
            add_gender = input("请输入添加学生的性别:")
        add_major = input("请输入添加学生的专业:")
        add_tel = input("请输入添加学生的电话:")
        add_post = input("请输入添加学生的邮箱:")
        info = {}
        info["学号"] = add_id
        info["姓名"] = add_name
        info["年级"] = add_grade
        info["班级"] = add_class
        info["性别"] = add_gender
        info["专业"] = add_major
        info["电话"] = add_tel
        info["邮箱"] = add_post
        students.append(info)
        print(students)
    except Exception as e:
        print(f"错误原因:{e}")
def del_student():
    """2.删除学生功能"""
    try:
        del_id = input("请输入删除学生学号:")
        global students
        for i in students:
            if i["学号"] == del_id:
                students.remove(i)
                break
            else:
                print("该学生不存在!")
        print(students)
    except Exception as e:
        print(f"错误原因:{e}")
def show_student():
    """3.查询学生功能"""
    try:
        modify_id = input("请输入要查询的学生学号:")
        global students
        for i in students:
            if i["学号"] == modify_id:
                print(students)
                break
            else:
                print("该学生不存在!")
    except Exception as e:
        print(f"错误原因:{e}")
def modify_student():
    """4.修改学生功能"""
    try:
        show_id = input("请输入要修改的学生学号:")
        global students
        for i in students:
            if i["学号"] == show_id:
                print(students)
                break
            else:
                print("该学生不存在!")
        add_id = input("请输入修改后的学生学号:")
        for i in students:
            if i["学号"] == add_id:
                print("该学生已经存在!")
                return add_student()
        add_name = input("请输入修改后的学生姓名:")
        add_grade = input("请输入修改后的学生的年级:")
        add_class = input("请输入修改后的学生的班级:")
        add_gender = input("请输入修改后的学生的性别:")
        while add_gender not in genders:
            print("性别输入出错!")
            add_gender = input("请输入修改后的学生的性别:")
        add_major = input("请输入修改后的学生的专业:")
        add_tel = input("请输入修改后的学生的电话:")
        add_post = input("请输入修改后的学生的邮箱:")
        info = {}
        info["学号"] = add_id
        info["姓名"] = add_name
        info["年级"] = add_grade
        info["班级"] = add_class
        info["性别"] = add_gender
        info["专业"] = add_major
        info["电话"] = add_tel
        info["邮箱"] = add_post
        students.append(info)
        print(students)
    except Exception as e:
        print(f"错误原因:{e}")
def expand_student():
    """5.扩展学生信息"""
    try:
        expand_id = input("请输入你要拓展学生的学号:")
        global students
        info = None
        for i in students:
            if i["学号"] == expand_id:
                info = i
                break
            else:
                print("未找到该学生!")
                return expand_student()
        grade = int(input("请输入你的高考分数:"))
        province = input("请输入你的生源地:")
        info["高考"] = grade
        info["生源地"] = province
        print(students)
    except Exception as e:
        print(f"错误原因:{e}")
while True:
    print("============欢迎来到学生管理系统============")
    print("|           1.添加学生信息                |")
    print("|           2.删除学生信息                |")
    print("|           3.查询学生信息                |")
    print("|           4.修改学生信息                |")
    print("|           5.扩展学生信息                |")
    print("|           6.退出管理系统                |")
    print("=========================================")
    try:
        option = int(input("请选择功能:"))
        if option == 1:
            add_student()
        elif option == 2:
            del_student()
        elif option == 3:
            show_student()
        elif option == 4:
            modify_student()
        elif option == 5:
            expand_student()
        elif option == 6:
            print("已退出！")
            break
        else:
            print("无此序号")
    except Exception as e:
        print("报错原因:",e)
