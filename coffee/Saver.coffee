class window.Saver
	constructor: (@sessionsContainer) ->
		
	save: (event) ->
		self = event.data;
		if empty self.saveName
			new window.DataAsker "Please type in save name:", true, self, self.saveNameRecived;
		else
			self.saveCurrentState(self.saveName, self);

	saveNameRecived: (saveName, self) ->
		#log this;
		self.LS = new window.LS self.sessionsContainer;
		self.existingSaves = self.LS.load();

		if self.existingSaves[saveName] is true
			#alert(1);
			new window.DataAsker "save already exists if you would like override old one push confirm", false, self, self.saveCurrentState;
		else
			#alert(2);
			self.saveCurrentState(saveName,self);	

	saveCurrentState: (saveName, self) ->
		if typeof self.LS is 'object'
			self.existingSaves[saveName] = true;
			self.LS.save self.existingSaves;
			delete self.existingSaves;
			delete self.LS;
		
		LS = new window.LS saveName;
		LS.save Tree.getTree();

		self.generateSelect();
		self.saveName = saveName;

		$('#saveInformation').html 'data saved to save ' + saveName;
		clearFunction = -> $('#saveInformation').html '';
		setTimeout clearFunction, 1000;
		
		#log self.saveName;

	load: () ->
		selectedSave = $('#saveSelector').val();
		if not empty selectedSave
			LS = new window.LS selectedSave
			Tree.setTree LS.load();
			#log Tree;
			Tree.draw();

	generateSelect: () ->
		LS = new window.LS @sessionsContainer;
		existingSaves = LS.load();
		saveSelector = $('#saveSelector');
		saveSelector.empty();
		for saveName,exists of existingSaves
			saveSelector.append($('<option></option>').val(saveName).html(saveName));