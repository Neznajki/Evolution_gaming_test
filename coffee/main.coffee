LS = new window.LS 'testing';
LS.save {testing:'works'};
LoadTest = LS.load();
#log LoadTest;


$ ->
	Saver = new window.Saver '!@saved sessions@!';
	$('#save').click Saver, Saver.save;
	$('#load').click Saver, Saver.load;
	Saver.generateSelect();
	window.Tree = new window.Tree 'root';

