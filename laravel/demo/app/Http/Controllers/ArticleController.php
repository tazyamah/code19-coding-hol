<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Article;

class ArticleController extends Controller
{
    public function add()
    {
        return view('article.add');
    }

    public function create(Request $request)
    {
        $article = new Article;
        $article->content = $request->content;
        $article->save();
        return redirect('/');
    }

    public function index()
    {
        $articles = Article::all();
        return view('article.index', ['articles' => $articles]);
    }

    public function edit(Request $request)
    {
        $article = Article::find($request->id);
        return view('article.edit', ['article' => $article]); 
    }
    
    public function update(Request $request)
    {
        $article = Article::find($request->id);
        $article->content = $request->content;
        $article->save();
        return redirect('/');
    }

    public function delete(Request $request)
    {
        $article = Article::find($request->id);
        return view('article.delete', ['article' => $article]); 
    }
    
    public function remove(Request $request)
    {
        $article = Article::find($request->id);
        $article->delete();
        return redirect('/');
    }
}
