window.log = (text) ->
	
	try
		undefined.error
		alert 1;
	catch e
		console.info text,'\n' + e.stack;
	

window.empty = (obj) ->
	return true if obj is 'undefined';
	return false if obj is true;
	return true if not obj? or obj.length is 0;

	return false if obj.length? and obj.length > 0;

	for key of obj
		return false if Object.prototype.hasOwnProperty.call(obj,key);

	return true;