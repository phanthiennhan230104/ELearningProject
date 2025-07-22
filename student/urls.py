from . import views
from django.urls import path
from . import views
from django.conf import settings
from django.conf.urls.static import static
    
app_name = 'student'

urlpatterns = [
    path('learning/', views.learning_view, name='learning'),
    path('ide/', views.ide_view, name='ide'),
    path('run_code/', views.run_code_view, name='run_code'),
    path('get_ai_feedback/', views.get_ai_feedback, name='get_ai_feedback'),
    path('practice/', views.practice_view, name='practice'),
    path('quizAI/', views.quizAI_view, name='quizAI'),
    path('learning/<int:lesson_id>/', views.lesson_detail, name='lesson_detail'),
    path('get_lesson_content/', views.get_lesson_content, name='get_lesson_content'),
    path('get_lessons_by_course_sub/', views.get_lessons_by_course_sub, name='get_lessons_by_course_sub'),
    path('submit_assignment/', views.submit_assignment, name='submit_assignment'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)