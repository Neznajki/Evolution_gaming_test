class window.DataAsker
	constructor: (explanation, needClear, parent, callback) ->
		$('#explain').html explanation;
		$('#error').hide();
		
		if needClear
			$('#askField').val('');
		else
			$('#askField').hide();
		
		$('#dataAsker').show();
		$('#askField').focus().keyup @keyFunctionality;
		
		#log callback;

		$('#cancel').click @cancel;
		$('#ok').click {callback: callback, parent: parent}, @confirm;

		#alert(11);

	confirm: (event) ->
		callback = event.data.callback;
		parent = event.data.parent;
		#log event;
		result = $('#askField').val();

		if empty result
			$('#error').show().html 'you must enter something before confirmation';
			error = true;
		#log error;
		if empty error
			$('#cancel').click(); #after we confirmed we don't need this class;
			callback(result,parent);
			
			
	cancel: () ->
		$('#dataAsker').hide();
		$('#ok').off('click');
		$('#cancel').off('click');
		$('#askField').show();

	keyFunctionality: (event) ->
		if(event.keyCode is 13) #enter
			$('#ok').click();
		else if (event.keyCode is 27) #escape
			$('#cancel').click();