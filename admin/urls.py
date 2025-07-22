from . import views
from django.urls import path
app_name = 'admin'

urlpatterns = [
    path('account/', views.manage_account_view, name='account'),
    path('permission/', views.permission_view, name='permission'),
    path('list_of_account/', views.list_of_account_view, name='list_of_account'),
    # Thêm
    path('add_account/', views.add_account_view, name='add_account'),
    path('update_account/<str:user_id>/', views.update_account_view, name='update_account'),
    path('delete_account/<str:user_id>/', views.delete_account_view, name='delete_account'),
    path('update-role/', views.update_user_role, name='update_user_role'),
    path('check_username_email/', views.check_username_email_view, name='check_username_email'),
]