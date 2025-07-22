from django.urls import path
from . import views

app_name = 'mainapp'

urlpatterns = [
    path('', views.home_view, name='home_view'),
    path('aboutUs/', views.aboutUs_view, name="aboutUs"),
    path('profile/', views.profile_view, name='profile'),
    path('back/', views.back_redirect_view, name='back'),
]

