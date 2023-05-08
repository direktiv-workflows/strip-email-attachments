<h2>Original email</h2>
<br>{{message}}
<br>
<br>
<h2>Attachment(s) location</h2>
<table style="text-align:left">
  <tr>
    <th>Attachment Name</th>
    <th>URL</th>
  </tr>{{#files}}
    <tr>
      <td>{{name}}</td>
      <td>https://{{storageaccount}}.blob.core.windows.net/emails/{{name}}</td>
    </tr>
  {{/files}}
</table>