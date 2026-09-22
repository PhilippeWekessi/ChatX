<?php

namespace App\Http\Controllers;

use App\Models\Message;
use Illuminate\Http\Request;

class MessageController extends Controller
{
    public function index($conversation_id)
    {
        $messages = Message::where('conversation_id', $conversation_id)
            ->with('sender')
            ->orderBy('created_at', 'asc')
            ->get();

        return response()->json($messages);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'conversation_id' => 'required|exists:conversations,id',
            'body' => 'nullable|string',
            'message_type' => 'required|in:text,voice,image,file',
            'media_url' => 'nullable|string',
            'voice_duration' => 'nullable|integer'
        ]);

        $message = Message::create([
            'conversation_id' => $validated['conversation_id'],
            'sender_id' => $request->user()->id,
            'body' => $validated['body'] ?? null,
            'message_type' => $validated['message_type'],
            'media_url' => $validated['media_url'] ?? null,
            'voice_duration' => $validated['voice_duration'] ?? null,
            'is_encrypted' => true
        ]);

        return response()->json($message->load('sender'), 201);
    }

    public function markAsRead($id)
    {
        $message = Message::find($id);
        $message->update(['read_at' => now()]);

        return response()->json($message);
    }
}