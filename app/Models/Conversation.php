<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Conversation extends Model
{
    protected $fillable = ['name', 'type', 'creator_id', 'avatar_url', 'is_encrypted'];

    public function members()
    {
        return $this->belongsToMany(User::class, 'conversation_members');
    }

    public function messages()
    {
        return $this->hasMany(Message::class)->orderBy('created_at', 'asc');
    }

    public function creator()
    {
        return $this->belongsTo(User::class, 'creator_id');
    }
}