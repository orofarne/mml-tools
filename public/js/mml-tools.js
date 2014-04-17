function initEditor() {
	var editor = ace.edit("editor");
	editor.setTheme("ace/theme/github");
	editor.getSession().setMode("ace/mode/pgsql");
	$('#editor').data('editor', editor);
}

function saveSql(layer, sql) {
	var sql = $('#editor').data('editor').getSession().getValue();
	var sqlmsg = $('#sqlmsg');

	sqlmsg.text('processing...');
	sqlmsg.attr('class', 'label label-info');

	$.post('/edit/' + layer, sql)
		.done(function(data) {
			$('#page').html(data);
		})
		.fail(function() {
			alert('error');
		});
}
