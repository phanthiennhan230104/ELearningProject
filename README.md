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
Django==5.2.3
mysqlclient==2.2.7         # Hoặc dùng PyMySQL nếu không cài được mysqlclient
python-dotenv==1.0.1        # Đọc biến môi trường từ .env
django-widget-tweaks==1.5.0 # Tùy chỉnh form HTML
requests==2.32.3
pillow==11.1.0              # Xử lý ảnh (nếu có upload ảnh)
openai==1.90.0
groq==0.29.0

## 🛠️ Cài đặt và chạy hệ thống
git clone https://github.com/phanthiennhan230104/ELearningProject.git hoặc unzip file đã gửi ở trên sakai đã nộp ( giảng viên môn CS466 )
pip install -r requirements.txt
Xử lí để kết nối database MySQL:
- import file elearning.sql trong Folder database
- Mở file settings.py và chỉnh cấu hình: ( ở USER và PASSWORD chỉnh sửa theo MySQL của máy)
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'elearning',
        'USER': 'root', ## sửa theo máy
        'PASSWORD': 'root',  ## sửa theo máy
        'HOST': 'localhost',
        'PORT': '3306',
    }
}

## 🔐 Tài khoản mẫu
| Vai trò       | Tài khoản| Mật khẩu     |
| ------------- | ---------| ------------ |
| Quản trị viên | admin    | admin2004@   |
| Giảng viên    | gv1      | gv2004       |
| Sinh viên     | hs1      | hs2004       |

## 📁 Cấu trúc thư mục
  pythonproject/
  ├── admin/                       # Chức năng cho admin
  ├── ai/                          # Module xử lý AI / Chatbot
  ├── authentication/              # Đăng nhập, đăng ký, phân quyền
  ├── database/
  │   └── elearning.sql            # File tạo cơ sở dữ liệu
  ├── mainapp/                     # Chức năng khác (Profile, About Us,...)
  ├── media/
  │   ├── assignments/             # Bài tập đã giao bởi giảng viên
  │   └── submissions/             # Bài làm của sinh viên
  ├── newelearning/                # Cấu hình Django
  │   ├── __init__.py
  │   ├── asgi.py
  │   ├── settings.py
  │   ├── urls.py
  │   └── wsgi.py
  ├── static/
  │   ├── css/
  │   └── img/
  ├── student/                     # Chức năng cho sinh viên
  ├── teacher/                     # Chức năng cho giảng viên
  ├── templates/
  │   ├── admin_homepage/
  │   ├── AI/
  │   ├── authentication_homepage/
  │   ├── mainapp/
  │   ├── student_homepage/
  │   └── teacher_homepage/
  ├── .env                         # Biến môi trường (KHÔNG push lên Git)
  ├── .gitignore
  ├── manage.py
  ├── requirements.txt             # pip install -r requirements.txt

## RUN SERVER
python manage.py runserver
Mở trình duyệt: http://127.0.0.1:8000

## 🤝 Đóng góp
Mọi đóng góp đều được chào đón. Vui lòng mở issue hoặc gửi pull request.
