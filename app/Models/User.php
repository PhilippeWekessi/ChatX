<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, Notifiable;

    protected $fillable = ['first_name', 'last_name', 'email', 'phone', 'password', 'avatar_url', 'status'];
    protected $hidden = ['password'];
    protected $casts = ['created_at' => 'datetime'];

    public function conversations()
    {
        return $this->belongsToMany(Conversation::class, 'conversation_members');
    }

    public function messages()
    {
        return $this->hasMany(Message::class, 'sender_id');
    }

    public function stories()
    {
        return $this->hasMany(Story::class);
    }

    public function contacts()
    {
        return $this->belongsToMany(User::class, 'contacts', 'user_id', 'contact_id');
    }
}