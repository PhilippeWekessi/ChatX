<?php

namespace App\Http\Controllers;

use App\Models\Conversation;
use Illuminate\Http\Request;

class ConversationController extends Controller
{
    public function index(Request $request)
    {
        $conversations = $request->user()->conversations()
            ->with('members', 'messages.sender')
            ->latest('updated_at')
            ->get();

        return response()->json($conversations);
    }

    public function show($id)
    {
        $conversation = Conversation::with('members', 'messages.sender')->find($id);
        
        if (!$conversation) {
            return response()->json(['error' => 'Not found'], 404);
        }

        return response()->json($conversation);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'type' => 'required|in:direct,group',
            'name' => 'nullable|string',
            'member_ids' => 'required|array',
            'member_ids.*' => 'exists:users,id'
        ]);

        $conversation = Conversation::create([
            'type' => $validated['type'],
            'name' => $validated['name'],
            'creator_id' => $request->user()->id,
            'is_encrypted' => true
        ]);

        $conversation->members()->attach(array_merge([$request->user()->id], $validated['member_ids']));

        return response()->json($conversation->load('members'), 201);
    }

    public function getOrCreateDirect(Request $request, $user_id)
    {
        $user = auth()->user();
        
        $existing = Conversation::whereHas('members', function($q) use ($user) {
            $q->where('user_id', $user->id);
        })->whereHas('members', function($q) use ($user_id) {
            $q->where('user_id', $user_id);
        })->where('type', 'direct')->first();

        if ($existing) {
            return response()->json($existing->load('members', 'messages'));
        }

        $conversation = Conversation::create([
            'type' => 'direct',
            'creator_id' => $user->id,
            'is_encrypted' => true
        ]);

        $conversation->members()->attach([$user->id, $user_id]);

        return response()->json($conversation->load('members'), 201);
    }
}