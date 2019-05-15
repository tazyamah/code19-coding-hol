list<br>
<table>
  <tr>
    <th>
      ID
    </th>
    <th>
      CONTENT
    </th>
    <th>
    </th>
    <th>
    </th>
  </tr>
  @foreach($articles as $article)
    <tr>
      <td>{{ $article->id }}</td>
      <td>{{ $article->content }}</td>
      <td><a href="{{ route('article_edit') }}?id={{ $article->id }}">edit</a></td>
      <td><a href="{{ route('article_delete') }}?id={{ $article->id }}">delete</a></td>
    </tr>
  @endforeach
</table>
<a href="{{ route('article_add') }}">new</a>
