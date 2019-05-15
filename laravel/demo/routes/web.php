<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

/*
Route::get('/', function () {
    return view('welcome');
});
*/

//Route::get('/', 'MicroPostsController@index');
Route::get('/', 'ArticleController@index')->name('article_index');
Route::get('/article/add', 'ArticleController@add')->name('article_add');
Route::post('/article/add', 'ArticleController@create')->name('article_create');
//Route::get('/article/index', 'ArticleController@index')->name('article_index');
Route::get('/article/edit', 'ArticleController@edit')->name('article_edit');
Route::post('/article/edit', 'ArticleController@update')->name('article_update');
Route::get('/article/delete', 'ArticleController@delete')->name('article_delete');
Route::post('/article/remove', 'ArticleController@remove')->name('article_remove');
