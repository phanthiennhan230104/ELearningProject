from django.shortcuts import render, redirect, get_object_or_404
from django.conf import settings 
from groq import Groq

from mainapp.models import Submission
from mainapp.models import Lesson, CourseStudent, CourseSubject, Assignment
from django.contrib.auth.decorators import login_required
from django.db.models import Prefetch
from django.http import FileResponse, Http404, JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib import messages

import requests
import json
import re
import os

client = Groq(api_key=settings.GROQ_API_KEY)

@login_required
def learning_view(request):
    user = request.user

    # Lấy danh sách khóa học học sinh đã đăng ký
    course_ids = CourseStudent.objects.filter(student=user).values_list('course__course_id', flat=True)

    # Lấy các môn học trong các khóa học đó
    course_subjects = CourseSubject.objects.filter(course__course_id__in=course_ids)
    course_subject_ids = course_subjects.values_list('course_sub_id', flat=True)

    # Lấy tất cả bài học trong các môn học đó
    lessons = Lesson.objects.filter(course_sub__course_sub_id__in=course_subject_ids) \
        .select_related('course_sub__subject') \
        .prefetch_related(Prefetch('assignment_set', queryset=Assignment.objects.all(), to_attr='assignments'))
    
    context = {
        'lessons': lessons,
        'course_subjects': course_subjects,
        'course_students': CourseStudent.objects.filter(student=user),
    }
    return render(request, 'student_homepage/Learning.html', context)


@csrf_exempt
def run_code_view(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            script = data.get('script', '')
            language = data.get('language', 'python3')
            version_index = data.get('versionIndex', '4')

            if not script.strip():
                return JsonResponse({'output': 'No code provided.'}, status=400)

            payload = {
                'clientId': settings.JDOODLE_CLIENT_ID,
                'clientSecret': settings.JDOODLE_CLIENT_SECRET,
                'script': script,
                'language': language,
                'versionIndex': version_index
            }

            response = requests.post('https://api.jdoodle.com/v1/execute', json=payload)
            result = response.json()

            output = result.get('output')
            if not output:
                return JsonResponse({'output': 'No output received from JDoodle.'}, status=200)

            return JsonResponse({'output': output}, status=200)

        except requests.exceptions.RequestException:
            return JsonResponse({'output': 'Failed to connect to JDoodle API.'}, status=500)
        except Exception:
            return JsonResponse({'output': 'Unexpected server error.'}, status=500)

    return JsonResponse({'output': 'Invalid request method.'}, status=405)

def ide_view(request):
    return render(request, 'student_homepage/IDEOnline.html', {
        'client_id': settings.JDOODLE_CLIENT_ID,
        'client_secret': settings.JDOODLE_CLIENT_SECRET
})

def practice_view(request):
    lessons = Lesson.objects.all()
    course_subjects = CourseSubject.objects.all()

    selected_lesson = request.GET.get('lesson')
    selected_course_sub = request.GET.get('course_sub')

    topic = ""
    content = ""

    if selected_lesson and selected_course_sub:
        try:
            lesson = Lesson.objects.get(pk=selected_lesson, course_sub_id=selected_course_sub)
            topic = lesson.title
            content = lesson.content
        except Lesson.DoesNotExist:
            topic = "Not found"
            content = "No content available."

    return render(request, 'student_homepage/practice.html', {
        'lessons': lessons,
        'course_subjects': course_subjects,
        'selected_lesson': selected_lesson,
        'selected_course_sub': selected_course_sub,
        'topic': topic,
        'content': content,
    })

def get_lessons_by_course_sub(request):
    course_sub_id = request.GET.get('course_sub_id')
    lessons = Lesson.objects.filter(course_sub_id=course_sub_id).values('lesson_id', 'title')
    return JsonResponse({'lessons': list(lessons)})


def get_lesson_content(request):
    lesson_id = request.GET.get('lesson_id')
    course_sub_id = request.GET.get('course_sub_id')
    print("DEBUG:", "lesson_id =", lesson_id, "| course_sub_id =", course_sub_id)

    try:
        lesson = Lesson.objects.get(lesson_id=lesson_id, course_sub__course_sub_id=course_sub_id)
        assignment = Assignment.objects.filter(lesson_id=lesson_id).first()

        file_url = ""
        if assignment and assignment.file:
            file_url = assignment.file.url  # ✅ URL tới file đính kèm

        if assignment:
            return JsonResponse({
                'topic': assignment.title,
                'content': assignment.content,
                'file_url': file_url  # ✅ gửi xuống frontend
            })
        else:
            return JsonResponse({
                'topic': lesson.title,
                'content': 'No assignment found for this lesson.',
                'file_url': ''
            })
    except Lesson.DoesNotExist:
        return JsonResponse({'error': 'Lesson not found'}, status=404)
    except Exception as e:
        return JsonResponse({'error': 'Server error', 'detail': str(e)}, status=500)

@login_required
@csrf_exempt
def submit_assignment(request):
    if request.method == 'POST':
        uploaded_file = request.FILES.get('file')
        lesson_id = request.POST.get('lesson_id')

        try:
            assignment = Assignment.objects.filter(lesson_id=lesson_id).first()
            if not assignment:
                return JsonResponse({'error': 'No assignment found.'}, status=400)

            submission = Submission.objects.create(
                file=uploaded_file,
                assignment=assignment,
                student=request.user
            )
            messages.success(request, 'Submission successful!')
            return redirect('student:practice')  
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)
    return JsonResponse({'error': 'Invalid request method.'}, status=405)

def lesson_detail(request, lesson_id):
    lesson = get_object_or_404(Lesson, pk=lesson_id)
    assignments = Assignment.objects.filter(lesson_id=lesson_id)
    return render(request, 'student_homepage/lesson_detail.html', {
        'lesson': lesson,
        'assignments': assignments
    })

def parse_quiz_text(quiz_text):
    questions = []
    blocks = re.split(r"\n\d+\.", quiz_text)
    for block in blocks:
        if not block.strip():
            continue
        lines = block.strip().splitlines()
        if len(lines) < 6:
            continue  # bỏ nếu không đủ dữ liệu

        q_text = lines[0].strip()
        opts = lines[1:5]
        answer_line = lines[5].strip()
        answer = answer_line.split(":")[-1].strip()[-1] 

        questions.append({
            "question": q_text,
            "options": opts,
            "answer": answer
        })
    return questions

def quizAI_view(request):
    quiz = []
    if request.method == 'POST':
        topic = request.POST.get('topic', '').strip()
        if topic:
            prompt = f"""
Generate exactly 5 multiple-choice quiz questions on the topic: "{topic}".
Each question must follow this strict format:

1. Question text?
A. Option A
B. Option B
C. Option C
D. Option D
Answer: A

Only output the questions in this format. Do not include explanations or introductions.
"""

            completion = client.chat.completions.create(
                model="llama3-70b-8192",
                messages=[
                    {"role": "system", "content": "You are a helpful AI that generates quizzes."},
                    {"role": "user", "content": prompt},
                ],
                temperature=0.7
            )

            raw_text = completion.choices[0].message.content.strip()

            # Parse thành list các câu hỏi
            blocks = re.split(r'\n(?=\d+\.\s)', raw_text)
            for block in blocks:
                if "Answer:" not in block:
                    continue

                parts = block.strip().split('\n')
                question_line = parts[0][3:]  # Bỏ "1. "
                options = [line.strip() for line in parts[1:5] if line.strip()]
                answer_line = next((l for l in parts if l.lower().startswith("answer:")), None)
                answer = answer_line.split(":")[1].strip() if answer_line else ''

                quiz.append({
                    'question': question_line,
                    'options': options,
                    'answer': answer
                })

    return render(request, 'student_homepage/QuizAI.html', {'quiz': quiz})

@csrf_exempt
def get_ai_feedback(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            code = data.get('code', '').strip()

            if not code:
                return JsonResponse({'feedback': 'No code provided.'}, status=400)

            prompt = f"""
            Bạn là một trợ lý lập trình chuyên nghiệp.

            Hãy đánh giá đoạn mã sau bằng tiếng Việt:
            - Phân tích xem mã có vấn đề gì không (nếu có).
            - Gợi ý cách cải thiện hoặc tối ưu.
            - Đánh giá mức độ dễ hiểu (Clarity) và hiệu quả (Efficiency) trên thang điểm 10.

            Chỉ phản hồi bằng văn bản thuần, dễ đọc, không dùng markdown.
            Dưới đây là đoạn mã cần đánh giá:

            {code}
            """

            response = client.chat.completions.create(
                model="llama3-70b-8192",
                messages=[
                    {"role": "system", "content": "You are a code reviewer."},
                    {"role": "user", "content": prompt}
                ],
                temperature=0.5,
                max_tokens=500
            )

            feedback = response.choices[0].message.content.strip()
            return JsonResponse({'feedback': feedback})
        except Exception as e:
            return JsonResponse({'feedback': f'Error occurred: {str(e)}'}, status=500)

    return JsonResponse({'feedback': 'Invalid request method.'}, status=405)
