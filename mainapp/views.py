from django.shortcuts import render, redirect
from mainapp.models import Profile
from django.contrib.auth.decorators import login_required
from django.contrib import messages

def home_view(request):
    return render(request, "mainapp/homepage.html")

def aboutUs_view(request):
    return render(request, 'mainapp/aboutUs.html')

@login_required
def profile_view(request):
    try:
        profile = request.user.profile
    except Profile.DoesNotExist:
        profile = None

    errors = {}
    form_success = False  # ← lưu lỗi từng trường

    if request.method == 'POST':
        fullname = request.POST.get('fullname', '').strip()
        dob = request.POST.get('dob', '').strip()
        gender = request.POST.get('gender', '').strip()
        phone = request.POST.get('phone', '').strip()
        address = request.POST.get('address', '').strip()

        
        if not fullname:
            errors['fullname'] = "Please enter your first and last name."
        if not dob:
            errors['dob'] = "Please enter your day of birth."
        if not gender:
            errors['gender'] = "Please enter your gender."
        if not phone:
            errors['phone'] = "Please enter your phone."
        if not address:
            errors['address'] = "Please enter your address."

        if not errors:
            if profile:
                profile.fullname = fullname
                profile.dob = dob
                profile.gender = gender
                profile.phone = phone
                profile.address = address
            else:
                profile = Profile.objects.create(
                    user=request.user,
                    fullname=fullname,
                    dob=dob,
                    gender=gender,
                    phone=phone,
                    address=address
                )
            profile.save()
            request.session['form_success'] = f"Update information successfully!"
            return redirect('mainapp:profile')
    form_success = request.session.pop('form_success', None)
    return render(request, 'mainapp/profile.html', {
        'profile': profile,
        'genders': ["Male", "Female", "Other"],
        'form_success' :form_success,
        'errors': errors  
    })

def back_redirect_view(request):
    user = request.user
    role_obj = getattr(user, 'role', None)

    if role_obj:
        role = getattr(role_obj, 'name', '').lower() 

        if role == 'teacher':
            return redirect('authentication:teacher_homepage')
        elif role == 'student':
            return redirect('authentication:student_homepage')
        elif role == 'admin':
            return redirect('authentication:admin_homepage')

    return redirect('mainapp:home_view')  