from django.shortcuts import render, redirect
from django.conf import settings
from groq import Groq
import re
import html
from datetime import datetime

client = Groq(api_key=settings.GROQ_API_KEY)

def chatbot_view(request):
    history = request.session.get('chat_history', [])
    response = None

    if request.method == "POST":
        if request.POST.get("clear_history"):
            request.session['chat_history'] = []
            return redirect('ai:chatbot')

        user_input = request.POST.get("user_input")
        messages = [{"role": "system", "content": "You are a helpful AI assistant."}]
        for item in history:
            messages.append({"role": "user", "content": item['user']})
            messages.append({"role": "assistant", "content": item['bot']})

        messages.append({"role": "user", "content": user_input})

        completion = client.chat.completions.create(
            model="llama3-70b-8192",
            messages=messages,
            temperature=0.7
        )

        bot_reply = completion.choices[0].message.content.strip()
        is_code = False

        # Nếu có block code
        if "```" in bot_reply:
            code_match = re.search(r"```(?:\w+)?\n([\s\S]*?)```", bot_reply)
            if code_match:
                code_content = code_match.group(1).strip()
                bot_reply = f"<pre><code>{html.escape(code_content)}</code></pre>"
                is_code = True
            else:
                # fallback nếu không tách được
                bot_reply = re.sub(r"```(?:\w+)?", "", bot_reply).strip()
                bot_reply = f"<pre><code>{html.escape(bot_reply)}</code></pre>"
                is_code = True
        else:
            # Xử lý nội dung thường
            lines = bot_reply.strip().splitlines()
            lines = [line.strip("• ").strip() for line in lines if line.strip()]
            
            # Giữ lại tối đa 4 dòng đầu tiên
            lines = lines[:15]
            lines = [html.escape(line) for line in lines]

            bot_reply = "<br>".join(lines)
            bot_reply = re.sub(r'(?<!\b[A-Z])\.\s+', '.<br>', bot_reply)

        history.append({'user': user_input, 'bot': bot_reply, 'is_code': is_code, 'timestamp': datetime.now().strftime("%H:%M:%S")})
        request.session['chat_history'] = history
        response = bot_reply

    return render(request, 'ai/chatbot.html', {"history": history})