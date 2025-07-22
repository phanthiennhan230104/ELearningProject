from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth import authenticate, login, logout
from django.core.mail import send_mail
from django.conf import settings
from django.contrib.auth import get_user_model
from django.contrib.auth.decorators import login_required, user_passes_test
from mainapp.models import Account

import random

User = get_user_model()

# Gửi OTP qua email
def send_otp_to_email(email, otp):
    subject = 'Xác thực tài khoản 2FA'
    message = f'Mã xác thực của bạn là: {otp}'
    send_mail(subject, message, settings.EMAIL_HOST_USER, [email])

# Đăng ký
def signup(request):
    if request.method == "POST":
        username = request.POST.get('username')
        password = request.POST.get('password')
        confirmPassword = request.POST.get('confirmPassword')
        email = request.POST.get('email')

        if password != confirmPassword:
            return redirect('authentication:signup')

        otp = str(random.randint(100000, 999999))
        send_otp_to_email(email, otp)

        request.session['otp'] = otp
        request.session['temp_user'] = {
            'username': username,
            'password': password,
            'confirmPassword': confirmPassword,
            'email': email,
            'is_email_verified': False
        }
        return redirect('authentication:verify_otp')

    return render(request, "authentication/register.html")

# Xác thực OTP khi đăng ký
def verify_otp(request):
    if request.method == "POST":
        entered_otp = request.POST.get('otp')
        session_otp = request.session.get('otp')
        user_data = request.session.get('temp_user')

        if entered_otp == session_otp and user_data:
            if User.objects.filter(username=user_data['username']).exists():
                return redirect('authentication:signup')

            user = User.objects.create_user(
                username=user_data['username'],
                email=user_data['email'],
                password=user_data['password'],
                role_id=1,
            )
            user.is_email_verified = True
            user.save()

            account, created = Account.objects.get_or_create(user=user)
            account.is_email_verified = True
            account.is_teacher = False
            account.save()

            request.session.pop('otp')
            request.session.pop('temp_user')

            return redirect('authentication:signin')
        else:
            return redirect('authentication:verify_otp')

    return render(request, "authentication/verify_otp.html", {
        'title': "Verify registration",
        'instruction': "Please enter the OTP code sent to your email to complete registration."
    })

# Đăng nhập (bước 1)
def signin(request):
    if request.user.is_authenticated:
        try:
            account = request.user.account
            if account.is_teacher:
                request.session['role_id'] = '3'
                return redirect('authentication:teacher_homepage')
            else:
                request.session['role_id'] = '1'
                return redirect('authentication:student_homepage')
        except Account.DoesNotExist:
            if request.user.is_superuser:
                return redirect('authentication:admin_homepage')
            logout(request)
            return redirect('authentication:signin')

    if request.method == "POST":
        username = request.POST.get('username')
        password = request.POST.get('password')

        user = authenticate(username=username, password=password)
        if user is not None:
            # ✅ Superuser không cần OTP
            if user.is_superuser:
                login(request, user)
                return redirect('authentication:admin_homepage')

            try:
                account = user.account
                if not user.is_email_verified:  # ← kiểm tra từ CustomUser
                    return redirect('authentication:signup')
            except Account.DoesNotExist:
                return redirect('authentication:signin')

            # Gửi OTP
            otp = str(random.randint(100000, 999999))
            send_otp_to_email(user.email, otp)

            request.session['login_otp'] = otp
            request.session['temp_login_user'] = user.username

            return redirect('authentication:verify_login_otp')

        else:
            return redirect('authentication:signin')

    return render(request, "authentication/login.html")

# Xác thực OTP khi đăng nhập (2FA)
def verify_login_otp(request):
    if request.method == "POST":
        entered_otp = request.POST.get('otp')
        session_otp = request.session.get('login_otp')
        username = request.session.get('temp_login_user')

        if entered_otp == session_otp and username:
            try:
                user = User.objects.get(username=username)
                login(request, user)

                del request.session['login_otp']
                del request.session['temp_login_user']

                if user.is_superuser:
                    return redirect('authentication:admin_homepage')

                account = user.account
                if account.is_teacher:
                    return redirect('authentication:teacher_homepage')
                else:
                    return redirect('authentication:student_homepage')

            except User.DoesNotExist:
                return redirect('authentication:signin')
        else:
            return redirect('authentication:verify_login_otp')

    return render(request, "authentication/verify_otp.html", {
        'title': "Login authentication",
        'instruction': "Please enter the OTP code sent to your email to complete login."
    })

# Đăng xuất
def signout(request):
    logout(request)
    return redirect('mainapp:home_view')

# Trang chủ giáo viên
def teacher_homepage(request):
    if not request.user.is_authenticated:
        return redirect('authentication:signin')
    try:
        account = request.user.account
        if not account.is_teacher:
            return redirect('authentication:student_homepage')
    except Account.DoesNotExist:
        return redirect('authentication:signin')
    return render(request, "authentication/homepage_gv.html")

# Trang chủ học sinh
def student_homepage(request):
    if not request.user.is_authenticated:
        return redirect('authentication:signin')
    try:
        account = Account.objects.get(user=request.user)
        if account.is_teacher:
            return redirect('authentication:teacher_homepage')
    except Account.DoesNotExist:
        return redirect('authentication:signin')
    return render(request, "authentication/homepage_hs.html")

# Trang chủ admin
@login_required
@user_passes_test(lambda user: user.is_superuser)
def admin_homepage(request):
    return render(request, "authentication/homepage_admin.html")
