# 📚 E-Learning Project
 AI-integrated programming learning system for Perl & Python. Developed by CS466 group 5 - Duy Tan University.

## 🚀 Tính năng chính
- ✅ Đăng nhập / Đăng ký / Xác thực / Phân quyền
- 🤖 Chatbot AI hỗ trợ học tập (Groq / OpenAI)
- 📝 Làm bài, nộp bài và chấm điểm thủ công
- 📚 Xem bài giảng, bài tập theo khóa học
- 🧠 Tạo quiz luyện tập bằng AI
- ⚙️ Trang quản trị: Quản lý người dùng, khóa học, môn học

## ⚙️ Yêu cầu hệ thống (pip install ...)
<pre>
Python >= 3.8
MySQL >= 5.7
pip install Django==5.2.3
pip install mysqlclient==2.2.7         # Hoặc: pip install PyMySQL
pip install python-dotenv==1.0.1        # Đọc biến môi trường từ .env
pip install django-widget-tweaks==1.5.0 # Tuỳ chỉnh form HTML
pip install requests==2.32.3
pip install pillow==11.1.0              # Xử lý ảnh (nếu có upload ảnh)
pip install openai==1.90.0
pip install groq==0.29.0</pre>
🔁 Hoặc dùng file requirements.txt:
pip install -r requirements.txt

## 🛠️ Cài đặt và chạy hệ thống
<pre>
git clone https://github.com/phanthiennhan230104/ELearningProject.git hoặc unzip file đã gửi ở trên sakai đã nộp ( giảng viên môn CS466 )
pip install -r requirements.txt
Xử lí để kết nối database MySQL:
- import file elearning.sql trong Folder database
- Mở file settings.py và chỉnh cấu hình: ( ở USER và PASSWORD chỉnh sửa theo MySQL của máy)</pre>
<pre>
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'elearning',
        'USER': 'root', ## sửa theo máy
        'PASSWORD': 'root',  ## sửa theo máy
        'HOST': 'localhost',
        'PORT': '3306',
    }
}</pre>

## 🔐 Tài khoản mẫu
| Vai trò       | Tài khoản| Mật khẩu     |
| ------------- | ---------| ------------ |
| Quản trị viên | admin    | admin2004@   |
| Giảng viên    | gv1      | gv2004       |
| Sinh viên     | hs1      | hs2004       |

## 📁 Cấu trúc thư mục
<pre>pythonproject/
├── admin/                    # Chức năng cho admin
├── ai/                       # Module xử lý AI / Chatbot
├── authentication/          # Đăng nhập, đăng ký, phân quyền
├── database/
│   └── elearning.sql         # File tạo CSDL
├── mainapp/                 # Ứng dụng chính
│   ├── migrations/
│   ├── __init__.py
│   ├── admin.py
│   ├── apps.py
│   ├── models.py
│   ├── tests.py
│   ├── urls.py
│   └── views.py
├── media/
│   ├── assignments/         # Bài tập giao
│   └── submissions/         # Bài làm của sinh viên
├── newelearning/            # Cấu hình Django
│   ├── __init__.py
│   ├── asgi.py
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── static/
│   ├── css/
│   └── img/
├── student/                 # Chức năng cho sinh viên
├── teacher/                 # Chức năng cho giảng viên
├── templates/
│   ├── admin_homepage/
│   ├── AI/
│   ├── authentication_homepage/
│   ├── mainapp/
│   ├── student_homepage/
│   └── teacher_homepage/
├── .env                     # Biến môi trường (KHÔNG push lên GitHub)
├── .gitignore
├── manage.py
├── requirements.txt</pre>

## RUN SERVER
<pre>
python manage.py runserver
Mở trình duyệt: http://127.0.0.1:8000</pre>

## 🤝 Đóng góp
Mọi đóng góp đều được chào đón. Vui lòng mở issue hoặc gửi pull request.
