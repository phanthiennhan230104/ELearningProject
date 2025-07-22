from django.contrib import admin
from django.urls import path
from . import views
from . import urls
app_name = 'teacher'
urlpatterns = [
    path('manage_student/', views.manage_student, name='manage_student'),
    path('add_student_to_course/<int:student_id>/<int:course_id>/', views.add_student_to_course, name='add_student_to_course'),   
    path('grade/<int:sub_id>/', views.grade_submission, name='grade_submission'),
    path('delete-submission/<int:sub_id>/', views.delete_submission, name='delete_submission'),
    path('see-review/', views.see_review, name='see_review'),
    path('delete-feedback/<int:feedback_id>/', views.delete_feedback, name='delete_feedback'),
    path('create-quiz/', views.create_quiz, name='create-quiz'),
    path('manage-course-subject/', views.manage_course_subject, name='manage-course-subject'),
    path('add-subject/', views.add_subject, name='add-subject'),
    path('update-subject/<int:id>/', views.update_subject, name='update-subject'),
    path('delete-subject/<int:id>/', views.delete_subject, name='delete-subject'),
    path('add-course/', views.add_course, name='add-course'),
    path('update-course/<int:id>/', views.update_course, name='update-course'),
    path('delete-course/<int:id>/', views.delete_course, name='delete-course'),
    path('course-subject-lesson/', views.course_subject_lesson, name='manage-course-subject'),
    path('link-course-subject/', views.link_course_subject, name='link-course-subject'),
    path('delete-course-subject/<int:id>/', views.delete_course_subject, name='delete-course-subject'),
    path('add-lesson/', views.add_lesson, name='add-lesson'),
    path('delete-lesson/<int:id>/', views.delete_lesson, name='delete-lesson'),
    path('update-lesson/<int:id>/', views.update_lesson, name='update-lesson'),
    path('delete_student/<int:student_id>/', views.delete_student, name='delete_student'),

]