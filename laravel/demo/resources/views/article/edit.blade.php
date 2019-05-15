    create<br>

    <form action='{{ route('article_update') }}' method='post'>
        {{ csrf_field() }}
        <input type='hidden' name='id' value='{{ $article->id }}'><br>
        content:<input type='text' name='content' value='{{ $article->content }}'><br>
        <input type='submit' value='submit'>
    </form>
