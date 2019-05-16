<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class MicroPostsController extends Controller
{
    public function index(){
      return view('micro_posts.index', [
        'testvar' => "thisistest"
      ]);
    }
}
