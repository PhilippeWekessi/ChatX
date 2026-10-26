<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class AuthApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_register_and_receive_an_api_token(): void
    {
        $response = $this->postJson('/api/auth/register', [
            'first_name' => 'Alex',
            'last_name' => 'Martin',
            'email' => 'alex@example.com',
            'phone' => '+33612345678',
            'password' => 'secure-pass-123',
            'password_confirmation' => 'secure-pass-123',
        ]);

        $response
            ->assertCreated()
            ->assertJsonStructure([
                'user' => ['id', 'first_name', 'last_name', 'email'],
                'token',
            ]);

        $this->assertDatabaseHas('users', [
            'email' => 'alex@example.com',
            'first_name' => 'Alex',
            'last_name' => 'Martin',
        ]);
    }

    public function test_registration_rejects_a_password_confirmation_mismatch(): void
    {
        $this->postJson('/api/auth/register', [
            'first_name' => 'Alex',
            'last_name' => 'Martin',
            'email' => 'alex@example.com',
            'password' => 'secure-pass-123',
            'password_confirmation' => 'different-pass-123',
        ])->assertUnprocessable()
            ->assertJsonValidationErrors('password');
    }

    public function test_user_can_log_in_and_use_their_api_token(): void
    {
        $user = User::create([
            'first_name' => 'Alex',
            'last_name' => 'Martin',
            'email' => 'alex@example.com',
            'password' => Hash::make('secure-pass-123'),
        ]);

        $loginResponse = $this->postJson('/api/auth/login', [
            'email' => 'alex@example.com',
            'password' => 'secure-pass-123',
        ]);

        $loginResponse->assertOk()->assertJsonStructure(['user', 'token']);

        $this->withToken($loginResponse->json('token'))
            ->getJson('/api/auth/me')
            ->assertOk()
            ->assertJsonPath('email', $user->email);
    }
}
