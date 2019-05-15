    create<br>

    <form action='{{ route('article_create') }}' method='post'>
        {{ csrf_field() }}
            content:<input type='text' name='content'><br>
            <input type='submit' value='submit'>
    </form>
