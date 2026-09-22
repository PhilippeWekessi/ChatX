<?php

namespace App\Http\Controllers;

use App\Models\Story;
use Illuminate\Http\Request;

class StoryController extends Controller
{
    public function index()
    {
        $stories = Story::where('expires_at', '>', now())
            ->with('user')
            ->get();

        return response()->json($stories);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'media_url' => 'required|string'
        ]);

        $story = Story::create([
            'user_id' => $request->user()->id,
            'media_url' => $validated['media_url'],
            'expires_at' => now()->addHours(24)
        ]);

        return response()->json($story, 201);
    }

    public function destroy($id)
    {
        $story = Story::find($id);
        $story->delete();

        return response()->json(['message' => 'Deleted']);
    }
}