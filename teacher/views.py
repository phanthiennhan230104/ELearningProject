from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.contrib.auth.hashers import make_password
from mainapp.models import CustomUser, Course, CourseStudent, CourseSubject
from mainapp.models import CustomUser
from django.contrib.auth import get_user_model
from mainapp.models import CourseFeedback, Profile, Course
from django.http import HttpResponseBadRequest

from django.core.paginator import Paginator

from mainapp.models import Lesson, Assignment, Submission
from django.utils import timezone
import os
from django.conf import settings

from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from django.contrib import messages
from mainapp.models import Subject
from django.db.models import Q

User = get_user_model()

def manage_student(request):
    search_query = request.GET.get('search', '').strip()
    selected_course_id = request.GET.get('course_id', '').strip()
    course_students = set()
    if selected_course_id.isdigit():
        course_students = set(
            CourseStudent.objects.filter(course_id=selected_course_id).values_list('student__user_id', flat=True)
        )
    students = CustomUser.objects.filter(
        role_id=1,
        user_id__isnull=False
    ).select_related('profile')

    students = search_students(students, search_query)
    courses = Course.objects.all()

    form_success = request.session.pop('form_success', None)

    return render(request, 'teacher_homepage/manage_student.html', {
        'students': students,
        'search_query': search_query,
        'courses': courses,
        'selected_course_id': int(selected_course_id) if selected_course_id.isdigit() else None,
        'form_success': form_success, 
        'course_students': course_students, 
    })


def search_students(queryset, search_query):
    if search_query:
        queryset = queryset.filter(
            Q(profile__fullname__icontains=search_query) |
            Q(profile__fullname__isnull=True, username__icontains=search_query)
        )
    return queryset

def delete_student(request, student_id):
    course_id = request.GET.get('course_id')

    if not course_id or not course_id.isdigit():
        return HttpResponseBadRequest("Course ID is required and must be a valid number.")

    student = get_object_or_404(CustomUser, user_id=student_id)
    course = get_object_or_404(Course, course_id=int(course_id))

    CourseStudent.objects.filter(student=student, course=course).delete()

    request.session['form_success'] = f"Removed student {student.username} from course {course.title}."
    return redirect('teacher:manage_student')


def add_student_to_course(request, student_id, course_id):
    student = get_object_or_404(CustomUser, user_id=student_id)
    course = get_object_or_404(Course, course_id=course_id)

    form_success = False

    if not CourseStudent.objects.filter(student=student, course=course).exists():
        CourseStudent.objects.create(
            student=student,
            course=course,
            enrolled_at=timezone.now()
        )
        form_success = True

    fullname = student.profile.fullname if hasattr(student, 'profile') and student.profile.fullname else student.username

    request.session['form_success'] = (
        f"Added student {fullname} to course {course.title} successful."
        if form_success else
        f"Student {fullname} is already in the course {course.title}"
    )

    return redirect('teacher:manage_student')

def see_review(request):
    feedbacks, course_id = get_filtered_feedbacks(request)
    courses = Course.objects.all()

    paginator = Paginator(feedbacks, 3)  # 3 đánh giá mỗi trang
    page_number = request.GET.get('page')
    page_obj = paginator.get_page(page_number)

    student_reviews = []
    for feedback in page_obj:
        student = feedback.student
        profile = getattr(student, 'profile', None)
        name = profile.fullname if profile else student.username

        student_reviews.append({
            'cf_id': feedback.cf_id,
            'name': name,
            'rating': feedback.rating,
            'review': feedback.comment,
            'submitted_at': feedback.submitted_at,
        })

    return render(request, 'teacher_homepage/see_review.html', {
        'student_reviews': student_reviews,
        'page_obj': page_obj,
        'courses': courses,
        'selected_course_id': int(course_id) if course_id else ''
    })

def get_filtered_feedbacks(request):
    course_id = request.GET.get('course')

    if course_id:
        feedbacks = CourseFeedback.objects.filter(course__course_id=course_id)
    else:
        feedbacks = CourseFeedback.objects.all()

    feedbacks = feedbacks.select_related('student__profile', 'course').order_by('-submitted_at')
    return feedbacks, course_id

def delete_feedback(request, feedback_id):
    feedback = get_object_or_404(CourseFeedback, pk=feedback_id)
    feedback.delete()
    return redirect('teacher:see_review')

def create_quiz(request):
    lessons = Lesson.objects.all()
    all_assignments = Assignment.objects.all()  
    filtered_assignments = all_assignments    
    submissions = []

    selected_lesson_id = request.GET.get('lesson_id')
    selected_assignment_id = request.GET.get('assignment_id')

    if selected_lesson_id:
        filtered_assignments = Assignment.objects.filter(lesson__lesson_id=selected_lesson_id)

    if selected_lesson_id and selected_assignment_id:
        submissions = Submission.objects.filter(
            assignment_id=selected_assignment_id,
            assignment__lesson_id=selected_lesson_id
        ).select_related('student', 'assignment')

    if request.method == 'POST':
        lesson_id = request.POST.get('lesson_id')
        title = request.POST.get('title')
        description = request.POST.get('description')
        content = request.POST.get('content')
        start_date = request.POST.get('start_date')
        due = request.POST.get('due')
        file = request.FILES.get('file')

        Assignment.objects.create(
            lesson_id=lesson_id,
            title=title,
            description=description,
            content=content,
            start_date=start_date,
            due=due,
            file=file
        )

        return redirect('teacher:create-quiz')

    return render(request, 'teacher_homepage/create-quiz.html', {
        'lessons': lessons,
        'assignments': all_assignments, 
        'filtered_assignments': filtered_assignments,
        'submissions': submissions,
        'selected_lesson_id': selected_lesson_id,
        'selected_assignment_id': selected_assignment_id
    })

def grade_submission(request, sub_id):
    submission = get_object_or_404(Submission, pk=sub_id)
    lesson_id = submission.assignment.lesson.lesson_id
    assignment_id = submission.assignment.assignment_id

    if request.method == 'POST':
        point = request.POST.get('point')
        if point:
            try:
                submission.point = float(point) 
                submission.save()
            except ValueError:
                pass 
        return redirect(f'/teacher/create-quiz/?lesson_id={lesson_id}&assignment_id={assignment_id}')

    return render(request, 'teacher_homepage/grade_submission.html', {
        'submission': submission,
        'lesson_id': lesson_id,
        'assignment_id': assignment_id
    })

def delete_submission(request, sub_id):
    submission = get_object_or_404(Submission, sub_id=sub_id)
    assignment_id = submission.assignment.assignment_id
    lesson_id = submission.assignment.lesson.lesson_id
    submission.delete()
    return redirect(f'/teacher/create-quiz/?lesson_id={lesson_id}&assignment_id={assignment_id}')

def manage_course_subject(request):
    subjects = Subject.objects.all()
    courses = Course.objects.all().order_by('-created_date')
    return render(request, 'teacher_homepage/manage-course-subject.html', {
        'subjects': subjects,
        'courses': courses,
    })

@csrf_exempt
def add_subject(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        name = data.get('name')
        desc = data.get('desc')

        if name:
            Subject.objects.create(name=name, desc=desc)
            return JsonResponse({'message': 'Subject added successfully'})
        else:
            return JsonResponse({'message': 'Name is required'}, status=400)
    return JsonResponse({'message': 'Invalid request'}, status=400)

def update_subject(request, id):
    if request.method == 'PUT':
        try:
            data = json.loads(request.body)
            subject = Subject.objects.get(pk=id)
            subject.name = data['name']
            subject.desc = data['desc']
            subject.save()
            return JsonResponse({'message': 'Subject updated successfully'})
        except Subject.DoesNotExist:
            return JsonResponse({'error': 'Subject not found'}, status=404)
        
@csrf_exempt
def delete_subject(request, id):
    print("🔍 Request method:", request.method)
    if request.method == 'POST':
        try:
            subject = Subject.objects.get(pk=id)
            subject.delete()
            return JsonResponse({'message': 'Subject deleted successfully'})
        except Subject.DoesNotExist:
            return JsonResponse({'error': 'Subject not found'}, status=404)
    else:
        return JsonResponse({'error': 'Invalid request method'}, status=405)
    
@csrf_exempt
def add_course(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            title = data.get('title')
            description = data.get('description')
            year = data.get('year')
            teacher_id = data.get('teacher_id')

            if not (title and teacher_id):
                return JsonResponse({'error': 'Missing required fields'}, status=400)

            Course.objects.create(
                title=title,
                description=description,
                year=year,
                teacher_id=teacher_id
            )

            return JsonResponse({'message': 'Course added successfully'})
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)

    return JsonResponse({'error': 'Invalid request method'}, status=405)

@csrf_exempt
def update_course(request, id):
    if request.method == 'PUT':
        try:
            data = json.loads(request.body)
            course = Course.objects.get(pk=id)

            course.title = data.get('title')
            course.description = data.get('description')
            course.year = data.get('year')
            course.save()
            return JsonResponse({'message': 'Course updated successfully'})
        except Course.DoesNotExist:
            return JsonResponse({'error': 'Course not found'}, status=404)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)

    return JsonResponse({'error': 'Invalid request method'}, status=405)

@csrf_exempt
def delete_course(request, id):
    if request.method == 'POST':
        try:
            course = Course.objects.get(pk=id)
            course.delete()
            return JsonResponse({'message': 'Course deleted successfully'})
        except Course.DoesNotExist:
            return JsonResponse({'error': 'Course not found'}, status=404)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request method'}, status=405)

def course_subject_lesson(request):
    courses = Course.objects.all()
    subjects = Subject.objects.all()
    course_subjects = CourseSubject.objects.select_related('course', 'subject').all()
    lessons = Lesson.objects.select_related(
        'course_sub__course',
        'course_sub__subject'
    ).all()

    return render(request, 'teacher_homepage/course-subject-lesson.html', {
        'courses': courses,
        'subjects': subjects,
        'course_subjects': course_subjects,
        'lessons': lessons
    })

@csrf_exempt
def link_course_subject(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            course_id = data.get('course_id')
            subject_id = data.get('subject_id')

            course = Course.objects.get(pk=course_id)
            subject = Subject.objects.get(pk=subject_id)

            if CourseSubject.objects.filter(course=course, subject=subject).exists():
                return JsonResponse({'error': 'Link already exists'}, status=400)

            CourseSubject.objects.create(course=course, subject=subject)
            return JsonResponse({'message': 'Link successfully!'})
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)

    return JsonResponse({'error': 'Invalid request method'}, status=405)

@csrf_exempt
def delete_course_subject(request, id):
    if request.method == 'DELETE':
        try:
            cs = CourseSubject.objects.get(pk=id)
            cs.delete()
            return JsonResponse({'message': 'Delete link successfully!'})
        except CourseSubject.DoesNotExist:
            return JsonResponse({'error': 'Error!'}, status=404)
    return JsonResponse({'error': 'Invalid request method'}, status=405)

@csrf_exempt
def add_lesson(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            title = data.get('title')
            description = data.get('description')
            content = data.get('content')

            course_sub_id = data.get('course_sub_id')

            course_sub = CourseSubject.objects.get(pk=course_sub_id)
            Lesson.objects.create(
                title=title,
                description=description,
                content=content,
                course_sub=course_sub
            )
            return JsonResponse({'message': 'Add lesson successfully!'})
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid method'}, status=405)

@csrf_exempt
def delete_lesson(request, id):
    if request.method == 'DELETE':
        try:
            lesson = Lesson.objects.get(pk=id)
            lesson.delete()
            return JsonResponse({'message': 'Delete lesson successfully!'})
        except Lesson.DoesNotExist:
            return JsonResponse({'error': 'Lesson is unavailable!'}, status=404)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid method'}, status=405)

def update_lesson(request, id):
    lesson = get_object_or_404(Lesson, pk=id)
    course_subjects = CourseSubject.objects.select_related('course', 'subject').all()

    if request.method == 'POST':
        title = request.POST.get('title')
        description = request.POST.get('description')
        content = request.POST.get('content')
        course_sub_id = request.POST.get('course_sub_id')

        try:
            course_sub = CourseSubject.objects.get(pk=course_sub_id)
            lesson.title = title
            lesson.description = description
            lesson.content = content
            lesson.course_sub = course_sub
            lesson.save()
            return redirect('teacher:manage-course-subject') 
        except Exception as e:
            return render(request, 'teacher_homepage/update-lesson.html', {
                'lesson': lesson,
                'course_subjects': course_subjects,
                'error': str(e)
            })

    return render(request, 'teacher_homepage/update-lesson.html', {
        'lesson': lesson,
        'course_subjects': course_subjects
    })
    