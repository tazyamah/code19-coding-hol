    remove<br>

    <form action='{{ route('article_remove') }}' method='post'>
        {{ csrf_field() }}
            <input type='hidden' name='id' value='{{ $article->id }}'><br>
            content: {{ $article->content }}<br>
            <input type='submit' value='remove'>
    </form>

