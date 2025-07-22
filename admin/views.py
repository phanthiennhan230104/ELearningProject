from django.shortcuts import render, redirect, get_object_or_404
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import require_GET
from django.contrib import messages
from django.contrib.auth.hashers import make_password
from django.db.models import Q
from datetime import date
from mainapp.models import CustomUser, Role, Account, Profile
import json

def manage_account_view(request):
    search_query = request.GET.get('search', '')
    role_filter = request.GET.get('role', '')

    accounts = CustomUser.objects.select_related('role', 'profile').exclude(role__name='Admin')

    if role_filter:
        accounts = accounts.filter(role__name__iexact=role_filter)

    if search_query:
        accounts = accounts.filter(profile__fullname__icontains=search_query)

    roles = Role.objects.exclude(name='Admin')

    return render(request, 'admin_homepage/admin_manage_account.html', {
        'accounts': accounts,
        'roles': roles
    })


def permission_view(request):
    role_filter = request.GET.get('role')
    search_query = request.GET.get('search')

    users = CustomUser.objects.select_related('role', 'profile').filter(
        role__name__in=['Teacher', 'Student']
    )

    if role_filter:
        users = users.filter(role__name__iexact=role_filter)
    if search_query:
        users = users.filter(profile__fullname__icontains=search_query)

    roles = Role.objects.filter(name__in=['Teacher', 'Student'])

    return render(request, 'admin_homepage/admin_permission.html', {
        'users': users,
        'roles': roles
    })


@csrf_exempt
def update_account_view(request, user_id):
    user = get_object_or_404(CustomUser.objects.select_related('profile', 'role'), user_id=user_id)

    if request.method == 'POST':
        username = request.POST.get('username')
        fullname = request.POST.get('fullname')
        email = request.POST.get('email')
        password = request.POST.get('password')

        user.username = username
        user.email = email
        if password:
            user.set_password(password)
        user.save()

        if hasattr(user, 'profile'):
            user.profile.fullname = fullname
            user.profile.save()

        messages.success(request, 'Account updated successfully.')
        return redirect('admin:account')

    roles = Role.objects.exclude(name='Admin')
    return render(request, 'admin_homepage/admin_update.html', {
        'user': user,
        'roles': roles,
    })


def delete_account_view(request, user_id):
    if request.method == 'POST':
        user = get_object_or_404(CustomUser, user_id=user_id)
        user.delete()
        messages.success(request, 'Account deleted successfully.')
    return redirect('admin:account')


@csrf_exempt
def update_user_role(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            user_id = data.get('user_id')
            new_role_id = data.get('role_id')

            user = CustomUser.objects.get(user_id=user_id)
            new_role = Role.objects.get(role_id=new_role_id)

            user.role = new_role
            user.save()

            if hasattr(user, 'account'):
                user.account.is_teacher = (new_role.name.lower() == 'teacher')
                user.account.save()

            return JsonResponse({'status': 'success'})
        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)}, status=400)


def list_of_account_view(request):
    role_name = request.GET.get('role', None)
    if role_name:
        accounts = CustomUser.objects.filter(role__name__iexact=role_name)
    else:
        accounts = CustomUser.objects.all()

    return render(request, 'admin_homepage/admin_list_account.html', {
        'accounts': accounts
    })


def add_account_view(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        email = request.POST.get('email')
        password = request.POST.get('password')
        confirm_password = request.POST.get('confirmPassword')
        role_id = request.POST.get('role')
        fullname = request.POST.get('fullname')

        if password != confirm_password:
            messages.error(request, 'Password and confirm password do not match!')
            return redirect('admin:add_account')

        if CustomUser.objects.filter(username=username).exists():
            messages.error(request, 'Username already exists!')
            return redirect('admin:add_account')

        if CustomUser.objects.filter(email=email).exists():
            messages.error(request, 'Email is already in use!')
            return redirect('admin:add_account')

        user = CustomUser.objects.create(
            username=username,
            email=email,
            password=make_password(password),
            role_id=role_id,
            is_email_verified=True
        )

        Account.objects.create(
            user=user,
            is_teacher=(user.role.name.lower() == 'teacher'),
            is_email_verified=True
        )

        Profile.objects.create(
            user=user,
            fullname=fullname,
            dob=date(2000, 1, 1),
            gender='Other'
        )

        messages.success(request, 'Account created successfully!')
        return redirect('admin:account')

    roles = Role.objects.exclude(name='Admin')
    return render(request, 'admin_homepage/admin_add_account.html', {
        'roles': roles
    })


@require_GET
def check_username_email_view(request):
    username = request.GET.get('username', '')
    email = request.GET.get('email', '')

    data = {
        'username_exists': CustomUser.objects.filter(username=username).exists() if username else False,
        'email_exists': CustomUser.objects.filter(email=email).exists() if email else False,
    }

    return JsonResponse(data)
