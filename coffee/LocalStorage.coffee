log 'loaded Local Storage'
class window.LS
	constructor: (@name) ->
		
	save: (object) ->
		#log 'saving';
		#log object;
		#log @name;
		saving = JSON.stringify object;
		localStorage.setItem @name, saving;
			
	load: (section = false) ->
		result = localStorage.getItem @name;
		if empty result
			result = {};
		else
			result = JSON.parse(result);
			
		return result
		